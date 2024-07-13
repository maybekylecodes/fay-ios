//
//  AppNavigationModel.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation

class AppNavigationModel: ObservableObject {

    @Published var currentScreen: AppDestination = .launch

    init() {
        setup()
    }

    private func setup() {
        setupCurrentScreen()
    }

    private func setupCurrentScreen() {
        currentScreen = isUserLoggedIn() ? .appointments : .login
    }

    private func isUserLoggedIn() -> Bool {
        // Here we would want to check the user's token validity & potentially refresh it if needed
        if let _ = try? KeychainManager.getKeychainString(keyId: .authToken) {
            // We have a token in keychain already, we can assume the user has logged in
            return true
        }
        return false
    }

    func navigate(to destination: AppDestination) {
        guard currentScreen != destination else {
            return
        }

        currentScreen = destination
    }
}
