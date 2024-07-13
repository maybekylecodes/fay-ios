//
//  AppointmentsViewModelTests.swift
//  FayTests
//
//  Created by Kyle Jennings on 7/13/24.
//

import XCTest
import Factory
import Combine

@testable import Fay

@MainActor
final class AppointmentsViewModelTests: XCTestCase {

    private var viewModel: AppointmentsViewModel!
    private var cancelables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        Container.shared.appointmentService.register { MockAppointmentProvider() }
        viewModel = AppointmentsViewModel()
    }

    func testAppointmentLoads() throws {
        let expectation = expectation(description: "Appointment models should load with 3 models")
        var expectedCounts = [0, 0, 3]
        viewModel.$appointmentModels
            .sink { data in
                XCTAssertEqual(data.count, expectedCounts.removeFirst())
                if expectedCounts.isEmpty {
                    expectation.fulfill()
                }
            }.store(in: &cancelables)
        wait(for: [expectation], timeout: 1.0)
    }

    func testSelectedStatusUpdate() throws {
        let expectation = expectation(description: "When updating to past, we should expect 0 models")
        var expectedCounts = [0, 0, 0, 0]
        viewModel.$appointmentModels
            .sink { data in
                print(data)
                XCTAssertEqual(data.count, expectedCounts.removeFirst())
                if expectedCounts.isEmpty {
                    expectation.fulfill()
                }
            }.store(in: &cancelables)

        viewModel.selectedStatus = .past
        wait(for: [expectation], timeout: 1.0)
    }

    func testUserTappedSignOut() throws {
        let expectation = expectation(description: "showSignOutAlert should be true after user taps sign out button")
        viewModel.$showSignOutAlert
            .dropFirst() // Removing first false value
            .sink { data in
                XCTAssertTrue(data)
                expectation.fulfill()
            }.store(in: &cancelables)
        viewModel.signOutTapped()
        wait(for: [expectation], timeout: 1.0)
    }

    func testUserSignedOut() throws {
        let expectation = expectation(description: "User signed out should be true after sign out")
        viewModel.$userSignedOut
            .dropFirst() // Removing first false value
            .sink { data in
                XCTAssertTrue(data)
                expectation.fulfill()
            }.store(in: &cancelables)
        viewModel.signOut()
        wait(for: [expectation], timeout: 1.0)
    }
}
