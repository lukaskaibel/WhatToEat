//
//  Recipe.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import Foundation
import OSLog

public struct Recipe: Decodable, Identifiable {
    public let id: UUID
    let creationDate: Date
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let imageUrl: URL?
    
    public init(id: UUID, creationDate: Date = .now, name: String, ingredients: [String], instructions: [String], imageUrl: URL?) {
        self.id = id
        self.creationDate = creationDate
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageUrl = imageUrl
    }
    
    public init(from decoder: Decoder) throws {
        // Decode other properties first
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        ingredients = try container.decode([String].self, forKey: .ingredients)
        instructions = try container.decode([String].self, forKey: .instructions)
        imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)
        
        // Generate new UUID for id
        id = UUID()
        creationDate = .now
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, ingredients, instructions, imageUrl
    }
}

extension Recipe {
    
    public static func create(with ingredients: [String]) async -> Recipe? {
        do {
            let recipeJSON = try await Recipe.requestRecipeJSON(with: ingredients)
            guard let recipeJSON = recipeJSON else { return nil }
            let recipe = try await convertJSONToRecipe(from: recipeJSON)
            return recipe
        } catch {
            return nil
        }
    }
    
    internal static func requestRecipeJSON(with ingredients: [String]) async throws -> String? {
        let prompt =
            """
                I have the following ingredients: \(ingredients.joined(separator: ", ")).
                Please suggest a recipe and return only a JSON object with the name, ingredients and instructions'. Write the keys exactly like this!!
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
    
    internal static func convertJSONToRecipe(from recipeJSON: String) async throws -> Recipe {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let jsonData = recipeJSON.data(using: .utf8)!
            let recipe = try jsonDecoder.decode(Recipe.self, from: jsonData)
            
            let imageUrl = try await makeDALLERequest(for: "\(recipe.name) with ingredients: \(recipe.ingredients.joined(separator: ", "))")

            Logger().info("Created recipe: \(recipe)")
            return Recipe(id: UUID(), name: recipe.name, ingredients: recipe.ingredients, instructions: recipe.instructions, imageUrl: imageUrl)
            
        } catch {
            Logger().error("Error decoding recipe JSON: \(error.localizedDescription)")
            throw error
        }
    }
}

extension Recipe: CustomStringConvertible {
    public var description: String {
        return "Recipe(name: \(name), ingredients: \(ingredients), instructions: \(instructions))"
    }
}

extension Recipe {
    public static var test: Recipe {
        Recipe(
            id: UUID(),
            name: "Pasta with Olives and Tomatoes",
            ingredients: ["Pasta", "Olives", "Tomatoes", "Oil"],
            instructions: [
                "Bring a pot of salted water to a boil, add pasta and cook according to package instructions.",
                "Meanwhile, heat the oil in a skillet over medium-high heat. Add the tomatoes and cook until they soften and caramelize, about 7 minutes.",
                "Add the olives and cook for another 3 minutes before adding the cooked pasta to the skillet.",
                "Stir to combine and serve!"
            ],
            imageUrl: URL(string: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F19%2F2014%2F01%2F31%2Fgrape-tomato-olive-spinach-pasta-ck-x.jpg&q=60"))
    }
}
