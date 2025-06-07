//
//  RegisterViewController.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let iconImageView = UIImageView()
    let emailField = UITextField()
    let passwordField = UITextField()
    let registerButton = UIButton(type: .system)

    var onLoginSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    func setupUI() {
        // Título
        titleLabel.text = "REGISTER"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center

        // Subtítulo
        subtitleLabel.text = "Crea una cuenta para comenzar"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2

        // Ícono (SF Symbol)
        iconImageView.image = UIImage(systemName: "shippingbox.fill")
        iconImageView.tintColor = .systemGreen
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        // Campos
        styledTextField(emailField, placeholder: "Correo electrónico")
        styledTextField(passwordField, placeholder: "Contraseña (mínimo 6 caracteres)")
        passwordField.isSecureTextEntry = true

        // Botón
        registerButton.setTitle("Registrarse", for: .normal)
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 10
        registerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)

        // Stack vertical
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            iconImageView,
            emailField,
            passwordField,
            registerButton
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

    @objc func register() {
        guard let email = emailField.text, let password = passwordField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("❌ Error al registrar: \(error.localizedDescription)")
                return
            }

            registrarLog(tipo: "Register", descripcion: "Usuario registrado exitosamente")

            // ✅ Notifica que se registró y vuelve al Home (u otro controlador)
            self.onLoginSuccess?()

            // ✅ Regresa a Home si se empujó desde navegación
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
