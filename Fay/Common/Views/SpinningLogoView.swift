//
//  SpinningLogoView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

struct SpinningLogoView: View {
    @State private var rotationAngle: Double = 0.0
    @State private var isAnimating = false

    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                startAnimating()
            }
    }

    private func startAnimating() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                rotationAngle += 360
            }
        }
    }
}

#Preview {
    SpinningLogoView()
}
