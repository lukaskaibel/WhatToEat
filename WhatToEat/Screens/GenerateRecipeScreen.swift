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
    @State private var nutritionalGoal: NutritionalGoal = NutritionalGoal(rawValue: UserDefaults.standard.object(forKey: "nutritionalGoal") as? String ?? "") ?? .none
    @State private var makeDefaultIsOn: Bool = false
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
                            recipe = await createRecipe(exclusively: exclusively, with: ingredients, thatIs: eatingPattern, for: nutritionalGoal)
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
            VStack {
                HStack {
                    Text("Eating Pattern")
                    Spacer()
                    Picker("Eating Pattern", selection: $eatingPattern) {
                        ForEach(EatingPattern.allCases) { eatingPattern in
                            Label {
                                Text(eatingPattern.rawValue.capitalized)
                            } icon: {
                                Symbol.symbol(for: eatingPattern)
                            }
                            .tag(eatingPattern)
                        }
                    }
                }
                Divider()
                HStack {
                    Text("Nutritional Goal")
                    Spacer()
                    Picker("Nutritional Goal", selection: $nutritionalGoal) {
                        ForEach(NutritionalGoal.allCases) { nutritionalGoal in
                            Text(nutritionalGoal.rawValue.capitalized)
                                .tag(nutritionalGoal)
                        }
                    }
                }
            }
        }
        .padding()
        .tileStyle()
        .padding()
    }
    
    private var ingredientsStep: some View {
        SectionView(title: "What's in your Pantry?", subtitle: "(optional)") {
            ScrollView {
                VStack {
                    ForEach(Array($ingredients.enumerated()), id: \.0) { index, ingredient in
                        HStack {
                            Text("-")
                            TextField("", text: ingredient)
                        }
                        .onTapGesture {} // Needed to make TextField tappable within ScrollView with .onTabGesture
                    }
                    HStack {
                        Text("-")
                            .foregroundColor(enteredIngredient.isEmpty ? Color(uiColor: .placeholderText) : .primary)
                        TextField("Enter Ingredient", text: $enteredIngredient)
                            .focused($addIngredientIsFocused)
                    }
                }
            }
            .onTapGesture {
                addIngredientIsFocused.toggle()
            }
            .onChange(of: addIngredientIsFocused) { _ in
                guard !addIngredientIsFocused, !enteredIngredient.isEmpty else { return }
                withAnimation {
                    ingredients.append(enteredIngredient)
                }
                enteredIngredient = ""
                addIngredientIsFocused = true
            }
            .onChange(of: ingredients) { _ in
                ingredients = ingredients.filter { !$0.isEmpty }
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
