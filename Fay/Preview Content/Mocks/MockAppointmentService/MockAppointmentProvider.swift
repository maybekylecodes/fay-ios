//
//  MockAppointmentProvider.swift
//  Fay
//
//  Created by Kyle Jennings on 7/19/24.
//

import Foundation

class MockAppointmentProvider: AppointmentService {
    func getAppointments() async throws -> AppointmentResponse {
        return AppointmentResponse(appointments: [Appointment.getMock(),
                                                  Appointment.getMock(),
                                                  Appointment.getMock()])
    }
}
