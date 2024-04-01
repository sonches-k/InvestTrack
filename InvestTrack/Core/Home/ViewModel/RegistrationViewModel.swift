//
//  RegistrationViewModel.swift
//  InvestTrack
//
//  Created by Соня on 27.03.2024.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var registrationSuccessful = false
    @Published var isRegistering = false
    @Published var errorMessage: String? // Для отображения сообщений об ошибках

    func registerUser() {
        guard Validator.isValidEmail(email),
              Validator.isValidNickname(nickname),
              Validator.isValidPassword(password),
              Validator.isValidName(firstName),
              Validator.isValidName(lastName) else {
            self.errorMessage = "One or more fields are invalid. Please check your input and try again."
            return
        }

        self.isRegistering = true
        let registrationService = RegistrationService()
        let registrationRequest = RegistrationRequest(nickname: nickname, email: email, password: password, firstName: firstName, lastName: lastName)
        
        registrationService.register(user: registrationRequest) { [weak self] result in
            DispatchQueue.main.async {
//                self?.isRegistering = false
                switch result {
                case .success(_):
                    self?.registrationSuccessful = true
                case .failure(let error):
                    self?.errorMessage = "Registration failed: \(error)"
                }
                self?.isRegistering = false
            }
        }
    }
}
