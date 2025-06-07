//
//  Funtion.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 04/06/25.
//

import FirebaseDatabase
import FirebaseAuth

func registrarLog(tipo: String, descripcion: String, producto: String? = nil, cantidadAnterior: Int? = nil, cantidadNueva: Int? = nil) {
    let database = Database.database().reference()
    let logsRef = database.child("logs").childByAutoId()

    let usuario = Auth.auth().currentUser
    let email = usuario?.email ?? "Desconocido"
    let uid = usuario?.uid ?? "anon"

    let timestamp = Int(Date().timeIntervalSince1970)
    let fechaLegible = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)

    var logData: [String: Any] = [
        "usuario_id": uid,
        "email": email,
        "tipo": tipo,
        "descripcion": descripcion,
        "timestamp": timestamp,
        "fecha": fechaLegible
    ]

    if let nombreProducto = producto {
        logData["producto"] = nombreProducto
    }

    if let anterior = cantidadAnterior {
        logData["cantidadAnterior"] = anterior
    }

    if let nueva = cantidadNueva {
        logData["cantidadNueva"] = nueva
    }

    logsRef.setValue(logData)
}

