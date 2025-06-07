//
//  LoginViewController.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let iconImageView = UIImageView()
    let emailField = UITextField()
    let passwordField = UITextField()
    let loginButton = UIButton(type: .system)
    let goToRegisterButton = UIButton(type: .system)

    var onLoginSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    func setupUI() {
        // Título
        titleLabel.text = "LOGIN"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center

        // Subtítulo
        subtitleLabel.text = "Gestiona tu inventario fácilmente"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2

        // Icono con SF Symbol
        iconImageView.image = UIImage(systemName: "shippingbox.fill")
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        // Campos de texto
        styledTextField(emailField, placeholder: "Correo electrónico")
        styledTextField(passwordField, placeholder: "Contraseña")
        passwordField.isSecureTextEntry = true

        // Botón de login
        loginButton.setTitle("Iniciar Sesión", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)

        // Botón para ir a registro
        goToRegisterButton.setTitle("¿No tienes cuenta? Regístrate", for: .normal)
        goToRegisterButton.setTitleColor(.systemGray, for: .normal)
        goToRegisterButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)

        // Stack general
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            iconImageView,
            emailField,
            passwordField,
            loginButton,
            goToRegisterButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    func styledTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.setLeftPaddingPoints(10)
    }

    @objc func login() {
        guard let email = emailField.text, let password = passwordField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("❌ Error al iniciar sesión: \(error.localizedDescription)")
                return
            }

            registrarLog(tipo: "Login", descripcion: "Inicio de sesión exitoso")

            // Llama a la función que actualiza el estado en HomeViewController
            self.onLoginSuccess?()

            // Cierra modal si se presentó de forma modal, si no regresa a raíz
            if let nav = self.navigationController {
                nav.popToRootViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }
    }


    @objc func goToRegister() {
        let registerVC = RegisterViewController()
        registerVC.onLoginSuccess = self.onLoginSuccess
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}

// Padding a la izquierda para campos de texto
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
