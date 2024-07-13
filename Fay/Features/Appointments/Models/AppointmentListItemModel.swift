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
