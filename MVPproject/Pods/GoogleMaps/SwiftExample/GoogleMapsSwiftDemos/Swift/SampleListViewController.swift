// SampleListViewController.swift
// Copyright © RoadMap. All rights reserved.

import GoogleMaps
import UIKit

class SampleListViewController: UIViewController {
    static let sampleCellIdentifier = "sampleCellIdentifier"

    let sampleSections = Samples.allSamples()
    lazy var tableView: UITableView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: SampleListViewController.sampleCellIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SampleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sampleSections[section].samples.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SampleListViewController.sampleCellIdentifier, for: indexPath
        )
        if let sample = sample(at: indexPath) {
            cell.textLabel?.text = sample.title
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sampleSections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sampleSections[section].name
    }

    func sample(at indexPath: IndexPath) -> Sample? {
        guard indexPath.section >= 0, indexPath.section < sampleSections.count else { return nil }
        let section = sampleSections[indexPath.section]
        guard indexPath.row >= 0, indexPath.row < section.samples.count else { return nil }
        return section.samples[indexPath.row]
    }
}

extension SampleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let sample = sample(at: indexPath) {
            let viewController = sample.viewControllerClass.init()
            viewController.title = sample.title
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
