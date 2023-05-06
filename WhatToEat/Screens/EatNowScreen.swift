//
//  EatNowScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

struct EatNowScreen: View {
    
    @EnvironmentObject private var persistenceController: PersistenceController
    
    @State private var weeklyRecipe: Recipe?
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(dateNowFormatted.uppercased())
                    .font(.footnote.weight(.bold))
                    .foregroundColor(.secondary)
                Text("Eat Now")
                    .font(.largeTitle.weight(.bold))
            }
            .padding()
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .leading)
            if let weeklyRecipe = weeklyRecipe {
                RecipeTyleView(recipe: weeklyRecipe, title: "Weekly Recipe", subtitle: "UPDATES ON MONDAY")
                    .onTapGesture {
                        selectedRecipe = weeklyRecipe
                    }
                    .padding(.horizontal)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Recently Created")
                    .sectionHeaderStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 0) {
                    ForEach((persistenceController.getRecipes() ?? []).prefix(3)) { recipe in
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
            }
            .padding()
            .tileStyle()
            .padding()
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeScreen(recipe: recipe)
        }
        .onAppear {
            Task {
                await updateWeeklyRecipesIfNeeded()
                weeklyRecipe = await getWeeklyRecipe()
            }
        }
    }
    
    private var dateNowFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM"
        return dateFormatter.string(from: Date())
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
