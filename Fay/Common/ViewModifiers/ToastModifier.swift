//
//  ToastModifier.swift
//  Fay
//
//  Created by Kyle Jennings on 7/13/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var model: ToastModel?
    @State private var workItem: DispatchWorkItem?
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                GeometryReader { geometry in
                    VStack {
                        makeToast()
                            .offset(y: isShowing ? 0 : -geometry.safeAreaInsets.top - 100)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isShowing)

                        Spacer()
                    }
                }
            )
            .onChange(of: model) { newModel in
                if newModel != nil {
                    showToast()
                }
            }
    }

    @ViewBuilder
    func makeToast() -> some View {
        if let model {
            VStack {
                ToastView(model: model)
                {
                    dismiss()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private func showToast() {
        guard let model else { return }
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()

        isShowing = true

        if model.duration > 0 {
            workItem?.cancel()

            let task = DispatchWorkItem {
                dismiss()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + model.duration, execute: task)
        }
    }

    private func dismiss() {
        withAnimation {
            isShowing = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Add slight delay for animation out
            model = nil
            workItem?.cancel()
            workItem = nil
        }
    }
}
