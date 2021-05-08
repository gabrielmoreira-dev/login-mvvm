//
//  LoginViewController.swift
//  LoginMVVM
//
//  Created by Gabriel Alves Moreira on 08/05/21.
//  Copyright © 2021 Gabriel Alves Moreira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 36
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.placeholder = "E-mail"
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.delegate = self
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(authenticateUser), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupView()
        emailTextField.becomeFirstResponder()
    }
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 36),
            passwordTextField.heightAnchor.constraint(equalToConstant: 36),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            authenticateUser()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text: NSString = (textField.text as NSString?) else { return false }
        let newText = text.replacingCharacters(in: range, with: string)
        
        if textField == emailTextField {
            viewModel.setEmail(newText)
        } else {
            viewModel.setPassword(newText)
        }
        
        return true
    }
}

extension LoginViewController {
    @objc private func authenticateUser() {
        dismissKeyboard()
        
        let validationState = viewModel.validateUser()
        switch validationState {
            case .valid:
                break
            default:
                let message = viewModel.getValidationMessage(for: validationState)
                displayErrorMessage(message: message)
        }
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func displayErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
