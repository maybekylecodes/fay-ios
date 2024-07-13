//
//  LoginViewModel.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {

    // Services
    let authService: AuthService = AuthProvider()

    // User Entered Data
    @Published var username = String()
    @Published var password = String()

    // View
    @Published var continueButtonEnabled = false

    // Navigation
    @Published var userLoggedIn = false

    // Combine
    private var cancellables = Set<AnyCancellable>()

    init() {
        setup()
    }

    private func setup() {
        setupSubscribers()
    }
}

// MARK: - Subscriber Setup
extension LoginViewModel {
    private func setupSubscribers() {
        setupUsernameAndPasswordSubscriber()
    }

    private func setupUsernameAndPasswordSubscriber() {
        Publishers.CombineLatest($username, $password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name, pass in
                self?.updateViewWith(name: name, pass: pass)
            }.store(in: &cancellables)
    }
}

// MARK: - Utility Functions
extension LoginViewModel {
    private func updateViewWith(name: String, pass: String) {
        continueButtonEnabled = !name.isEmpty && !pass.isEmpty && pass.count >= 3 // If we want to ensure a password is long enough, ideally would be something like 8
    }
}

// MARK: - User Actions
extension LoginViewModel {
    func continueTapped() {
        guard continueButtonEnabled else {
            // TODO: - Show Error
            return
        }

        // Usernames are generally case insensitive & don't have spaces or new lines
        let trimmedUsername = username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        Task {
            do {
                let userLogin = LoginUserPost(username: trimmedUsername,
                                              password: password)
                try await authService.loginUser(user: userLogin)
                userLoggedIn = true
            } catch {
                print(error)

                if let networkError = error as? NetworkError {
                    // TODO: - Throw error here with network error display text
                }
            }
        }
    }
}
