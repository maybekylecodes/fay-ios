//
//  AppointmentsView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI
import Factory

struct AppointmentsView: View {

    @EnvironmentObject private var navModel: AppNavigationModel

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

                Spacer()

                Button {
                    viewModel.signOutTapped()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.red.opacity(0.6))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
            }
            .padding(.top, 16)
            .padding(.leading, 20)

            SeparatorView()

            Text("Appointments")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            StatusSelectionView(selected: $viewModel.selectedStatus)
            .padding(.top, 24)

            if viewModel.isLoading {
                PulsingLogoView()
                    .frame(width: 32, height: 32)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
            }

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
            .refreshable {
                viewModel.refreshPulled()
            }
        }
        .onReceive(viewModel.$userSignedOut) { signedOut in
            if signedOut {
                navModel.signedOut()
            }
        }
        .onAppear {
            // Hides ugly default refresh control
            UIRefreshControl.appearance().tintColor = .clear
        }
        .toastView(model: $viewModel.toastModel)
        .toolbar(.hidden, for: .navigationBar)
        .alert("Sign Out?",
               isPresented: $viewModel.showSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                viewModel.signOut()
            }
        }
    }
}

#Preview {
    let _ = Container.shared.appointmentService.register { MockAppointmentProvider() }
    return AppointmentsView()
}
