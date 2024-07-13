//
//  AppointmentService.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation

protocol AppointmentService: AnyObject {
    func getAppts() async throws -> AppointmentResponse
}

class AppointmentProvider: AppointmentService {

    func getAppts() async throws -> AppointmentResponse {
        let response: AppointmentResponse = try await NetworkClient.getDecodableObject(path: "appointments")
        return response
    }
}

class MockAppointmentProvider: AppointmentService {
    func getAppts() async throws -> AppointmentResponse {
        return AppointmentResponse(appointments: [Appointment.getMock(), 
                                                  Appointment.getMock(),
                                                  Appointment.getMock()])
    }
}
