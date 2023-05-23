//
//  Persistance+EntityCreation.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import CoreData
import OSLog

extension PersistenceController {
    
    @discardableResult
    public func createRecipe(id: UUID = UUID(),
                             name: String,
                             ingredients: [String],
                             instructions: [String],
                             time: Int,
                             eatingPattern: EatingPattern,
                             imageUrl: URL?,
                             isAdded: Bool) -> Recipe {
        let recipe = Recipe(context: container.viewContext)
        recipe.id = id
        recipe.creationDate = .now
        recipe.name = name
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        recipe.time = Int16(time)
        recipe.eatingPattern = eatingPattern
        recipe.imageUrl = imageUrl
        recipe.isAdded = isAdded
        
        save()
        Logger().log("Successfully created Recipe with id: \(id), name: \(name), ingredients:\(ingredients.joined(separator: " ")), instructions: \(instructions.joined(separator: " ")), time: \(time), eatingPattern: \(eatingPattern.rawValue) and imageUrl: \(imageUrl?.absoluteString ?? "nil"), isAdded: \(isAdded)")
        return recipe
    }
    
    public func updateRecipe(
        with id: UUID,
        name: String,
        ingredients: [String],
        instructions: [String],
        time: Int,
        eatingPattern: EatingPattern,
        imageUrl: URL?,
        isAdded: Bool,
        creationDate: Date
    ) {
        do {
            guard let recipe = (try container.viewContext.fetch(Recipe.fetchRequest())).first(where: { $0.id == id }) else {
                Logger().warning("Failed to update Recipe with id: \(id). No recipe with matching id found.")
                return
            }
            recipe.name = name
            recipe.ingredients = ingredients
            recipe.instructions = instructions
            recipe.time = Int16(time)
            recipe.eatingPattern = eatingPattern
            recipe.isAdded = isAdded
            recipe.creationDate = creationDate
            
            save()
            Logger().log("Successfully updated Recipe with id: \(id), name: \(name), ingredients:\(ingredients.joined(separator: " ")), instructions: \(instructions.joined(separator: " ")), time: \(time), eatingPattern: \(eatingPattern.rawValue) and imageUrl: \(imageUrl?.absoluteString ?? "nil"), isAdded: \(isAdded)")
        } catch {
            Logger().error("Failed to update Recipe with id: \(id)")
        }
    }
    
    public func deleteRecipe(_ recipe: Recipe, safeAfter: Bool = true) {
        do {
            guard let Recipe = (try container.viewContext.fetch(Recipe.fetchRequest()).filter { $0.id == recipe.id }).first else { return }
            delete(Recipe, safeAfter: safeAfter)
        } catch {
            Logger().warning("Tried to delete Recipe that does not exist. Id: \(recipe.id!)")
        }
    }
    
    public func getRecipes(nameIncluding nameQuery: String = "", ingredientsIncluding ingredientQuery: String = "") -> [Recipe]? {
        do {
            return try container.viewContext.fetch(Recipe.fetchRequest())
                .filter { (nameQuery.isEmpty || $0.name?.contains(nameQuery) ?? false) && (ingredientQuery.isEmpty || $0.ingredients?.joined().contains(ingredientQuery) ?? false) }
                .sorted { $0.creationDate ?? .now > $1.creationDate ?? .now }
        } catch {
            Logger().error("Failed to fetch Recipes")
            return nil
        }
    }
    
    public func getRecipe(with id: UUID) -> Recipe? {
        return getRecipes()?
            .first { $0.id == id }
    }
    
    // MARK: - Create Recipe from JSON
    
    @discardableResult
    func createRecipe(from jsonData: Data) throws -> Recipe {
        // Helper function to find a matching key, checking if the key contains the property name
        func findKey(_ propertyName: String, in dictionary: [String: Any]) -> String? {
            return dictionary.keys.first(where: { $0.lowercased().contains(propertyName.lowercased()) })
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            throw NSError(domain: "", code: 100, userInfo: ["description": "Failed to parse JSON"])
        }
        
        var name: String
        var ingredients: [String]
        var instructions: [String]
        var time: Int
        var eatingPattern: EatingPattern

        guard let nameKey = findKey("name", in: json) ?? findKey("title", in: json),
              let ingredientsKey = findKey("ingredients", in: json),
              let instructionsKey = findKey("instructions", in: json),
              let timeKey = findKey("time", in: json),
              let patternKey = findKey("pattern", in: json)
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "No matching key found in JSON"))                             
        }
                            
        name = json[nameKey] as? String ?? ""
        ingredients = json[ingredientsKey] as? [String] ?? []
        instructions = json[instructionsKey] as? [String] ?? []
        time = json[timeKey] as? Int ?? 0
        let eatingPatternRaw = json[patternKey] as? String ?? ""
        eatingPattern = EatingPattern(rawValue: eatingPatternRaw.lowercased()) ?? .unrestricted
        
        return createRecipe(
            name: name,
            ingredients: ingredients,
            instructions: instructions,
            time: time,
            eatingPattern: eatingPattern,
            imageUrl: nil,
            isAdded: false
        )
    }
    
}
