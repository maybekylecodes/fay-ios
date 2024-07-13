//
//  AppointmentsView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

@MainActor
class AppointmentsViewModel: ObservableObject {

    // View
    @Published var selectedStatus: StatusSelection = .upcoming
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

            }

            Spacer()
        }
    }
}

#Preview {
    AppointmentsView()
}
