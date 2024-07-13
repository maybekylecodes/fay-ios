//
//  FayApp.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

@main
struct FayApp: App {

    @StateObject private var navModel = AppNavigationModel()

    var body: some Scene {
        WindowGroup {
            switch navModel.currentScreen {
            case .launch:
                PulsingLogoView()
                    .frame(width: 80, height: 80)

            case .login:
                LoginView()
                    .environmentObject(navModel)

            case .appointments:
                AppointmentsView()
                    .environmentObject(navModel)
            }
        }
    }
}
