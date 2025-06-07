//
//  AddProductViewController.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import FirebaseDatabase
import FirebaseAuth
import UIKit

class AddProductViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private var cantidadLabel = UILabel()
    private var cantidad = 1 // Valor inicial por defecto
    private var nombreField = UITextField()
    private var precioField = UITextField()
    private var descripcionField = UITextField()
    private var imagenField = UITextField()
    private let agregarButton = UIButton(type: .system)
    
    var onProductAdded: (() -> Void)?
    
    
    let modelo = ModeloDatos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Agregar Producto"
        
        setupScrollView()
        setupFields()
        setupButton()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func createTextField(placeholder: String, keyboard: UIKeyboardType = .default) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.backgroundColor = .white
        field.keyboardType = keyboard
        field.layer.cornerRadius = 10
        field.layer.shadowColor = UIColor.black.cgColor
        field.layer.shadowOpacity = 0.1
        field.layer.shadowOffset = CGSize(width: 0, height: 2)
        field.layer.shadowRadius = 4
        field.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return field
    }
    
    private func setupFields() {
        nombreField = createTextField(placeholder: "📦 Nombre del producto")
        precioField = createTextField(placeholder: "💲 Precio", keyboard: .decimalPad)
        descripcionField = createTextField(placeholder: "📝 Descripción")
        imagenField = createTextField(placeholder: "🖼️ Imagen (URL o nombre)")

        let fields = [nombreField, precioField, descripcionField, imagenField]

        for field in fields {
            let container = UIView()
            container.backgroundColor = .white
            container.layer.cornerRadius = 12
            container.layer.shadowColor = UIColor.black.cgColor
            container.layer.shadowOpacity = 0.05
            container.layer.shadowOffset = CGSize(width: 0, height: 2)
            container.layer.shadowRadius = 4
            container.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(field)
            field.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                field.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
                field.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
                field.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
                field.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
                field.heightAnchor.constraint(equalToConstant: 44)
            ])

            contentView.addArrangedSubview(container)
        }

        // Contador de cantidad con botones
        let cantidadContainer = UIStackView()
        cantidadContainer.axis = .horizontal
        cantidadContainer.alignment = .center
        cantidadContainer.spacing = 12
        cantidadContainer.distribution = .equalCentering

        let cantidadTitle = UILabel()
        cantidadTitle.text = "🔢 Cantidad:"
        cantidadTitle.font = .systemFont(ofSize: 16, weight: .medium)

        let minusButton = UIButton(type: .system)
        minusButton.setTitle("–", for: .normal)
        minusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        minusButton.setTitleColor(.white, for: .normal)
        minusButton.backgroundColor = .systemGray
        minusButton.layer.cornerRadius = 20
        minusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        minusButton.addTarget(self, action: #selector(decrementarCantidad), for: .touchUpInside)

        cantidadLabel.text = "\(cantidad)"
        cantidadLabel.textAlignment = .center
        cantidadLabel.font = UIFont.systemFont(ofSize: 18)
        cantidadLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true

        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        plusButton.setTitleColor(.white, for: .normal)
        plusButton.backgroundColor = .systemBlue
        plusButton.layer.cornerRadius = 20
        plusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        plusButton.addTarget(self, action: #selector(incrementarCantidad), for: .touchUpInside)

        cantidadContainer.addArrangedSubview(cantidadTitle)
        cantidadContainer.addArrangedSubview(minusButton)
        cantidadContainer.addArrangedSubview(cantidadLabel)
        cantidadContainer.addArrangedSubview(plusButton)

        contentView.addArrangedSubview(cantidadContainer)
    }

    private func setupButton() {
        agregarButton.setTitle("Agregar Producto", for: .normal)
        agregarButton.backgroundColor = .systemGreen
        agregarButton.setTitleColor(.white, for: .normal)
        agregarButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        agregarButton.layer.cornerRadius = 12
        agregarButton.layer.shadowColor = UIColor.black.cgColor
        agregarButton.layer.shadowOpacity = 0.15
        agregarButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        agregarButton.layer.shadowRadius = 5
        agregarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        agregarButton.addTarget(self, action: #selector(agregarProducto), for: .touchUpInside)
        
        contentView.addArrangedSubview(agregarButton)
    }
    
    private func logAction(tipo: String, nombreProducto: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let logRef = Database.database().reference().child("logs").childByAutoId()
        let logData: [String: Any] = [
            "tipo": tipo, // ejemplo: "agregado"
            "producto": nombreProducto,
            "usuario": uid,
            "fecha": Date().timeIntervalSince1970
        ]
        logRef.setValue(logData) { error, _ in
            if let error = error {
                print("❌ Error al registrar log: \(error.localizedDescription)")
            } else {
                print("✅ Log registrado correctamente.")
            }
        }
    }

    
    @objc private func agregarProducto() {
        guard
            let nombre = nombreField.text, !nombre.isEmpty,
            let precioText = precioField.text, let precio = Double(precioText),
            let descripcion = descripcionField.text,
            let imagen = imagenField.text
        else {
            let alert = UIAlertController(title: "Datos incompletos", message: "Por favor completa todos los campos correctamente.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(alert, animated: true)
            return
        }

        let cantidad = self.cantidad

        modelo.addProduct(nombre: nombre, precio: precio, cantidad: cantidad, descripcion: descripcion, imagen: imagen)
        
        logAction(tipo: "agregado", nombreProducto: nombre)

        let successAlert = UIAlertController(title: "✅ Producto agregado", message: "El producto se ha registrado exitosamente.", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            self.onProductAdded?()
        })
        present(successAlert, animated: true)
    }

    
    @objc private func incrementarCantidad() {
        cantidad += 1
        cantidadLabel.text = "\(cantidad)"
    }

    @objc private func decrementarCantidad() {
        if cantidad > 1 {
            cantidad -= 1
            cantidadLabel.text = "\(cantidad)"
        }
    }

}
