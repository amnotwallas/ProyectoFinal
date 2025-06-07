//
//  Modelado.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import Foundation

struct Product: Codable {
    let id: String // ← ID generado por Firestore
    let nombre: String
    let cantidad: Int
    let precio: Double
    let descripcion: String
    var imagen: String // Nombre de imagen (ej. "monitor.jpg" o URL si es remota)
}

struct ProductResponseDataModel: Decodable {
    let products: [Product]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.products = try container.decode([Product].self)
    }
}

class ModeloDatos: ObservableObject {
    @Published var products: [Product] = []
    var onProductsUpdated: (([Product]) -> Void)?

    func getProducts() {
        guard let url = URL(string: "https://api-inventory-5ogw.onrender.com/inventory") else {
            print("URL inválida")
            return
        }

        print("Obteniendo productos...")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                do {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    self.products = products
                    self.onProductsUpdated?(self.products)
                } catch {
                    print("Error al decodificar JSON: \(error)")
                }
            } else {
                print("No hay datos...")
            }
        }.resume()
    }
    
    func addProduct(nombre: String, precio: Double, cantidad: Int, descripcion: String, imagen: String) {
        guard let url = URL(string: "https://api-inventory-5ogw.onrender.com/inventory") else {
            print("URL inválida")
            return
        }

        // No enviar el campo ID
        let nuevoProductoSinID: [String: Any] = [
            "nombre": nombre,
            "cantidad": cantidad,
            "precio": precio,
            "descripcion": descripcion,
            "imagen": imagen
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: nuevoProductoSinID, options: []) else {
            print("No se pudo codificar el producto a JSON")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al agregar producto: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                    print("Producto agregado correctamente.")
                    DispatchQueue.main.async {
                        self.getProducts()
                    }
                } else {
                    print("Error del servidor. Código: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }


    
    func actualizarCantidadProducto(id: String, nuevaCantidad: Int){
        guard let url = URL(string: "https://api-inventory-5ogw.onrender.com/inventory/\(id)") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // Tu backend usa PUT
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "cantidad": nuevaCantidad
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error al codificar JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al actualizar producto: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Cantidad actualizada correctamente.")
                    DispatchQueue.main.async {
                        self.getProducts() // Refrescar productos
                    }
                } else {
                    print("Error del servidor. Código: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func eliminarProducto(id: String) {
        guard let url = URL(string: "https://api-inventory-5ogw.onrender.com/inventory/\(id)") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al eliminar producto: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                    print("Producto eliminado correctamente.")
                    DispatchQueue.main.async {
                        self.getProducts()
                    }
                } else {
                    print("Error del servidor al eliminar. Código: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }



}
