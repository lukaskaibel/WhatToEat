//
//  CreateRecipe.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 25.04.23.
//

import Foundation
import OSLog

public func createRecipe(exclusively: Bool = false,
                         with ingredients: [String] = [],
                         thatIs eatingPattern: EatingPattern = .unrestricted,
                         for nutritionalGoal: NutritionalGoal) async -> Recipe? {
    do {
        let recipeJSON = try await requestRecipeJSON(exclusively: exclusively, with: ingredients, thatIs: eatingPattern, for: nutritionalGoal)
        guard let recipeJSON = recipeJSON else { return nil }
        guard let recipe = try await convertJSONToRecipe(from: recipeJSON) else { return nil }
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
        return recipe
    } catch {
        return nil
    }
}

internal func requestRecipeJSON(exclusively: Bool = false,
                                with ingredients: [String],
                                thatIs eatingPattern: EatingPattern = .unrestricted,
                                for nutritionalGoal: NutritionalGoal) async throws -> String? {
    let prompt =
        """
            Please suggest a great tasting \(eatingPattern == .unrestricted ? "" : eatingPattern.rawValue)\(nutritionalGoal == .none ? "" : " " + nutritionalGoal.rawValue) recipe \(ingredients.isEmpty ? "" : "that \(exclusively ? "exclusively" : "") uses the following ingredients: \(ingredients.joined(separator: ", "))").
            You don't need to use all ingredients if they don't fit.
            \(eatingPattern == .unrestricted && nutritionalGoal == .none ? "" : "Make sure to that the recipe is \(eatingPattern == .unrestricted ? "" : eatingPattern.rawValue) \(nutritionalGoal == .none ? "" : nutritionalGoal.rawValue).")
            Please get creative with the name and make the name max. 30 characters long.
            Return just a JSON object with the name, ingredients, instructions, required time (in minutes) and eatingPattern (\(EatingPattern.allCases.map({ $0.rawValue }).joined(separator: ", ")).
            Make sure that ingredients and instructions are lists and that the JSON keys are spelled EXACTLY as above!
        """
    let response = try await makeGptRequest(prompt: prompt)
    guard let response = response else {
        Logger().error("GPT request returned nil")
        return nil
    }
    let recipeJSON = extractJsonFromString(response)
    return recipeJSON
}

internal func convertJSONToRecipe(from recipeJSON: String) async throws -> Recipe? {
    do {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let jsonData = recipeJSON.data(using: .utf8)!
        var recipe = try jsonDecoder.decode(Recipe.self, from: jsonData)
        
        let imageUrl = try await makeDALLERequest(for: "\(recipe.name) with ingredients: \(recipe.ingredients.joined(separator: ", ")). The dish should be the focus of the image.")
        
        guard let imageURLString = imageUrl?.absoluteString else { return nil }
        let imageURL = URL(string: imageURLString)!
        
        do {
            let downloadedImageURL = try await downloadImage(from: imageURL)
            Logger().info("Created recipe: \(recipe)")
            recipe = Recipe(id: UUID(),
                            name: recipe.name,
                            ingredients: recipe.ingredients,
                            instructions: recipe.instructions,
                            time: recipe.time,
                            eatingPattern: recipe.eatingPattern,
                            imageUrl: downloadedImageURL,
                            isAdded: false)
        } catch {
            Logger().error("Error downloading image: \(String(describing: error))")
        }
        
        return recipe
    } catch {
        Logger().error("Error decoding recipe JSON: \(String(describing: error))")
        throw error
    }
}
