//
//  ToastModel.swift
//  Fay
//
//  Created by Kyle Jennings on 7/13/24.
//

import Foundation

struct ToastModel: Hashable {
    let message: String
    var imageSystemName: String = "x.circle.fill"
    var duration: Double = 5
}
