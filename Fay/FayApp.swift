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
            NavigationStack(path: $navModel.destinations) {
                SpinningLogoView()
                    .frame(width: 80, height: 80)
                    .environmentObject(navModel)
                    .navigationDestination(for: AppDestination.self) { destination in
                        switch destination {
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
    }
}
