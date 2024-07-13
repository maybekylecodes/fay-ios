//
//  AppointmentsView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI
import Combine

@MainActor
class AppointmentsViewModel: ObservableObject {

    // Services
    let apptService: AppointmentService = AppointmentProvider()

    // Data
    @Published private var appointments = [Appointment]()
    @Published var appointmentModels = [AppointmentListItemModel]()

    // View
    @Published var selectedStatus: StatusSelection = .upcoming
    @Published var selectedModelId: String?

    // Navigation
    @Published var userSignedOut = false

    // Combine
    private var cancelables = Set<AnyCancellable>()

    init() {
        setup()
    }

    private func setup() {
        setupSubscribers()
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
                appointments = response.appointments
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Subscriber Setup
extension AppointmentsViewModel {
    private func setupSubscribers() {
        setupAppointmentAndStatusSubscribers()
    }

    private func setupAppointmentAndStatusSubscribers() {
        Publishers.CombineLatest($appointments, $selectedStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] appts, status in
                self?.updateAppointmentModels(appts: appts, status: status)
            }.store(in: &cancelables)
    }
}

// MARK: - Utility Functions
extension AppointmentsViewModel {
    func updateAppointmentModels(appts: [Appointment], status: StatusSelection) {
        var update = [Appointment]()
        switch status {
        case .upcoming:
            update = appts.filter { $0.status == .scheduled }
        case .past:
            update = appts.filter { $0.status == .occurred }
        }
        appointmentModels = update.compactMap { AppointmentListItemModel(appointment: $0) }
    }
}

// MARK: - User Actions
extension AppointmentsViewModel {
    func signOut() {
        do {
            try KeychainManager.deleteKeychainString(keyId: .authToken)
            userSignedOut = true
        } catch {
            print(error)
            // TODO: - Show Error
        }
    }
}

struct AppointmentsView: View {

    @EnvironmentObject private var navModel: AppNavigationModel // For logging out

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
            .onTapGesture {
                viewModel.signOut() // So you can sign out / back in to test
            }

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
        .onReceive(viewModel.$userSignedOut) { signedOut in
            if signedOut {
                navModel.navigate(to: .login)
            }
        }
    }
}

#Preview {
    AppointmentsView()
}
