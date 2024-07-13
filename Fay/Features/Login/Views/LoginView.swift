//
//  LoginView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI
import Factory

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

            AnimatedTypingView()
                .padding(.vertical, 32)

            VStack(spacing: 16) {
                TextField("Username",
                          text: $viewModel.username,
                          prompt: 
                            Text("Enter your Username")
                    .foregroundColor(.separatorGray))
                .textContentType(.username)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(usernameBorderColor, lineWidth: 1)
                )
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                .disabled(viewModel.isLoggingIn)

                SecureField("Password",
                            text: $viewModel.password,
                            prompt: 
                                Text("Enter your Password")
                    .foregroundColor(.separatorGray))
                .textContentType(.password)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(passwordBorderColor, lineWidth: 1)
                )
                .focused($focusedField, equals: .password)
                .onSubmit {
                    focusedField = nil
                    viewModel.continueTapped()
                }
                .disabled(viewModel.isLoggingIn)
            }

            Spacer()

            if viewModel.isLoggingIn {
                SpinningLogoView()
                    .frame(width: 32, height: 32)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 32)
            } else {
                Button {
                    focusedField = nil
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
        .toastView(model: $viewModel.toastModel)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - View Properties
extension LoginView {

    var continueBackgroundColor: Color {
        return viewModel.continueButtonEnabled ? .fayBlue : .fayBlue.opacity(0.4)
    }

    var usernameBorderColor: Color {
        return focusedField == .username ? .fayBlue : .separatorGray
    }

    var passwordBorderColor: Color {
        return focusedField == .password ? .fayBlue : .separatorGray
    }
}

#Preview {
    let _ = Container.shared.authService.register { MockAuthProvider() }
    return LoginView()
}
