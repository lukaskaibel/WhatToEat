//
//  Persistance+EntityCreation.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import CoreData
import OSLog

extension PersistenceController {
    
    public func createRecipe(id: UUID = UUID(), name: String, ingredients: [String], instructions: [String], time: Int, eatingPattern: EatingPattern, imageUrl: URL?, isAdded: Bool) {
        let recipe = RecipeCD(context: container.viewContext)
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
        Logger().log("Successfully created RecipeCD with id: \(id), name: \(name), ingredients:\(ingredients.joined(separator: " ")), instructions: \(instructions.joined(separator: " ")), time: \(time), eatingPattern: \(eatingPattern.rawValue) and imageUrl: \(imageUrl?.absoluteString ?? "nil"), isAdded: \(isAdded)")
    }
    
    public func updateRecipe(with id: UUID, name: String, ingredients: [String], instructions: [String], time: Int, eatingPattern: EatingPattern, imageUrl: URL?, isAdded: Bool) {
        do {
            guard let recipe = (try container.viewContext.fetch(RecipeCD.fetchRequest())).first(where: { $0.id == id }) else {
                Logger().warning("Failed to update RecipeCD with id: \(id). No recipe with matching id found.")
                return
            }
            recipe.name = name
            recipe.ingredients = ingredients
            recipe.instructions = instructions
            recipe.time = Int16(time)
            recipe.eatingPattern = eatingPattern
            recipe.isAdded = isAdded
            
            save()
            Logger().log("Successfully updated RecipeCD with id: \(id), name: \(name), ingredients:\(ingredients.joined(separator: " ")), instructions: \(instructions.joined(separator: " ")), time: \(time), eatingPattern: \(eatingPattern.rawValue) and imageUrl: \(imageUrl?.absoluteString ?? "nil"), isAdded: \(isAdded)")
        } catch {
            Logger().error("Failed to update RecipeCD with id: \(id)")
        }
    }
    
    public func deleteRecipe(_ recipe: Recipe, safeAfter: Bool = true) {
        do {
            guard let recipeCD = (try container.viewContext.fetch(RecipeCD.fetchRequest()).filter { $0.id == recipe.id }).first else { return }
            delete(recipeCD, safeAfter: safeAfter)
        } catch {
            Logger().warning("Tried to delete Recipe that does not exist. Id: \(recipe.id)")
        }
    }
    
    public func getRecipes(nameIncluding nameQuery: String = "", ingredientsIncluding ingredientQuery: String = "") -> [Recipe]? {
        do {
            return try container.viewContext.fetch(RecipeCD.fetchRequest())
                .map { Recipe(
                    id: $0.id!,
                    creationDate: $0.creationDate ?? .now,
                    name: $0.name!,
                    ingredients: $0.ingredients!,
                    instructions: $0.instructions!,
                    time: Int($0.time),
                    eatingPattern: $0.eatingPattern,
                    imageUrl: $0.imageUrl!,
                    isAdded: $0.isAdded
                )}
                .filter { (nameQuery.isEmpty || $0.name.contains(nameQuery)) && (ingredientQuery.isEmpty || $0.ingredients.joined().contains(ingredientQuery)) }
                .sorted { $0.creationDate > $1.creationDate }
        } catch {
            Logger().error("Failed to fetch RecipeCDs")
            return nil
        }
    }
    
    public func getRecipe(with id: UUID) -> Recipe? {
        return getRecipes()?
            .first { $0.id == id }
    }
}
