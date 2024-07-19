//
//  PulsingLogoView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/19/24.
//

import SwiftUI

struct PulsingLogoView: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: scale)
            .task {
                scale = 1.2
            }
    }
}

#Preview {
    PulsingLogoView()
}
