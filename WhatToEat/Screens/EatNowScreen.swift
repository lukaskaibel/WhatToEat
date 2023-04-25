//
//  EatNowScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

struct EatNowScreen: View {
    
    @EnvironmentObject private var persistenceController: PersistenceController
    
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Recently Created")
                    .sectionHeaderStyle()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 0) {
                    ForEach(persistenceController.getRecipes() ?? []) { recipe in
                        VStack(spacing: 0) {
                            RecipeCell(recipe: recipe)
                                .onTapGesture {
                                    selectedRecipe = recipe
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle("Eat Now")
        .sheet(item: $selectedRecipe) { recipe in
            RecipeScreen(recipe: recipe)
        }
    }
}

struct EatNowScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EatNowScreen()
        }
        .environmentObject(PersistenceController.preview)
    }
}
