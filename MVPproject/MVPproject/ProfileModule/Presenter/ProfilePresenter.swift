// ProfilePresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол презентера профиля
protocol ProfilePresenterProtocol: AnyObject {
    /// Обновление данных профиля
    func refreshProfileData()
    /// Обработка запроса на изменение имени
    func editNameButtonTapped()
    /// Обработка изменения имени
    func handleNameChanged(_ fullName: String)
    /// Показать бонусы
    func showBonuses()
    /// Показать terms
    func showTerms()
    /// Скрыть политики
    func hideTerms()
    /// Отобразить политики на экране
    func presentTerms(_ termsView: TermsView)
    /// Запрос на обработку конца вытягивания/сбрасывания terms
    func finishTermsPanGesture()
    /// Обработка выбора настройки
    func settingSelected(_ profileSetting: ProfileConfiguration.ProfileSettingType)
    /// Загрузка данных из мементо
    func loadMemento()
    /// Экран загружен
    func screenLoaded()
    /// Открытие галереи
    func openGalery()
    /// Обновление аватара
    func updateAvatar(imageData: Data)
}

/// Презентер экрана профиля
final class ProfilePresenter {
    /// Состояние вью политик
    enum TermsViewState {
        /// открытое
        case expanded
        /// схлопнутое
        case collapsed
    }

    var nextState: TermsViewState {
        isTermsVisible ? .collapsed : .expanded
    }

    private weak var profileCoordinator: ProfileCoordinator?
    private weak var view: ProfileViewProtocol?

    private var profileConfiguration = ProfileConfiguration.shared
    private(set) var isTermsVisible = false

    init(view: ProfileViewProtocol, coordinator: ProfileCoordinator) {
        self.view = view
        profileCoordinator = coordinator
    }
}

// MARK: - ProfilePresenter + ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    func screenLoaded() {
        TxtFileLoggerInvoker.shared.log(.viewScreen(ScreenInfo(title: "Profile")))
    }

    func updateAvatar(imageData: Data) {
        profileConfiguration.updateAvatarImage(data: imageData)
        Originator.shared.setUserAvatar(imageData: imageData)
        Originator.shared.saveToUserDefaults()
        view?.updateProfile(profileCells: profileConfiguration.profileTableCells)
    }

    func openGalery() {
        view?.openPhotoGalery()
    }

    func loadMemento() {
        Originator.shared.restoreFromUserDefaults()
    }

    func finishTermsPanGesture() {
        isTermsVisible.toggle()
    }

    func hideTerms() {
        profileCoordinator?.hideTerms()
    }

    func presentTerms(_ termsView: TermsView) {
        view?.animateTermsView(termsView)
    }

    func showTerms() {
        profileCoordinator?.showTerms()
    }

    func settingSelected(_ profileSettingType: ProfileConfiguration.ProfileSettingType) {
        switch profileSettingType {
        case .bonuses:
            showBonuses()
        case .terms:
            showTerms()
        case .map:
            showMap()
        default:
            break
        }
    }

    func showBonuses() {
        profileCoordinator?.showBonuses()
    }

    func showMap() {
        profileCoordinator?.showMap()
    }

    func handleNameChanged(_ fullName: String) {
        Originator.shared.setUserName(userName: fullName)
        Originator.shared.saveToUserDefaults()
        profileConfiguration.updateFullName(fullName)
        view?.updateProfile(profileCells: profileConfiguration.profileTableCells)
    }

    func editNameButtonTapped() {
        Originator.shared.restoreFromUserDefaults()
        view?.showNameEdit(
            title: "Change your name and surname",
            currentName: profileConfiguration.profileInfo.fullName
        )
    }

    func refreshProfileData() {
        view?.updateProfile(profileCells: profileConfiguration.profileTableCells)
    }
}
