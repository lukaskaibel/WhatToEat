//
//  MyRecipesScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 29.04.23.
//

import SwiftUI

struct MyRecipesScreen: View {
    
    @EnvironmentObject private var persistenceController: PersistenceController
    
    @State private var searchedText: String = ""
    @State private var selectedRecipe: Recipe?

    private var myRecipes: [Recipe] {
        (persistenceController.getRecipes(nameIncluding: searchedText) ?? [])
            .filter { $0.isAdded }
            .sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(myRecipes) { recipe in
                    VStack(spacing: 0) {
                        Button {
                            selectedRecipe = recipe
                        } label: {
                            RecipeCell(recipe: recipe)
                        }
                        Divider()
                            .padding(.leading, 72)
                    }
                }
            }
            .padding(.horizontal)
        }
        .searchable(text: $searchedText, prompt: "Search in Recipes")
        .navigationTitle("My Recipes")
        .sheet(item: $selectedRecipe) { recipe in
            RecipeScreen(recipe: recipe)
        }
    }
}

struct MyRecipesScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyRecipesScreen()
        }
        .environmentObject(PersistenceController.preview)
    }
}
