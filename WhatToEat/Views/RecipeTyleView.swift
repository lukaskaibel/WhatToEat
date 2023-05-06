//
//  RecipeTyleView.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 30.04.23.
//

import SwiftUI

struct RecipeTyleView: View {
    
    @EnvironmentObject var persistenceController: PersistenceController
    
    let recipe: Recipe
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(subtitle.uppercased())
                        .font(.caption.weight(.bold))
                        .foregroundColor(.secondary)
                    Text(title)
                        .sectionHeaderStyle()
                }
                Spacer()
                
            }
            image
                .overlay {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(recipe.name)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            Label("\(recipe.time) min", systemImage: "stopwatch")
                        }
                        Spacer()
                        Button {
                            persistenceController.updateRecipe(with: recipe.id,
                                                               name: recipe.name,
                                                               ingredients: recipe.ingredients,
                                                               instructions: recipe.instructions,
                                                               time: recipe.time,
                                                               eatingPattern: recipe.eatingPattern,
                                                               imageUrl: recipe.imageUrl,
                                                               isAdded: !recipe.isAdded,
                                                               creationDate: recipe.creationDate)
                        } label: {
                            Image(systemName: recipe.isAdded ? "checkmark.circle.fill" : "plus.circle")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    .background(.thickMaterial)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .cornerRadius(10)
        }
    }
    
    private var image: some View {
        AsyncImage(url: recipe.imageUrl) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
    }
    
}

struct RecipeTyleView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTyleView(recipe: Recipe.test, title: "Weekly Recipe", subtitle: "updates on monday")
            .padding()
    }
}
