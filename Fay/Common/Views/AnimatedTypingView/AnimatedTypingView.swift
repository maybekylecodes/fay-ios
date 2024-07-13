//
//  AnimatedTypingView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/13/24.
//

import SwiftUI

struct AnimatedTypingView: View {

    @StateObject private var viewModel = AnimatedTypingViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Text("Find a nutrition specialist for")
                .font(.headline)

            Text(viewModel.displayText)
                .font(.title)
                .underline(viewModel.underlineText)
                .fontWeight(.semibold)
                .foregroundStyle(.fayBlue)
                .frame(height: 40)
        }
        .onAppear {
            viewModel.startAnimation()
        }
        .onDisappear {
            viewModel.stopAnimation()
        }
    }
}

#Preview {
    AnimatedTypingView()
}
