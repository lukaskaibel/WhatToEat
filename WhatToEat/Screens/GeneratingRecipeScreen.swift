//
//  GeneratingRecipeScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

struct GeneratingRecipeScreen: View {
    @Environment(\.dismiss) var dismiss
    
    let ingredients: [String]
    
    @State private var recipe: Recipe? = nil

    var body: some View {
        if let recipe = recipe {
            RecipeScreen(recipe: recipe)
        } else {
            VStack(spacing: 20) {
                ProgressView()
                Text("Generating Recipe ...")
            }
            .task {
                guard let recipe = await createRecipe(with: ingredients) else { return }
                PersistenceController.shared.createRecipe(
                    id: recipe.id,
                    name: recipe.name,
                    ingredients: recipe.ingredients,
                    instructions: recipe.instructions,
                    imageUrl: recipe.imageUrl
                )
                self.recipe = recipe
            }
        }
            
    }
}
