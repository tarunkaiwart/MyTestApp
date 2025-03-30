//
//  UserListViewControllerTests.swift
//  MyTestAppTests
//
//  Created by Tarun Kaiwart on 30/03/25.
//

import XCTest

import XCTest
@testable import MyTestApp

import XCTest
@testable import MyTestApp

class UserListViewControllerTests: XCTestCase {

    var viewController: UserListViewController!
    var mockViewModel: MockUserViewModel!
    
    override func setUp() {
        super.setUp()
        
        // Initialize the mock ViewModel to control test behavior
        mockViewModel = MockUserViewModel()
        
        // Inject the mock ViewModel into the UserListViewController
        viewController = UserListViewController(viewModel: mockViewModel)
        
        // Load the view to trigger `viewDidLoad()`
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    // Test if the view controller is properly initialized
    func testViewControllerInitialization() {
        XCTAssertNotNil(viewController, "UserListViewController should be initialized")
        XCTAssertNotNil(viewController.view, "View should be loaded")
    }

    // Test if tableView is set up correctly
    func testTableViewSetup() {
        guard let tableView = viewController.getTableView() else {
            XCTFail("TableView should be accessible via helper method")
            return
        }
        
        XCTAssertNotNil(tableView, "TableView should be initialized")
        XCTAssertTrue(tableView.dataSource === viewController, "TableView dataSource should be set to viewController")
        XCTAssertTrue(tableView.delegate === viewController, "TableView delegate should be set to viewController")
    }
    
    // Test if fetchUsers() is called when view loads
    func testFetchUsersCalledOnViewLoad() {
        XCTAssertTrue(mockViewModel.fetchUsersCalled, "fetchUsers() should be called on viewDidLoad")
    }
    
    // Test number of rows in tableView
    func testNumberOfRowsInTableView() {
        // Simulate users being loaded
        //let username: String
//        let email: String
//        let address: Address?
//        let phone: String?
//        let website: String?
//        let company: Company?
        mockViewModel.users = [User(id: 1, name: "Tarun Kumar", username: "tarunkaiwart211", email: "tarunkaiwart211@yahoo.com", address: nil, phone: nil, website: nil, company: nil)]
        viewController.reloadTableView()
        
        guard let tableView = viewController.getTableView() else {
            XCTFail("TableView should be accessible via helper method")
            return
        }
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2, "TableView row count should match number of users")
    }

    // Test cellForRow method
    func testCellForRowAtIndexPath() {
        // Simulate users being loaded
        mockViewModel.users = [User(id: 1, name: "Tarun Kumar", username: "tarunkaiwart211", email: "tarunkaiwart211@yahoo.com", address: nil, phone: nil, website: nil, company: nil),
                               
        ]
        viewController.reloadTableView()
        
        guard let tableView = viewController.getTableView() else {
            XCTFail("TableView should be accessible via helper method")
            return
        }
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell?.textLabel?.text, "John Doe", "Cell should display correct user name")
    }
    
    // Test navigation when a row is selected
    func testDidSelectRow_NavigatesToUserDetail() {
        // Initialize mock navigation controller with viewController
        let mockNavigationController = MockNavigationController(rootViewController: viewController)

        // Simulate presenting it as the root view controller
        UIApplication.shared.windows.first?.rootViewController = mockNavigationController

        // Ensure the navigationController is correctly set
        RunLoop.current.run(until: Date()) // Allow UI updates

        // Simulate users being loaded
        mockViewModel.users = [User(id: 1, name: "Tarun Kumar", username: "tarunkaiwart211", email: "tarunkaiwart211@yahoo.com", address: nil, phone: nil, website: nil, company: nil)]
        viewController.reloadTableView()
        
        guard let tableView = viewController.getTableView() else {
            XCTFail("TableView should be accessible via helper method")
            return
        }
        
        // Simulate row selection
        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // Check if UserDetailViewController is pushed
        XCTAssertTrue(mockNavigationController.pushedViewController is UserDetailViewController, "Selecting a user should push UserDetailViewController")
    }

    // Test pull-to-refresh functionality
    func testPullToRefreshCallsFetchUsers() {
        viewController.triggerRefresh()
        XCTAssertTrue(mockViewModel.fetchUsersCalled, "Pull-to-refresh should call fetchUsers()")
    }
}

// MARK: - Mock ViewModel

class MockUserViewModel: UserViewModel {
    
    var fetchUsersCalled = false
    private var _mockUsers: [User] = []

        override var users: [User] {
            get { return _mockUsers }
            set { _mockUsers = newValue }
        }

    override func fetchUsers() {
        fetchUsersCalled = true
        self.onDataUpdate?() // Simulate data update callback
    }
}

// MARK: - Mock NavigationController

class MockNavigationController: UINavigationController {
    
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: false)
    }
}

// MARK: - Extensions for Accessibility

extension UserListViewController {
    /// Provides access to tableView for testing
    func getTableView() -> UITableView? {
        return self.value(forKey: "tableView") as? UITableView
    }
    
    /// Forces tableView to reload data (helper for tests)
    func reloadTableView() {
        getTableView()?.reloadData()
    }
}
