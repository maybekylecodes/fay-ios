//
//  AppointmentListItemModel+Mock.swift
//  Fay
//
//  Created by Kyle Jennings on 7/19/24.
//

import Foundation

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
