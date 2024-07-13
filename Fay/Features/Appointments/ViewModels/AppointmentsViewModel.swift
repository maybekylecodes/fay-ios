//
//  AppointmentsViewModel.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation
import Combine
import Factory

@MainActor
class AppointmentsViewModel: ObservableObject {

    // Services
    @Injected(\.appointmentService) private var appointmentService

    // Data
    @Published private var appointments = [Appointment]()
    @Published var appointmentModels = [AppointmentListItemModel]()

    // View
    @Published var isLoading = false
    @Published var selectedStatus: StatusSelection = .upcoming
    @Published var selectedModelId: String?

    // Navigation
    @Published var userSignedOut = false

    // Alert
    @Published var showSignOutAlert = false

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
        isLoading = true
        Task {
            do {
                let response = try await appointmentService.getAppointments()
                appointments = response.appointments
                isLoading = false
            } catch {
                print(error)
                isLoading = false
                // TODO: - Surface Error
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

    func refreshPulled() {
        loadAppointments()
    }

    func signOutTapped() {
        showSignOutAlert = true
    }

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
