//
//  UserDetailViewController.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 27/03/25.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    private let userDetailViewModel: UserDetailViewModel

    // MARK: - Initializers

    init(userDetailViewModel: UserDetailViewModel) {
        self.userDetailViewModel = userDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // Configure UI elements
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground // Supports Dark Mode
        title = userDetailViewModel.fullName

        let emailLabel = createLabel(text: "Email: \(userDetailViewModel.email)")
        let phoneLabel = createLabel(text: "Phone: \(userDetailViewModel.phone ?? "N/A")")
        let addressLabel = createLabel(text: "Address: \(userDetailViewModel.address))")

        let stackView = UIStackView(arrangedSubviews: [emailLabel, phoneLabel, addressLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Accessibility enhancement: Announce screen change
        UIAccessibility.post(notification: .screenChanged, argument: "\(userDetailViewModel.fullName)'s details displayed")
    }

    // MARK: - Helper Methods

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.label // Supports Dark Mode
        label.isAccessibilityElement = true // Enables VoiceOver support
        label.accessibilityLabel = text // Accessibility support
        return label
    }

    private func formatAddress(_ address: User.Address?) -> String {
        guard let address = address else { return "N/A" }
        return "\(address.street ?? ""), \(address.city ?? ""), \(address.zipcode ?? "")"
    }
}
