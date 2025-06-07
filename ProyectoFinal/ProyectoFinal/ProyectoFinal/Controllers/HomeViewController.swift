//
//  HomeViewController.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {

    private var menuButton: UIBarButtonItem!
    
    private var sideMenu: SideMenuView!
    private var dimmedBackgroundView: UIView!
    private var isMenuOpen = false
    private let sideMenuWidth: CGFloat = 250


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gestión de Inventario"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Administra productos, controla tu inventario y mejora tu almacén."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "almacen_icon") ?? UIImage(systemName: "shippingbox.fill"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Iniciar sesión", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        let menuIcon = UIButton(type: .system)
        menuIcon.setTitle("☰", for: .normal)
        menuIcon.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        menuIcon.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)

        menuButton = UIBarButtonItem(customView: menuIcon)
        // No lo asignamos todavía

    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(imageView)
        view.addSubview(loginButton)

        loginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            imageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 220),

            loginButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func goToLogin() {
        let loginVC = LoginViewController()

        loginVC.onLoginSuccess = {
            self.loginButton.isHidden = true
            self.navigationItem.leftBarButtonItem = self.menuButton
            self.setupSideMenu()
        }

        navigationController?.pushViewController(loginVC, animated: true)
    }

    
    private func setupSideMenu() {
        dimmedBackgroundView = UIView(frame: view.bounds)
        dimmedBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmedBackgroundView.alpha = 0
        dimmedBackgroundView.isUserInteractionEnabled = true
        dimmedBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleMenu)))

        sideMenu = SideMenuView()
        sideMenu.alpha = 1.0
        sideMenu.isUserInteractionEnabled = true
        sideMenu.frame = CGRect(x: -sideMenuWidth, y: 0, width: sideMenuWidth, height: view.frame.height)

        view.addSubview(sideMenu) // primero el menú
        view.addSubview(dimmedBackgroundView) // luego el fondo
        view.bringSubviewToFront(dimmedBackgroundView) // ← queda arriba
        view.bringSubviewToFront(sideMenu) // ← pero luego traemos el menú al frente


        sideMenu.didSelectOption = { [weak self] option in
            guard let self = self else { return }
            self.toggleMenu()
            self.handleMenuSelection(option)
        }
    }
    
    @objc private func toggleMenu() {
        let targetX = isMenuOpen ? -sideMenuWidth : 0
        UIView.animate(withDuration: 0.3) {
            self.sideMenu.frame.origin.x = targetX
            self.dimmedBackgroundView.alpha = self.isMenuOpen ? 0 : 1
        }
        isMenuOpen.toggle()
    }
    
    private func handleMenuSelection(_ option: MenuOption) {
        switch option {
        case .inventario:
            let productsVC = ProductsViewController()
            self.navigationController?.pushViewController(productsVC, animated: true)

        case .agregar:
            let addVC = AddProductViewController()
            addVC.onProductAdded = {
                self.navigationController?.popToViewController(self, animated: true)
                // Si necesitas actualizar datos en Home, llama aquí al método que recargue info
            }
            navigationController?.pushViewController(addVC, animated: true)
            
        case .logs:
            let logsVC = LogsViewController()
            self.navigationController?.pushViewController(logsVC, animated: true)

            
        case .perfil:
            let email = Auth.auth().currentUser?.email ?? "No disponible"
            let alert = UIAlertController(title: "Perfil", message: "Usuario: \(email)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: .default))
            present(alert, animated: true)
            
        case .cerrarSesion:
            if let userEmail = Auth.auth().currentUser?.email {
                registrarLog(
                    tipo: "Logout",
                    descripcion: "Sesión cerrada por \(userEmail)"
                )
            }

            try? Auth.auth().signOut()

            toggleMenu()
            sideMenu.frame.origin.x = -sideMenuWidth
            dimmedBackgroundView.alpha = 0
            isMenuOpen = false

            navigationItem.leftBarButtonItem = nil

            UIView.transition(with: loginButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.loginButton.isHidden = false
            })

            print("🔒 Sesión cerrada correctamente.")

            
        }
    }

}
