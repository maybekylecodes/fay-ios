//
//  LaunchScreenView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    scale = 1.2
                }
            }
    }
}

#Preview {
    LaunchScreenView()
}
