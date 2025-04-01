//
//  UserDetailViewControllerTests.swift
//  MyTestAppTests
//
//  Created by Tarun Kaiwart on 01/04/25.
//

import XCTest
import XCTest
@testable import MyTestApp

class UserDetailViewControllerTests: XCTestCase {

    var viewController: UserDetailViewController!
    var mockViewModel: MockUserDetailViewModel!

    override func setUp() {
        super.setUp()
        
        // Initialize the mock ViewModel with sample data
              let mockAddress = User.Address(street: "123 Main St", suite: "Apt 4", city: "New York", zipcode: "10001", geo: nil)
        let userDetail = UserDetail(user: User())

              // Initialize the mock ViewModel
              mockViewModel = MockUserDetailViewModel(userDetail: userDetail)

              // Initialize the UserDetailViewController with the mock ViewModel
              viewController = UserDetailViewController(userDetailViewModel: mockViewModel)

        
        // Load the view to trigger viewDidLoad()
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    // Test if the view controller is properly initialized
    func testViewControllerInitialization() {
        XCTAssertNotNil(viewController, "UserDetailViewController should be initialized")
        XCTAssertNotNil(viewController.view, "View should be loaded")
    }

    // Test if the view's background color is set correctly (supports dark mode)
    func testBackgroundColor() {
        XCTAssertEqual(viewController.view.backgroundColor, UIColor.systemBackground, "View background color should support dark mode")
    }
    
    // Test if the labels are correctly initialized with values from the ViewModel
    func testLabelContent() {
        let emailLabel = viewController.view.subviews.compactMap { $0 as? UILabel }.first { $0.text?.contains("Email:") == true }
        let phoneLabel = viewController.view.subviews.compactMap { $0 as? UILabel }.first { $0.text?.contains("Phone:") == true }
        let addressLabel = viewController.view.subviews.compactMap { $0 as? UILabel }.first { $0.text?.contains("Address:") == true }

        XCTAssertNotNil(emailLabel, "Email label should be present")
        XCTAssertEqual(emailLabel?.text, "Email: john.doe@example.com", "Email label should display correct email")
        
        XCTAssertNotNil(phoneLabel, "Phone label should be present")
        XCTAssertEqual(phoneLabel?.text, "Phone: 123-456-7890", "Phone label should display correct phone number")
        
        XCTAssertNotNil(addressLabel, "Address label should be present")
        XCTAssertEqual(addressLabel?.text, "Address: 123 Main St, New York, 10001", "Address label should display correct address")
    }

    // Test if the stack view is correctly laid out
    func testStackViewLayout() {
        guard let stackView = viewController.view.subviews.compactMap({ $0 as? UIStackView }).first else {
            XCTFail("StackView should be present")
            return
        }
        
        // Ensure the stack view contains 3 labels (email, phone, address)
        XCTAssertEqual(stackView.arrangedSubviews.count, 3, "StackView should contain 3 labels")
    }

    // Test if accessibility labels are set correctly
    func testAccessibilityLabels() {
        let emailLabel = viewController.view.subviews.compactMap { $0 as? UILabel }.first { $0.text?.contains("Email:") == true }
        let phoneLabel = viewController.view.subviews.compactMap { $0 as? UILabel }.first { $0.text?.contains("Phone:") == true }
        let addressLabel = viewController.view.subviews.compactMap { $0 as? UILabel }.first { $0.text?.contains("Address:") == true }

        XCTAssertTrue(emailLabel?.isAccessibilityElement ?? false, "Email label should be accessible")
        XCTAssertEqual(emailLabel?.accessibilityLabel, "Email: john.doe@example.com", "Email label accessibility label should be set correctly")
        
        XCTAssertTrue(phoneLabel?.isAccessibilityElement ?? false, "Phone label should be accessible")
        XCTAssertEqual(phoneLabel?.accessibilityLabel, "Phone: 123-456-7890", "Phone label accessibility label should be set correctly")
        
        XCTAssertTrue(addressLabel?.isAccessibilityElement ?? false, "Address label should be accessible")
        XCTAssertEqual(addressLabel?.accessibilityLabel, "Address: 123 Main St, New York, 10001", "Address label accessibility label should be set correctly")
    }

    // Test if the correct title is set in the navigation bar
    func testTitle() {
        XCTAssertEqual(viewController.title, "John Doe", "Title should be set to full name")
    }
}

// MARK: - Mock ViewModel
class MockUserDetailViewModel: UserDetailViewModel {

    // Mock properties
    var mockFullName: String
    var mockEmail: String
    var mockPhone: String
    var mockAddress: User.Address?

    // Custom initializer to pass `UserDetail` to the parent class
    override init(userDetail: UserDetail) {
        self.mockFullName = userDetail.name
        self.mockEmail = userDetail.email
        self.mockPhone = userDetail.phone
        self.mockAddress = userDetail.address

        // Call the parent class initializer and pass the userDetail
        super.init(userDetail: userDetail)
    }

    // Override the computed properties
    override var fullName: String {
        return mockFullName
    }

    override var email: String {
        return mockEmail
    }

    override var phone: String {
        return mockPhone
    }

    override var address: String {
        guard let address = mockAddress else { return "No address available" }
        return "\(address.street ?? ""), \(address.city ?? ""), \(address.zipcode ?? "")"
    }
}

