//
//  UserDetailViewController.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 27/03/25.
//

import UIKit

class UserDetailViewController: UIViewController {
    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = user.name

        let emailLabel = createLabel(text: "Email: \(user.email)")
        let phoneLabel = createLabel(text: "Phone: \(user.phone ?? "N/A")")
        let addressLabel = createLabel(text: "Address: \(formatAddress(user.address))")

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
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    private func formatAddress(_ address: User.Address?) -> String {
        guard let address = address else { return "N/A" }
        return "\(address.street ?? ""), \(address.city ?? ""), \(address.zipcode ?? "")"
    }
}
