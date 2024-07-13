//
//  AppointmentsView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

@MainActor
class AppointmentsViewModel: ObservableObject {

    // Services
    let apptService: AppointmentService = AppointmentProvider()

    // Data
    @Published var appointmentModels = [AppointmentListItemModel]()

    // View
    @Published var selectedStatus: StatusSelection = .upcoming
    @Published var selectedModelId: String?

    init() {
        setup()
    }

    private func setup() {
        loadData()
    }
}

// MARK: - Data Loading
extension AppointmentsViewModel {

    private func loadData() {
        loadAppointments()
    }

    private func loadAppointments() {
        Task {
            do {
                let response = try await apptService.getAppts()
                appointmentModels = response.appointments.compactMap { AppointmentListItemModel(appointment: $0) }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - User Actions
extension AppointmentsViewModel {
    
}

struct AppointmentsView: View {

    @EnvironmentObject private var navModel: AppNavigationModel // For logging out if needed

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
