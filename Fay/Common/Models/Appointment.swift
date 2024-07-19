//
//  Appointment.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation

struct Appointment: Decodable {
    let appointmentId: String
    let patientId: String
    let providerId: String
    let status: AppointmentStatus
    let appointmentType: AppointmentType
    let start: Date
    let end: Date
    let durationInMinutes: Int
    let recurrenceType: AppointmentRecurrenceType
}

enum AppointmentStatus: String, Hashable, Decodable {
    case scheduled = "Scheduled"
    case occurred = "Occurred"
}

enum AppointmentType: String, Hashable, Decodable {
    case followUp = "Follow-up"
    case initialConsult = "Initial consultation"
}

enum AppointmentRecurrenceType: String, Hashable, Decodable {
    case weekly = "Weekly"
    case monthly = "Monthly"
}


struct AppointmentResponse: Decodable {
    let appointments: [Appointment]
}
