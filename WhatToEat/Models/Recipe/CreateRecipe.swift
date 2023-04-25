//
//  CreateRecipe.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 25.04.23.
//

import Foundation
import OSLog

public func createRecipe(with ingredients: [String], exclusively: Bool = false) async -> Recipe? {
    do {
        let recipeJSON = try await requestRecipeJSON(with: ingredients, exclusively: exclusively)
        guard let recipeJSON = recipeJSON else { return nil }
        guard let recipe = try await convertJSONToRecipe(from: recipeJSON) else { return nil }
        PersistenceController.shared.createRecipe(
            id: recipe.id,
            name: recipe.name,
            ingredients: recipe.ingredients,
            instructions: recipe.instructions,
            imageUrl: recipe.imageUrl
        )
        return recipe
    } catch {
        return nil
    }
}

internal func requestRecipeJSON(with ingredients: [String], exclusively: Bool = false) async throws -> String? {
    let prompt =
        """
            I have the following ingredients: \(ingredients.joined(separator: ", ")).
            Please suggest a recipe \(exclusively ? "that ONLY uses those ingredients" : "").
            Return just a JSON object with the name, ingredients and instructions'.
            Make sure that the JSON keys are exactly as I wrote them and that ingredients and instructions are lists!
        """
    Logger().info("Making GPT request with prompt: \(prompt)")
    let response = try await makeGptRequest(prompt: prompt)
    guard let response = response else {
        Logger().error("GPT request returned nil")
        return nil
    }
    Logger().debug("Received GPT response: \(response)")
    let recipeJSON = extractJsonFromString(response)
    Logger().debug("Extracted recipe JSON: \(recipeJSON ?? "nil")")
    return recipeJSON
}

internal func convertJSONToRecipe(from recipeJSON: String) async throws -> Recipe? {
    do {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let jsonData = recipeJSON.data(using: .utf8)!
        var recipe = try jsonDecoder.decode(Recipe.self, from: jsonData)
        
        let imageUrl = try await makeDALLERequest(for: "\(recipe.name) with ingredients: \(recipe.ingredients.joined(separator: ", "))")
        
        guard let imageURLString = imageUrl?.absoluteString else { return nil }
        let imageURL = URL(string: imageURLString)!
        
        do {
            let downloadedImageURL = try await downloadImage(from: imageURL)
            Logger().info("Created recipe: \(recipe)")
            recipe = Recipe(id: UUID(), name: recipe.name, ingredients: recipe.ingredients, instructions: recipe.instructions, imageUrl: downloadedImageURL)
        } catch {
            Logger().error("Error downloading image: \(error.localizedDescription)")
        }
        
        return recipe
    } catch {
        Logger().error("Error decoding recipe JSON: \(error.localizedDescription)")
        throw error
    }
}
