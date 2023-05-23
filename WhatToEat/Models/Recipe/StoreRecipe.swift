//
//  StoreRecipe.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 11.05.23.
//

import Foundation

public func storeRecipe(_ recipe: Recipe) {
    PersistenceController.shared.createRecipe(
        id: recipe.id,
        name: recipe.name,
        ingredients: recipe.ingredients,
        instructions: recipe.instructions,
        time: recipe.time,
        eatingPattern: recipe.eatingPattern,
        imageUrl: recipe.imageUrl,
        isAdded: false
    )
}
