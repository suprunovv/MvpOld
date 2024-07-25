// ProfileViewController.swift
// Copyright © RoadMap. All rights reserved.

import Photos
import UIKit

/// протокол представления профиля
protocol ProfileViewProtocol: AnyObject {
    /// Обновление страницы пофиля
    func updateProfile(profileCells: ProfileConfiguration.ProfileCells)
    /// Вывод UI для изменения имени
    func showNameEdit(title: String, currentName: String)
    /// Анимированная презентация terms
    func animateTermsView(_ termsView: TermsView)
    /// Открытие галереи с фото
    func openPhotoGalery()
}

/// Профиль
final class ProfileViewController: UIViewController {
    // MARK: - Types

    typealias ProfileCells = ProfileConfiguration.ProfileCells
    typealias TermsViewState = ProfilePresenter.TermsViewState

    // MARK: - Constants

    private enum Constants {
        static let title = "Profile"
        static let cancelEditNameButtonText = "Cancel"
        static let submitEditNameButtonText = "Ok"
        static let editNameTextFieldPlaceholder = "Name Surname"
        static let termsTopOffset: CGFloat = 44
    }

    // MARK: - Visual Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: ProfileInfoCell.reuseID)
        tableView.register(ProfileSettingCell.self, forCellReuseIdentifier: ProfileSettingCell.reuseID)
        tableView.disableAutoresizingMask()
        return tableView
    }()

    private lazy var editNameAlert: UIAlertController = {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let submitHandler: (UIAlertAction) -> Void = { [weak self, weak alert] _ in
            if let updatedName = alert?.textFields?[0].text {
                self?.presenter?.handleNameChanged(updatedName)
            }
        }
        alert.addTextField { $0.placeholder = Constants.editNameTextFieldPlaceholder }
        let cancelAction = UIAlertAction(title: Constants.cancelEditNameButtonText, style: .cancel)
        let submitAction = UIAlertAction(
            title: Constants.submitEditNameButtonText,
            style: .default,
            handler: submitHandler
        )
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        alert.preferredAction = submitAction
        return alert
    }()

    // MARK: - Public Properties

    var presenter: ProfilePresenter?

    // MARK: - Private Properties

    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        return imagePicker
    }()

    private var termsView: TermsView?
    private let termsHeight = UIScreen.main.bounds.height - Constants.termsTopOffset
    private var visualEffectView: UIVisualEffectView?
    private var runingAnimations: [UIViewPropertyAnimator] = []
    private var animationProgressWhenInterrupted: CGFloat = 0

    private var profileCells: ProfileCells = []

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupView()
        presenter?.refreshProfileData()
        presenter?.screenLoaded()
    }

    // MARK: - Private methods

    private func setupNavigationItem() {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 28)
        label.textColor = .black
        label.text = Constants.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }

    private func setupView() {
        view.addSubview(tableView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTermsView() {
        visualEffectView = UIVisualEffectView()
        guard let visualEffectView = visualEffectView else { return }
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)

        termsView?.delegate = self
        termsView?.frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height - termsHeight / 2,
            width: view.bounds.width,
            height: termsHeight
        )
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTermsPan(recognizer:)))
        termsView?.handleView.addGestureRecognizer(panRecognizer)
    }

    private func animateTransitionIfNeeded(state: TermsViewState, duration: TimeInterval) {
        if runingAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) { [weak self] in
                guard let self = self else { return }
                switch state {
                case .expanded:
                    self.termsView?.frame.origin.y = UIScreen.main.bounds.height - self.termsHeight
                case .collapsed:
                    self.termsView?.frame.origin.y = UIScreen.main.bounds.height - self.termsHeight / 2
                }
            }

            frameAnimator.addCompletion { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.finishTermsPanGesture()
                self.runingAnimations.removeAll()
            }

            frameAnimator.startAnimation()
            runingAnimations.append(frameAnimator)

            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView?.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView?.effect = nil
                }
            }
            blurAnimator.startAnimation()
            runingAnimations.append(blurAnimator)
        }
    }

    private func startInteractiveTransition(state: TermsViewState, duration: TimeInterval) {
        if runingAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runingAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }

    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runingAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }

    private func continueInteractiveTransition() {
        for animator in runingAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

    @objc func handleTermsPan(recognizer: UIPanGestureRecognizer) {
        guard let presenter = presenter else { return }
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: presenter.nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: termsView?.handleView)
            var fractionComplete = translation.y / termsHeight
            fractionComplete = presenter.isTermsVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
}

// MARK: - ProfileViewController + UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileCells[indexPath.row]
        switch cell {
        case let .profile(profileInfo):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoCell.reuseID) as? ProfileInfoCell
            else { return .init() }
            cell.delegate = self
            cell.configureCell(profileInfo)
            return cell
        case let .setting(profileSetting):
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: ProfileSettingCell.reuseID) as? ProfileSettingCell
            else { return .init() }
            cell.configureCell(profileSetting)
            return cell
        }
    }
}

// MARK: - ProfileViewController + UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = profileCells[indexPath.row]
        switch cell {
        case let .setting(profileSetting):
            presenter?.settingSelected(profileSetting.type)
        default:
            break
        }
    }
}

// MARK: - ProfileViewController + ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func openPhotoGalery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func animateTermsView(_ termsView: TermsView) {
        self.termsView = termsView
        setupTermsView()
    }

    func showNameEdit(title: String, currentName: String) {
        guard let nameTextField = editNameAlert.textFields?.first else { return }
        editNameAlert.title = title
        nameTextField.text = currentName
        present(editNameAlert, animated: true)
    }

    func updateProfile(profileCells: ProfileCells) {
        self.profileCells = profileCells
        tableView.reloadData()
    }
}

// MARK: - ProfileViewController + ProfileInfoCellDelegate

extension ProfileViewController: ProfileInfoCellDelegate {
    func openGalery() {
        presenter?.openGalery()
    }

    func editNameButtonTapped() {
        presenter?.editNameButtonTapped()
    }
}

// MARK: - ProfileViewController + TermsViewDelegate

extension ProfileViewController: TermsViewDelegate {
    func hideTermsView() {
        presenter?.hideTerms()
        visualEffectView?.removeFromSuperview()
    }
}

// MARK: - ProfileViewController + UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.originalImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 0.5)
        else {
            return
        }
        presenter?.updateAvatar(imageData: imageData)
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ProfileViewController + UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
