//
//  CreateRecipe.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 25.04.23.
//

import Foundation
import Combine
import OSLog

public func generateRecipe(exclusively: Bool = false,
                         with ingredients: [String] = [],
                         thatIs eatingPattern: EatingPattern = .unrestricted,
                         for nutritionalGoal: NutritionalGoal) -> AnyPublisher<Recipe, Error> {
    return makeGptRequest(prompt: makePromptForRecipe(exclusively: exclusively, with: ingredients, thatIs: eatingPattern, for: nutritionalGoal))
        .tryMap { response -> Recipe in
            guard let jsonData = extractJsonDataFromString(response) else {
                throw NSError(domain: "Error: Unable to convert recipeJSON to Data", code: -1, userInfo: nil)
            }
            return try PersistenceController.shared.createRecipe(from: jsonData)
        }
        .flatMap { recipe -> AnyPublisher<Recipe, Error> in
            makeDALLERequest(for: "\(recipe.name ?? "Recipe") with ingredients: \((recipe.ingredients ?? []).joined(separator: ", ")). The dish should be the focus of the image.")
                .flatMap { imageUrl -> AnyPublisher<URL, Error> in
                    downloadImage(from: imageUrl)
                }
                .map { downloadedImageURL -> Recipe in
                    recipe.imageUrl = downloadedImageURL
                    PersistenceController.shared.save()
                    return recipe
                }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
}

internal func makePromptForRecipe(exclusively: Bool = false,
                                  with ingredients: [String],
                                  thatIs eatingPattern: EatingPattern = .unrestricted,
                                  for nutritionalGoal: NutritionalGoal) -> String {
    """
        Please suggest a great tasting \(eatingPattern == .unrestricted ? "" : eatingPattern.rawValue)\(nutritionalGoal == .none ? "" : " " + nutritionalGoal.rawValue) recipe \(ingredients.isEmpty ? "" : "that \(exclusively ? "exclusively" : "") uses the following ingredients: \(ingredients.joined(separator: ", "))").
        You don't need to use all ingredients if they don't fit.
        \(eatingPattern == .unrestricted && nutritionalGoal == .none ? "" : "Make sure to that the recipe is \(eatingPattern == .unrestricted ? "" : eatingPattern.rawValue) \(nutritionalGoal == .none ? "" : nutritionalGoal.rawValue).")
        Please get creative with the name and make the name max. 30 characters long.
        Return just a JSON object with the name, ingredients, instructions, required time (in minutes) and eatingPattern (\(EatingPattern.allCases.map({ $0.rawValue }).joined(separator: ", ")).
        Make sure that ingredients and instructions are lists and that the JSON keys are spelled EXACTLY as above!
    """
}
