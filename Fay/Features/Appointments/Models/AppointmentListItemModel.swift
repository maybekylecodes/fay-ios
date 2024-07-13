//
//  AppointmentListItemModel.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation

struct AppointmentListItemModel: Hashable, Identifiable {
    let id: String
    let title: String
    let timeRange: String
    let recurrence: String
    let month: String
    let day: String
}

extension AppointmentListItemModel {
    static func getMock() -> AppointmentListItemModel {
        return AppointmentListItemModel(
            id: UUID().uuidString,
            title: "Follow up with Taylor Palmer, RD",
            timeRange: "11:00 AM - 12:00 PM (PT)",
            recurrence: "Weekly",
            month: "NOV",
            day: "12")
    }
}

extension AppointmentListItemModel {
    init(appointment: Appointment) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current

        // Format time range
        dateFormatter.dateFormat = "h:mm a"
        let startTime = dateFormatter.string(from: appointment.start)
        let endTime = dateFormatter.string(from: appointment.end)
        let timeZoneAbbreviation = TimeZone.current.abbreviation() ?? "PDT" // Assuming my own time zone

        // Format month and day
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: appointment.start).uppercased()
        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: appointment.start)

        self.init(
            id: appointment.appointmentId,
            title: "\(appointment.appointmentType.rawValue) with Taylor Palmer, RD", // Since we don't have the actual metadata
            timeRange: "\(startTime) - \(endTime) (\(timeZoneAbbreviation))",
            recurrence: appointment.recurrenceType.rawValue,
            month: month,
            day: day
        )
    }
}
