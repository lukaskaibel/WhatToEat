//
//  WhatToEatApp.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

@main
struct WhatToEatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    EatNowScreen()
                }
                .tabItem { Label("Eat Now", systemImage: "fork.knife") }
                NavigationStack {
                    GenerateRecipeScreen()
                }
                .tabItem { Label("Create", systemImage: "plus") }
                NavigationStack {
                    MyRecipesScreen()
                }
                .tabItem { Label("My Recipes", systemImage: "book.closed.fill") }
                NavigationStack {
                    ProfileScreen()
                }
                .tabItem { Label("Profile", systemImage: "person") }
            }
            .environmentObject(persistenceController)
        }
    }
}
