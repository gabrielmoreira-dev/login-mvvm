//
//  LoginViewModel.swift
//  LoginMVVM
//
//  Created by Gabriel Alves Moreira on 08/05/21.
//  Copyright © 2021 Gabriel Alves Moreira. All rights reserved.
//

import Foundation

class LoginViewModel {
    private let minPasswordLength = 8
    private var user = User()
    
    var email: String {
        user.email
    }
    
    var password: String {
        user.password
    }
}

extension LoginViewModel {
    func setEmail(_ email: String) {
        user.email = email
    }
    
    func setPassword(_ password: String) {
        user.password = password
    }
    
    func validateUser() -> UserValidationState {
        if user.email.isEmpty || user.password.isEmpty {
            return .empty
        } else if !isValidEmailAddress() {
            return .invalidEmailFormat
        } else if user.password.count < minPasswordLength {
            return .shortPassword
        }
        
        return .valid
    }
    
    func isValidEmailAddress() -> Bool {
        let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegex)
            let nsString = user.email as NSString
            let results = regex.matches(in: user.email, range: NSRange(location: 0, length: nsString.length))
    
            if results.count == 0 {
                return false
            }
        } catch {
            return false
        }
        
        return true
    }
    
    func getValidationMessage(for state: UserValidationState) -> String {
        switch state {
            case .valid: return ""
            case .empty: return "E-mail and password are required"
            case .invalidEmailFormat: return "Please verify your e-mail"
            case .shortPassword: return "Password needs to be at least \(minPasswordLength) characteres"
        }
    }
}
