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
    @State private var ingredients = [String]()
    @State private var eatingPattern: EatingPattern = EatingPattern(rawValue: UserDefaults.standard.object(forKey: "eatingPattern") as? String ?? "") ?? .unrestricted
    @State private var exclusively = false
    @State private var isGeneratingRecipe = false
    @State private var recipe: Recipe? = nil
    @State private var currentStep: Int = 0
    @FocusState private var addIngredientIsFocused: Bool
    
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
                StepView(
                    currentStep: $currentStep,
                    contents: [AnyView(personalProfileStep), AnyView(ingredientsStep)],
                    continueText: currentStep < 1 ? "Continue" : notEnoughIngredients ? "\(ingredients.count)/\(MIN_INGREDIENTS_WHEN_EXCLUSIVELY) Ingredients" : "Generate Recipe",
                    backText: "Back"
                ) {
                    if currentStep == 1 {
                        isGeneratingRecipe = true
                        Task {
                            recipe = await createRecipe(exclusively: exclusively, with: ingredients, thatIs: eatingPattern)
                            isGeneratingRecipe = false
                        }
                    }
                }
            }
        }
        .navigationTitle("Create")
        .sheet(item: $recipe) { recipe in
            RecipeScreen(recipe: recipe)
        }
    }
    
    private var personalProfileStep: some View {
        SectionView(title: "Personal Profile") {
            HStack {
                Text("Eating Pattern")
                Spacer()
                Picker("Eating Pattern", selection: $eatingPattern) {
                    ForEach(EatingPattern.allCases) { diataryPattern in
                        Text(diataryPattern.rawValue.capitalized)
                            .tag(diataryPattern)
                    }
                }
            }
        }
        .padding()
        .tileStyle()
        .padding()
    }
    
    private var ingredientsStep: some View {
        SectionView(title: "Whats in your Pantry?") {
            ScrollView {
                VStack {
                    ForEach($ingredients, id: \.self) { ingredient in
                        HStack {
                            Text("·")
                            TextField("", text: ingredient)
                                .onSubmit {
                                    guard !enteredIngredient.isEmpty else { return }
                                    withAnimation {
                                        ingredients.append(enteredIngredient)
                                    }
                                    enteredIngredient = ""
                                }
                        }
                    }
                    .onDelete { ingredients.remove(atOffsets: $0) }
                    TextField("Add Ingredient", text: $enteredIngredient)
                        .onSubmit {
                            guard !enteredIngredient.isEmpty else { return }
                            withAnimation {
                                ingredients.append(enteredIngredient)
                            }
                            enteredIngredient = ""
                            addIngredientIsFocused = true
                        }
                        .focused($addIngredientIsFocused)
                }
            }
        }
        .padding()
        .tileStyle()
        .padding()
    }
}

struct GenerateRecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GenerateRecipeScreen()
        }
    }
}
