//
//  AppointmentsView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

@MainActor
class AppointmentsViewModel: ObservableObject {

    // Data
    @Published var appointmentModels = [AppointmentListItemModel.getMock(),
                                        AppointmentListItemModel.getMock()]

    // View
    @Published var selectedStatus: StatusSelection = .upcoming
    @Published var selectedModelId: String?
}

// MARK: - User Actions
extension AppointmentsViewModel {

}

struct AppointmentsView: View {

    @StateObject private var viewModel = AppointmentsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Text("Fay")
                    .font(.title2)
            }
            .padding(.top, 16)
            .padding(.horizontal, 20)

            SeparatorView()

            Text("Appointments")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            StatusSelectionView(selected: $viewModel.selectedStatus)

            .padding(.top, 24)

            List {
                ForEach(viewModel.appointmentModels) { model in
                    AppointmentListItemView(model: model,
                                            selectedId: $viewModel.selectedModelId)
                    .removeSeparatorLines()
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .onTapGesture {
                        viewModel.selectedModelId = model.id
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    AppointmentsView()
}
