// DetailMarkerViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Контроллер детальной информации маркера
final class DetailMarkerViewController: UIViewController {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .nameLabel
        label.disableAutoresizingMask()
        return label
    }()

    private let addresLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.disableAutoresizingMask()
        return label
    }()

    private let discountLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.disableAutoresizingMask()
        return label
    }()

    private let promocodeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.disableAutoresizingMask()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(model: MarkersData) {
        nameLabel.text = "Shop `\(model.title)`"
        addresLabel.text = model.address
        discountLabel.text = "Your discount -30%"
        promocodeLabel.attributedText = getAtributetText()
    }

    private func setupView() {
        view.backgroundColor = .white
        setLabels()
    }

    private func getAtributetText() -> NSAttributedString {
        let prom = "Promocode"
        let promText = "RECIPE35"
        let atrString = NSMutableAttributedString(string: "\(prom) \(promText)")
        let promRange = NSRange(location: 0, length: prom.count)
        atrString.addAttribute(.font, value: UIFont.verdana(ofSize: 16) ?? .systemFont(ofSize: 16), range: promRange)
        let promTextRange = NSRange(location: prom.count + 1, length: promText.count)
        atrString.addAttribute(
            .font,
            value: UIFont.verdanaBold(ofSize: 16) ?? .boldSystemFont(ofSize: 16),
            range: promTextRange
        )
        return atrString
    }

    private func setLabels() {
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 49).activate()
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        view.addSubview(addresLabel)
        addresLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).activate()
        addresLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        view.addSubview(discountLabel)
        discountLabel.topAnchor.constraint(equalTo: addresLabel.bottomAnchor, constant: 43).activate()
        discountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        view.addSubview(promocodeLabel)
        promocodeLabel.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 25).activate()
        promocodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
    }
}
