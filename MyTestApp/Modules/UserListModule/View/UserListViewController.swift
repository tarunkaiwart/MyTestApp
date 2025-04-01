//
//  UserListViewController.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import UIKit
class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // TableView to display the list of users
       private var tableView = UITableView()
       
       // Refresh control to enable pull-to-refresh functionality
       private let refreshControl = UIRefreshControl()
       
       // ViewModel instance for managing user data and business logic
       private var userViewModel: UserViewModel

       // MARK: - Initializers

       // Dependency Injection for ViewModel, allowing default initialization if not provided
       init(viewModel: UserViewModel = UserViewModel()) {
           self.userViewModel = viewModel
           super.init(nibName: nil, bundle: nil)
       }

       // Required initializer when using storyboards (not implemented since UI is programmatic)
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       // MARK: - View Lifecycle

       override func viewDidLoad() {
           super.viewDidLoad()
           
           setupUI()        // Configure UI elements
           setupBindings()  // Bind ViewModel callbacks
           userViewModel.fetchUsers() // Fetch initial user data
       }

       // MARK: - UI Setup

       /// Configures the UI components and layout with Dark Mode and Accessibility support
       private func setupUI() {
           view.backgroundColor = UIColor.systemBackground // Supports Dark Mode
           tableView = UITableView(frame: self.view.bounds, style: .plain)
           tableView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(tableView)

           // Add pull-to-refresh functionality
           tableView.refreshControl = refreshControl
           refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
           refreshControl.accessibilityLabel = "Pull to refresh user list" // Accessibility support

           // Set up AutoLayout constraints for tableView
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])

           // Set tableView's delegate and data source
           tableView.dataSource = self
           tableView.delegate = self

           // Register a default UITableViewCell for reuse
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       }

       // MARK: - ViewModel Bindings

       /// Binds ViewModel's data update and error handling callbacks
       private func setupBindings() {
           userViewModel.onDataUpdate = { [weak self] in
               DispatchQueue.main.async {
                   self?.tableView.reloadData()   // Reload tableView when data updates
                   self?.refreshControl.endRefreshing() // Stop refreshing animation
                   UIAccessibility.post(notification: .announcement, argument: "User list updated") // Accessibility: VoiceOver announces update
               }
           }
           userViewModel.onError = { [weak self] message in
               DispatchQueue.main.async {
                   self?.showErrorAlert(message) // Display an alert in case of an error
               }
           }
       }

       // MARK: - Actions

       /// Triggers data refresh when user pulls down on the table view
       @objc private func refreshData() {
           userViewModel.fetchUsers()
       }
       
       #if DEBUG
       // Expose `refreshData()` only for testing
       func triggerRefresh() {
           refreshData()
       }
       #endif

       /// Displays an error alert with the given message
       private func showErrorAlert(_ message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
           UIAccessibility.post(notification: .announcement, argument: "Error: \(message)") // Accessibility: VoiceOver announces error
       }

       // MARK: - UITableViewDataSource Methods

       /// Returns the number of rows in the tableView, equal to the number of users
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return userViewModel.users.count
       }

       /// Configures and returns a cell for each row in the tableView
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let user = userViewModel.users[indexPath.row]
           cell.textLabel?.text = user.name // Display user's name in the cell
           cell.textLabel?.textColor = UIColor.label // Supports Dark Mode by adapting text color
           cell.isAccessibilityElement = true // Enables VoiceOver for each cell
           cell.accessibilityLabel = "User: \(user.name)" // Accessibility: Readable name
           return cell
       }
       
       // MARK: - UITableViewDelegate Methods

       /// Handles row selection and navigates to the user detail screen
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedUser = userViewModel.users[indexPath.row]
           let userDetail = UserDetail(user: selectedUser)
           let userDetailViewModel = UserDetailViewModel(userDetail: userDetail)
           let detailVC = UserDetailViewController(userDetailViewModel: userDetailViewModel)
           navigationController?.pushViewController(detailVC, animated: true)
       }
}
