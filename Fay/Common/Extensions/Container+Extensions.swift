//
//  Container+Extensions.swift
//  Fay
//
//  Created by Kyle Jennings on 7/13/24.
//

import Foundation
import Factory

extension Container {
    var authService: Factory<AuthService> {
        Factory(self) { AuthProvider() }
            .shared
    }

    var appointmentService: Factory<AppointmentService> {
        Factory(self) { AppointmentProvider() }
            .shared
    }
}
