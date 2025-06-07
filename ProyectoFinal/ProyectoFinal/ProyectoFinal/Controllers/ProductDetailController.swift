//
//  ProductDetailController.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import UIKit

class ProductDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var product: Product?

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Detalle del Producto"
        

        // Layout para colección
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)

        // Crear colección
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: "DetailCell")
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")


        view.addSubview(collectionView)

        // Constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // Imagen, Nombre, Cantidad, Precio, Descripción
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let product = product else {
            return UICollectionViewCell()
        }

        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell

            let urlString = product.imagen // No usamos 'if let' aquí

            if let url = URL(string: urlString), url.scheme?.hasPrefix("http") == true {
                // Descargar imagen desde internet
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let imagen = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imageView.image = imagen
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.imageView.image = UIImage(named: "imagen_por_defecto")
                        }
                    }
                }.resume()
            } else {
                // Imagen local
                cell.imageView.image = UIImage(named: urlString)
            }

            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCell

        switch indexPath.item {
        case 1:
            cell.configure(title: "Nombre", value: product.nombre)
        case 2:
            cell.configure(title: "Cantidad", value: "\(product.cantidad)")
        case 3:
            cell.configure(title: "Precio", value: "$\(product.precio)")
        case 4:
            cell.configure(title: "Descripción", value: product.descripcion)
        default:
            break
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width - 40, height: 200)
        }
        return CGSize(width: collectionView.frame.width - 40, height: 80)
    }

}

