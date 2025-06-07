//
//  Menu.swift
//  ProyectoFinal
//
//  Created by Cristian Suarez Espinoza on 03/06/25.
//

import Foundation

enum MenuOption: CaseIterable {
    case inventario, agregar, logs, perfil, cerrarSesion

    var title: String {
        switch self {
        case .inventario: return "Inventario"
        case .agregar: return "Agregar Producto"
        case .logs: return "Ver Logs"
        case .perfil: return "Perfil"
        case .cerrarSesion: return "Cerrar Sesión"
        }
    }

    var icon: String {
        switch self {
        case .inventario: return "📦"
        case .agregar: return "➕"
        case .logs: return "📊"
        case .perfil: return "👤"
        case .cerrarSesion: return "🚪"
        }
    }
}


