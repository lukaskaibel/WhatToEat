//
//  MakeRecipeScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

struct MakeRecipeScreen: View {
    
    @State private var enteredIngredient: String = ""
    @State private var ingredients = [String]() {
        didSet {
            
        }
    }
    @State private var onlyUseEnteredIngredients = false
    @State private var isGeneratingOrShowingRecipe = false
    
    var body: some View {
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
        }
        .overlay {
            VStack {
                Spacer()
                Button {
                    isGeneratingOrShowingRecipe = true
                } label: {
                    Text("Generate Recipe")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .padding(.bottom, 30)
                .disabled(ingredients.isEmpty)
            }
        }
        .navigationTitle("Create")
        .sheet(isPresented: $isGeneratingOrShowingRecipe, onDismiss: {}) {
            GeneratingRecipeScreen(ingredients: ingredients)
        }
    }
}

struct GenerateRecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeRecipeScreen()
        }
    }
}
