//
//  LoginViewModelTests.swift
//  FayTests
//
//  Created by Kyle Jennings on 7/13/24.
//

import XCTest
import Factory
import Combine

@testable import Fay
@MainActor
final class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!
    private var cancelables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        Container.shared.authService.register { MockAuthProvider() }
        viewModel = LoginViewModel()
    }

    func testContinueButtonEnabled() throws {
        let expectation = expectation(description: "Continue button should only be enabled if username and password are not empty and password has 3 or more characters")
        var expectedValues = [false, false, false, true]
        viewModel.$continueButtonEnabled
            .dropFirst(2) // Drop initial false values
            .sink { data in
                XCTAssertEqual(data, expectedValues.removeFirst())
                if expectedValues.isEmpty {
                    expectation.fulfill()
                }
            }.store(in: &cancelables)
        viewModel.username = "j"
        viewModel.password = "1"
        viewModel.password = "12"
        viewModel.password = "123"
        wait(for: [expectation], timeout: 1.0)
    }

    func testIsLoggingIn() throws {
        let expectation = expectation(description: "When a user tries to login, this value should be true, but then false on failure")
        var expectedValues = [true, false]
        viewModel.$isLoggingIn
            .dropFirst()
            .sink { data in
                print(data)
                XCTAssertEqual(data, expectedValues.removeFirst())
                if expectedValues.isEmpty {
                    expectation.fulfill()
                }
            }.store(in: &cancelables)
        viewModel.continueButtonEnabled = true
        viewModel.continueTapped()
        wait(for: [expectation], timeout: 1.0)
    }

    func testToastModelOnFailure() throws {
        let expectation = expectation(description: "If a user fails to login, a toast model should be added")
        viewModel.$toastModel
            .dropFirst() // Drop initial nil value
            .sink { data in
                XCTAssertNotNil(data)
                expectation.fulfill()
            }.store(in: &cancelables)
        viewModel.username = "j"
        viewModel.password = "1234"
        viewModel.continueButtonEnabled = true
        viewModel.continueTapped()
        wait(for: [expectation], timeout: 1.0)
    }
}
