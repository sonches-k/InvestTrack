//
//  RegistrationView.swift
//  InvestTrack
//
//  Created by Соня on 27.03.2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @FocusState private var focusedField: RegistrationField?
    
    enum RegistrationField {
        case nickname, email, password, firstName, lastName
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            TextField("Bob", text: $viewModel.nickname)
                .focused($focusedField, equals: .nickname)
                .onSubmit {
                    focusedField = .email
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.background))
                .shadow(color: Color.theme.secondaryText, radius: 5)
                .padding(.horizontal, 20)
            
            
            TextField("example@mail.ru", text: $viewModel.email)
                .focused($focusedField, equals: .email)
                .onSubmit {
                    focusedField = .password
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.background))
                .shadow(color: Color.theme.secondaryText, radius: 5)
                .padding(.horizontal, 20)
            
            SecureField("Password!2", text: $viewModel.password)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    focusedField = .firstName
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.background))
                .shadow(color: Color.theme.secondaryText, radius: 5)
                .padding(.horizontal, 20)
            
            TextField("Bob", text: $viewModel.firstName)
                .focused($focusedField, equals: .firstName)
                .onSubmit {
                    focusedField = .lastName
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.background))
                .shadow(color: Color.theme.secondaryText, radius: 5)
                .padding(.horizontal, 20)
            
            TextField("Marley", text: $viewModel.lastName)
                .focused($focusedField, equals: .lastName)
                .onSubmit {
                    focusedField = nil
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.background))
                .shadow(color: Color.theme.secondaryText, radius: 5)
                .padding(.horizontal, 20)
            
            
            if viewModel.isRegistering {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.theme.secondaryText))
                    .scaleEffect(1.5)
            } else {
                Button(action: {
                    viewModel.registerUser()
                }) {
                    Text("Register")
                        .frame(maxWidth: 300)
                        .frame(height: 44)
                        .background(Color.theme.background)
                        .foregroundColor(Color.theme.accent)
                        .cornerRadius(22)
                        .padding(.horizontal, 20)
                }
                .disabled(viewModel.isRegistering)
                .font(.headline)
                .shadow(color: Color.theme.secondaryText, radius: 5)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .alert(isPresented: Binding<Bool>.constant(viewModel.errorMessage != nil), content: {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred"), dismissButton: .default(Text("OK")) {
                viewModel.errorMessage = nil
            })
        })
        .fullScreenCover(isPresented: $viewModel.registrationSuccessful) {
            HomeView()
        }
        .padding(.top, 250)
    }
}


#Preview {
    RegistrationView()
}



//import SwiftUI
//
//
//struct RegistrationView: View {
//    @State private var nickname: String = ""
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var firstName: String = ""
//    @State private var lastName: String = ""
//    @State private var registrationSuccessful = false // для перехода на главную
//    @State private var isRegistering = false // для отслеживания процесса регистрации
//
//    var body: some View {
//        Form {
//            TextField("Nick", text: $nickname)
//            TextField("example@example.com", text: $email)
//            SecureField("Password1!", text: $password)
//            TextField("John", text: $firstName)
//            TextField("Doe", text: $lastName)
//
//            if isRegistering {
//                ProgressView() // Индикатор загрузки, показывается когда isRegistering == true
//            } else {
//                Button("Register") {
//                    isRegistering = true // Пользователь начал процесс регистрации
//                    registerUser()
//                }
//                .disabled(isRegistering) // Кнопка будет деактивирована когда isRegistering == true
//            }
//        }
//        .fullScreenCover(isPresented: $registrationSuccessful) {
//            HomeView() // Переход на HomeView при успешной регистрации
//        }
//    }
//
//    private func registerUser() {
//        let registrationService = RegistrationService()
//        let registrationRequest = RegistrationRequest(nickname: nickname, email: email, password: password, firstName: firstName, lastName: lastName)
//
//        registrationService.register(user: registrationRequest) { result in
//            DispatchQueue.main.async {
//                isRegistering = false // Пользователь закончил процесс регистрации
//                switch result {
//                case .success(_):
//                    registrationSuccessful = true // Успешная регистрация
//                case .failure(let error):
//                    print("Ошибка регистрации: \(error)")
//                    // Здесь можно добавить логику для отображения ошибки пользователю
//                }
//            }
//        }
//    }
//} // разнести на view и viewmodel


