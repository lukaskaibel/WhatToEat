//
//  RecentRecipesScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 29.04.23.
//

import SwiftUI

struct RecentRecipesScreen: View {
    
    @EnvironmentObject private var persistenceController: PersistenceController
    
    @State private var searchedText: String = ""
    @State private var isShowingClearConfirmation: Bool = false
    @State private var selectedRecipe: Recipe?

    private var recentRecipes: [Recipe] {
        (persistenceController.getRecipes(nameIncluding: searchedText) ?? [])
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(recentRecipes) { recipe in
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
        .navigationTitle("Recent Recipes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingClearConfirmation = true
                } label: {
                    Text("Clear")
                }
            }
        }
        .confirmationDialog("Clear Recent Recipes", isPresented: $isShowingClearConfirmation, actions: {
            Button("Clear", role: .destructive) {
                recentRecipes
                    .filter { !$0.isAdded }
                    .forEach { persistenceController.deleteRecipe($0) }
                persistenceController.save()
            }
            Button("Cancel", role: .cancel) {
                isShowingClearConfirmation = false
            }
        }, message: { Text("Permanently deletes all recipes that are not added to My Recipes") })
        .sheet(item: $selectedRecipe) { recipe in
            RecipeScreen(recipe: recipe)
        }
    }
}

struct RecentRecipesScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecentRecipesScreen()
            .environmentObject(PersistenceController.preview)
    }
}
