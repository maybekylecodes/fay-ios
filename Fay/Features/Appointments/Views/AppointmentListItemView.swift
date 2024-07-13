//
//  AppointmentListItemView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

struct AppointmentListItemView: View {

    let model: AppointmentListItemModel
    @Binding var selectedId: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                MonthView(month: model.month, day: model.day)

                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title)
                        .fontWeight(.medium)

                    Text(model.timeRange)
                        .font(.footnote)

                    HStack(spacing: 2) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.footnote)

                        Text(model.recurrence)
                            .font(.footnote)
                    }
                }

                Spacer()
            }

            if isSelected {
                Button {
                    // No Action
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "video")
                            .foregroundStyle(.white)
                            .fontWeight(.medium)

                        Text("Join Zoom")
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                    }
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.fayBlue)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.separatorGray, lineWidth: 1)
        )
    }
}

// MARK: - View Properties
extension AppointmentListItemView {
    var isSelected: Bool {
        return selectedId == model.id
    }
}

#Preview {
    let selectedModel = AppointmentListItemModel.getMock()

    return VStack {
        AppointmentListItemView(model: AppointmentListItemModel.getMock(),
                                selectedId: .constant(nil))

        AppointmentListItemView(model: selectedModel,
                                selectedId: .constant(selectedModel.id))
    }
}
