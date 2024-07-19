//
//  Appointment+Mock.swift
//  Fay
//
//  Created by Kyle Jennings on 7/19/24.
//

import Foundation

extension Appointment {
    static func getMock() -> Appointment {
        return Appointment(
            appointmentId: UUID().uuidString,
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: Date().addingTimeInterval(1000),
            end: Date().addingTimeInterval(2000),
            durationInMinutes: 10,
            recurrenceType: .weekly)
    }
}
