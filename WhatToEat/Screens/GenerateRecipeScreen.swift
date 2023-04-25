//
//  GenerateRecipeScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

private let MIN_INGREDIENTS_WHEN_EXCLUSIVELY = 3

struct GenerateRecipeScreen: View {
    
    @State private var enteredIngredient: String = ""
    @State private var ingredients = [String]() {
        didSet {
            
        }
    }
    @State private var exclusively = false
    @State private var isGeneratingRecipe = false
    @State private var recipe: Recipe? = nil
    
    private var notEnoughIngredients: Bool {
        exclusively && ingredients.count < MIN_INGREDIENTS_WHEN_EXCLUSIVELY
    }
    
    var body: some View {
        Group {
            if isGeneratingRecipe {
                VStack(spacing: 20) {
                    ProgressView()
                    Text("Generating Recipe ...")
                }
            } else {
                List {
                    Section {
                        ForEach($ingredients, id: \.self) { ingredient in
                            TextField("", text: ingredient)
                        }
                        .onDelete { ingredients.remove(atOffsets: $0) }
                        TextField("Add Ingredient", text: $enteredIngredient)
                            .onSubmit {
                                guard !enteredIngredient.isEmpty else { return }
                                withAnimation {
                                    ingredients.append(enteredIngredient)
                                }
                                enteredIngredient = ""
                            }
                    } header: {
                        HStack {
                            Text("What's in your pantry?")
                                .sectionHeaderStyle()
                                .padding(.bottom, 5)
                            Spacer()
                            EditButton()
                                .textCase(nil)
                                .disabled(ingredients.isEmpty)
                        }
                    } footer: {
                        Text("Enter the ingredients you want to use.")
                    }
                    Section {
                        Toggle("Only Use These", isOn: $exclusively)
                    } footer: {
                        Text("When toggled on enter at least 3 ingredients.")
                    }
                }
                .overlay {
                    VStack {
                        Spacer()
                        Button {
                            Task {
                                recipe = await createRecipe(with: ingredients, exclusively: exclusively)
                            }
                        } label: {
                            Text(notEnoughIngredients ? "\(ingredients.count)/\(MIN_INGREDIENTS_WHEN_EXCLUSIVELY) Ingredients" : "Generate Recipe")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 350)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding()
                        .padding(.bottom, 30)
                        .disabled(ingredients.isEmpty || notEnoughIngredients)
                    }
                }
            }
        }
        .navigationTitle("Create")
        .sheet(item: $recipe) { recipe in
            RecipeScreen(recipe: recipe)
        }
    }
}

struct GenerateRecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GenerateRecipeScreen()
        }
    }
}
