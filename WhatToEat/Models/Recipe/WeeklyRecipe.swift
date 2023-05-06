//
//  WeeklyRecipe.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 06.05.23.
//

import Foundation
import OSLog

func getWeeklyRecipe() async -> Recipe? {
    guard let currentWeeklyRecipeIdString = UserDefaults.standard.string(forKey: "currentWeeklyRecipeId"),
          let currentWeeklyRecipeId = UUID(uuidString: currentWeeklyRecipeIdString)
    else { return nil }
    
    return PersistenceController.shared.getRecipe(with: currentWeeklyRecipeId)
}

func updateWeeklyRecipesIfNeeded() async {
    let userDefaults = UserDefaults.standard
    let calendar = Calendar.current
    let currentWeek = Calendar.current.component(.weekOfYear, from: .now)
    
    let eatingPattern = EatingPattern(rawValue: UserDefaults.standard.object(forKey: "eatingPattern") as? String ?? "") ?? .unrestricted
    let nutritionalGoal = NutritionalGoal(rawValue: UserDefaults.standard.object(forKey: "nutritionalGoal") as? String ?? "") ?? .none
    
    guard let currentWeeklyRecipeIdString = userDefaults.string(forKey: "currentWeeklyRecipeId"),
          let currentWeeklyRecipeId = UUID(uuidString: currentWeeklyRecipeIdString),
          let currentWeeklyRecipe = PersistenceController.shared.getRecipe(with: currentWeeklyRecipeId)
    else {
        Logger().log("Current weekly recipe is not set.")
        Logger().log("Generating new current weekly recipe, since next weekly recipe does not exist.")
        guard let currentWeeklyRecipe = await createRecipe(thatIs: eatingPattern, for: nutritionalGoal) else {
            Logger().error("Failed generating new current weekly recipe. Not updating weekly recipe.")
            return
        }
        userDefaults.setValue(currentWeeklyRecipe.id.uuidString, forKey: "currentWeeklyRecipeId")
        
        Logger().log("Generating new next weekly recipe, to use for the next update.")
        guard let nextWeeklyRecipe = await createRecipe(thatIs: eatingPattern, for: nutritionalGoal) else {
            Logger().error("Failed generating next weekly recipe. This might cause issues for future weekly recipes.")
            return
        }
        userDefaults.setValue(nextWeeklyRecipe.id.uuidString, forKey: "nextWeeklyRecipeId")
        return
    }
    
    if calendar.component(.weekOfYear, from: currentWeeklyRecipe.creationDate) != currentWeek {
        // Set currentWeeklyRecipe = nextWeeklyRecipe
        Logger().log("Updating current weekly recipe.")
        if let nextWeeklyRecipeIdString = userDefaults.string(forKey: "nextWeeklyRecipeId"),
           let nextWeeklyRecipeId = UUID(uuidString: nextWeeklyRecipeIdString),
           let nextWeeklyRecipe = PersistenceController.shared.getRecipe(with: nextWeeklyRecipeId) {
            
            PersistenceController.shared.updateRecipe(with: nextWeeklyRecipeId,
                                                      name: nextWeeklyRecipe.name,
                                                      ingredients: nextWeeklyRecipe.ingredients,
                                                      instructions: nextWeeklyRecipe.instructions,
                                                      time: nextWeeklyRecipe.time,
                                                      eatingPattern: nextWeeklyRecipe.eatingPattern,
                                                      imageUrl: nextWeeklyRecipe.imageUrl,
                                                      isAdded: nextWeeklyRecipe.isAdded,
                                                      creationDate: .now)
            userDefaults.setValue(nextWeeklyRecipeIdString, forKey: "currentWeeklyRecipeId")
            Logger().log("Updated current weekly recipe with next weekly recipe (previously generated).")
            
        } else {
            Logger().log("Generating new current weekly recipe, since next weekly recipe does not exist")
            guard let currentWeeklyRecipe = await createRecipe(thatIs: eatingPattern, for: nutritionalGoal) else {
                Logger().error("Failed generating new current weekly recipe. Not updating weekly recipe.")
                return
            }
            userDefaults.setValue(currentWeeklyRecipe.id.uuidString, forKey: "currentWeeklyRecipeId")
        }

        Logger().log("Generating new next weekly recipe, to use for the next update.")
        guard let nextWeeklyRecipe = await createRecipe(thatIs: eatingPattern, for: nutritionalGoal) else {
            Logger().error("Failed generating next weekly recipe. This might cause issues for future weekly recipes.")
            return
        }
        userDefaults.setValue(nextWeeklyRecipe.id.uuidString, forKey: "nextWeeklyRecipeId")
    }
}
