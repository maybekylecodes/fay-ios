//
//  ToastView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/13/24.
//

import SwiftUI

struct ToastView: View {

    let model: ToastModel
    var closeTapped: (() -> Void)?

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: model.imageSystemName)
                .resizable()
                .foregroundStyle(.red)
                .frame(width: 20, height: 20)

            Text(model.message)
                .font(.callout)
                .fontWeight(.light)

            Spacer()

            Button {
                closeTapped?()
            } label: {
                Image(systemName: "xmark") // Defaulting to an error style
                    .foregroundStyle(.red)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 12)
        .padding(.trailing, 4)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(.red, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    ToastView(model: ToastModel(message: "Not connected to the internet"))
}
