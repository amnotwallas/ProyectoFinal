//
//  ViewController.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import UIKit

class ProductsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let modelo = ModeloDatos()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Productos"

        setupCollectionView()
        setupConstraints()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCardCell.self, forCellWithReuseIdentifier: "ProductCardCell")

        modelo.onProductsUpdated = { _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        modelo.getProducts()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width / 2 - 24, height: 140)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white

        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelo.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCardCell", for: indexPath) as? ProductCardCell else {
            return UICollectionViewCell()
        }

        let producto = modelo.products[indexPath.item]
        cell.configure(with: producto)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = modelo.products[indexPath.item]

        let actionSheet = UIAlertController(title: "Selecciona una acción", message: "Producto: \(selectedProduct.nombre)", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Modificar cantidad", style: .default) { _ in
            let alert = UIAlertController(title: "Modificar Cantidad", message: "Producto: \(selectedProduct.nombre)", preferredStyle: .alert)

            alert.addTextField { textField in
                textField.placeholder = "Nueva cantidad"
                textField.keyboardType = .numberPad
                textField.text = "\(selectedProduct.cantidad)"
            }

            alert.addAction(UIAlertAction(title: "Modificar", style: .default) { _ in
                guard
                    let cantidadTexto = alert.textFields?.first?.text,
                    let nuevaCantidad = Int(cantidadTexto)
                else {
                    print("Cantidad inválida")
                    return
                }

                self.modelo.actualizarCantidadProducto(id: selectedProduct.id, nuevaCantidad: nuevaCantidad)

                // ✅ Log de modificación
                registrarLog(tipo: "Modificar", descripcion: "Producto '\(selectedProduct.nombre)' fue modificado a cantidad \(nuevaCantidad)")
            })

            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            self.present(alert, animated: true)
        })

        actionSheet.addAction(UIAlertAction(title: "Ver detalle", style: .default) { _ in
            let detailVC = ProductDetailViewController()
            detailVC.product = selectedProduct
            self.navigationController?.pushViewController(detailVC, animated: true)
        })

        actionSheet.addAction(UIAlertAction(title: "Eliminar producto", style: .destructive) { _ in
            let confirmAlert = UIAlertController(title: "¿Eliminar producto?", message: "Esta acción no se puede deshacer.", preferredStyle: .alert)

            confirmAlert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { _ in
                self.modelo.eliminarProducto(id: selectedProduct.id)

                // ✅ Log de eliminación
                registrarLog(tipo: "Eliminar", descripcion: "Producto '\(selectedProduct.nombre)' eliminado")
            })

            confirmAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            self.present(confirmAlert, animated: true)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(actionSheet, animated: true)
    }
}
