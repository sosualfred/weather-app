//
//  Weather_AppApp.swift
//  Weather App
//
//  Created by sosualfred on 17/06/2024.
//

import SwiftUI

@main
struct Weather_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
