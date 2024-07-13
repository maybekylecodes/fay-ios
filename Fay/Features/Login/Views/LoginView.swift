//
//  LoginView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

struct LoginView: View {

    enum FocusedField: Hashable {
        case username
        case password
    }

    @EnvironmentObject private var navModel: AppNavigationModel

    @StateObject private var viewModel = LoginViewModel()

    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 12) {

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Text("Fay")
                    .font(.largeTitle)
            }
            .padding(.top, 16)

            Spacer()

            VStack(spacing: 12) {
                TextField("Username",
                          text: $viewModel.username,
                          prompt: Text("Enter your Username"))
                .textContentType(.username)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(usernameBorderColor, lineWidth: 1)
                )
                .focused($focusedField, equals: .username)
                .onSubmit {
                    focusedField = .password
                }

                SecureField("Password",
                            text: $viewModel.password,
                            prompt: Text("Enter your Password"))
                .textContentType(.password)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(passwordBorderColor, lineWidth: 1)
                )
                .focused($focusedField, equals: .password)
                .onSubmit {
                    viewModel.continueTapped()
                }
            }

            Spacer()

            if viewModel.isLoggingIn {
                ProgressView()
                    .tint(.fayBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 32)
            } else {
                Button {
                    viewModel.continueTapped()
                } label: {
                    Text("Continue")
                        .foregroundStyle(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(continueBackgroundColor)
                        )
                }
                .buttonStyle(.plain)
                .disabled(!viewModel.continueButtonEnabled)
                .padding(.bottom, 32)
            }
        }
        .padding(.horizontal, 20)
        .onReceive(viewModel.$userLoggedIn) { loggedIn in
            if loggedIn {
                navModel.navigate(to: .appointments)
            }
        }
    }
}

// MARK: - View Properties
extension LoginView {

    var continueBackgroundColor: Color {
        return viewModel.continueButtonEnabled ? .fayBlue : .fayBlue.opacity(0.4)
    }

    var usernameBorderColor: Color {
        return focusedField == .username ? .fayBlue : .gray
    }

    var passwordBorderColor: Color {
        return focusedField == .password ? .fayBlue : .gray
    }
}

#Preview {
    LoginView()
}
