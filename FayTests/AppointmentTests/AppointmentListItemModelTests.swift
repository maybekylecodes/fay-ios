//
//  AppointmentListItemModelTests.swift
//  FayTests
//
//  Created by Kyle Jennings on 7/13/24.
//

import XCTest

@testable import Fay
final class AppointmentListItemModelTests: XCTestCase {

    func testInitializationFromAppointment() throws {
            let mockDate = Date(timeIntervalSince1970: 1625097600) // July 1, 2021, 12:00 PM UTC
            let mockAppointment = Appointment(
                appointmentId: "test-id",
                patientId: "patient-1",
                providerId: "provider-100",
                status: .scheduled,
                appointmentType: .followUp,
                start: mockDate,
                end: mockDate.addingTimeInterval(3600),
                durationInMinutes: 60,
                recurrenceType: .weekly
            )

            let listItemModel = AppointmentListItemModel(appointment: mockAppointment)

            XCTAssertEqual(listItemModel.id, "test-id")
            XCTAssertEqual(listItemModel.title, "Follow-up with Taylor Palmer, RD")

            XCTAssertTrue(listItemModel.timeRange.contains("- "))
            XCTAssertTrue(listItemModel.timeRange.contains("AM") || listItemModel.timeRange.contains("PM"))
            XCTAssertTrue(listItemModel.timeRange.hasSuffix(")"))

            XCTAssertEqual(listItemModel.recurrence, "Weekly")

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current

            dateFormatter.dateFormat = "MMM"
            XCTAssertEqual(listItemModel.month, dateFormatter.string(from: mockDate).uppercased())

            dateFormatter.dateFormat = "d"
            XCTAssertEqual(listItemModel.day, dateFormatter.string(from: mockDate))
        }

    func testInitializationWithDifferentAppointmentTypes() throws {
        let followUpAppointment = Appointment.getMock()
        let followUpModel = AppointmentListItemModel(appointment: followUpAppointment)
        XCTAssertTrue(followUpModel.title.starts(with: "Follow-up"))

        let initialConsultAppointment = Appointment(
            appointmentId: UUID().uuidString,
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .initialConsult,
            start: Date(),
            end: Date().addingTimeInterval(3600),
            durationInMinutes: 60,
            recurrenceType: .weekly
        )
        let initialConsultModel = AppointmentListItemModel(appointment: initialConsultAppointment)
        XCTAssertTrue(initialConsultModel.title.starts(with: "Initial consultation"))
    }

    func testInitializationWithDifferentRecurrenceTypes() throws {
        let weeklyAppointment = Appointment.getMock()
        let weeklyModel = AppointmentListItemModel(appointment: weeklyAppointment)
        XCTAssertEqual(weeklyModel.recurrence, "Weekly")

        let monthlyAppointment = Appointment(
            appointmentId: UUID().uuidString,
            patientId: "1",
            providerId: "100",
            status: .scheduled,
            appointmentType: .followUp,
            start: Date(),
            end: Date().addingTimeInterval(3600),
            durationInMinutes: 60,
            recurrenceType: .monthly
        )
        let monthlyModel = AppointmentListItemModel(appointment: monthlyAppointment)
        XCTAssertEqual(monthlyModel.recurrence, "Monthly")
    }

    func testTimeZoneHandling() throws {
        let appointment = Appointment.getMock()
        let model = AppointmentListItemModel(appointment: appointment)

        let currentTimeZone = TimeZone.current
        XCTAssertTrue(model.timeRange.contains(currentTimeZone.abbreviation() ?? ""))
    }
}
