//
//  LogsViewController.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 04/06/25.
//

import UIKit
import FirebaseDatabase

class LogsViewController: UIViewController, UITableViewDataSource {
    private var logs: [[String: Any]] = []
    private let tableView = UITableView()
    private var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Historial"
        view.backgroundColor = .systemGroupedBackground
        setupTableView()
        
        // botón en la esquina superior derecha paara borrar historial
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Borrar",
            style: .plain,
            target: self,
            action: #selector(eliminarHistorial)
        )

        databaseRef = Database.database().reference().child("logs")
        databaseRef.observe(.value) { snapshot in
            var nuevosLogs: [[String: Any]] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any] {
                    nuevosLogs.append(dict)
                }
            }
            self.logs = nuevosLogs.reversed()
            self.tableView.reloadData()
        }
    

        databaseRef = Database.database().reference().child("logs")
        databaseRef.observe(.value) { snapshot in
            var nuevosLogs: [[String: Any]] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any] {
                    nuevosLogs.append(dict)
                }
            }
            self.logs = nuevosLogs.reversed()
            self.tableView.reloadData()
        }
    }

    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.register(LogCardCell.self, forCellReuseIdentifier: "LogCardCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogCardCell", for: indexPath) as? LogCardCell else {
            return UITableViewCell()
        }

        let log = logs[indexPath.row]

        let tipo = log["tipo"] as? String ?? "Acción"
        let usuario = log["email"] as? String ?? "Desconocido"
        let descripcion = log["descripcion"] as? String ?? ""
        let producto = log["producto"] as? String ?? ""

        let fecha: String = {
            if let timestamp = log["timestamp"] as? TimeInterval {
                let date = Date(timeIntervalSince1970: timestamp)
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                return formatter.string(from: date)
            }
            return "Fecha desconocida"
        }()

        cell.configure(tipo: tipo, producto: producto, usuario: usuario, descripcion: descripcion, fecha: fecha)
        return cell

    }
    
    @objc private func eliminarHistorial() {
        let alert = UIAlertController(
            title: "Eliminar historial",
            message: "¿Estás seguro de que deseas borrar todos los logs?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { _ in
            self.databaseRef.removeValue { error, _ in
                if let error = error {
                    print("❌ Error al eliminar logs: \(error.localizedDescription)")
                } else {
                    print("✅ Historial eliminado.")
                    self.logs.removeAll()
                    self.tableView.reloadData()
                }
            }
        })
        
        present(alert, animated: true)
    }

}
