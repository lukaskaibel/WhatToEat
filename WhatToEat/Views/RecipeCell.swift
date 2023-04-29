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
        HStack(spacing: 12) {
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
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(recipe.creationDate.formatted(date: .numeric, time: .omitted))
                    Spacer()
                    if recipe.isAdded {
                        Image(systemName: "checkmark.circle")
                    }
                }
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
                Text(recipe.name)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Label("\(recipe.time) min", systemImage: "stopwatch")
            }
        }
        .foregroundColor(.primary)
        .padding(.vertical)
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
