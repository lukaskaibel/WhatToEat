//
//  RecipeScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

struct RecipeScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var persistenceController: PersistenceController
    
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            header
            VStack {
                metaDataSection
                    .padding()
                Divider()
                    .padding(.horizontal)
                ingredientSection
                    .padding()
                Divider()
                    .padding(.horizontal)
                instructionSection
                    .padding()
            }
        }
    }
    
    var header: some View {
        AsyncImage(url: recipe.imageUrl) { image in
            image
                .resizable()
                .scaledToFill()
                .overlay {
                    ZStack {
                        LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
                        Text("\(recipe.name)")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            .padding()
                    }
                }
        } placeholder: {
            Rectangle()
                .fill(.quaternary)
                .overlay {
                    ProgressView()
                    Text("\(recipe.name)")
                        .font(.largeTitle.weight(.bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .padding()
                }
        }
    }
    
    var metaDataSection: some View {
        HStack {
            Label("\(recipe.time) min", systemImage: "stopwatch")
                .fontWeight(.medium)
        }
    }
    
    var ingredientSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Ingredients")
                .sectionHeaderStyle()
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(recipe.ingredients.enumerated()), id:\.element) { index, ingredient in
                    HStack(spacing: 15) {
                        Text("·")
                        Text("\(ingredient)")
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var instructionSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Instructions")
                .sectionHeaderStyle()
            VStack(alignment: .leading, spacing: 15) {
                ForEach(Array(recipe.instructions.enumerated()), id:\.element) { index, instruction in
                    HStack(spacing: 15) {
                        Text("\(index + 1).")
                        Text("\(instruction)")
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeScreen(recipe: Recipe.test)
        }
        .environmentObject(PersistenceController.preview)
    }
}
