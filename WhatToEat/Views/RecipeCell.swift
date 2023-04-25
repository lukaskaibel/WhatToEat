//
//  RecipeCell.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 21.04.23.
//

import SwiftUI

struct RecipeCell: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            AsyncImage(url: recipe.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(radius: 4, y: 2)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .fontWeight(.bold)
                Text(recipe.ingredients.joined(separator: " · "))
                    .lineLimit(2)
            }
        }
        .padding()
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: 600, alignment: .leading)
    }
}

struct RecipeCell_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCell(recipe: Recipe.test)
    }
}
