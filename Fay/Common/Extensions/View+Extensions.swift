//
//  View+Extensions.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

extension View {
    
    /// Removes separator lines and insets from list items
    /// - Returns: View
    func removeSeparatorLines() -> some View {
        self
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    /// Presents a toast
    /// - Parameter model: The model of toast to present
    /// - Returns: View
    func toastView(model: Binding<ToastModel?>) -> some View {
        self
            .modifier(ToastModifier(model: model))
    }
}
