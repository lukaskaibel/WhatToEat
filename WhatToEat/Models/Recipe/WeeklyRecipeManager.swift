//
//  WeeklyRecipe.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 06.05.23.
//

import Foundation
import Combine
import OSLog


class WeeklyRecipeManager: ObservableObject {
    @Published var current: Recipe?

    private var cancellables = Set<AnyCancellable>()
    
    static let shared = WeeklyRecipeManager()

    init() {
        updateWeeklyRecipesIfNeeded()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Logger().error("WeeklyRecipeManager: Error updating the weekly recipe: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    func updateWeeklyRecipesIfNeeded() -> AnyPublisher<Void, Error> {
        let userDefaults = UserDefaults.standard
        let calendar = Calendar.current
        let currentWeek = Calendar.current.component(.weekOfYear, from: .now)
    
        let eatingPattern = EatingPattern(rawValue: UserDefaults.standard.object(forKey: "eatingPattern") as? String ?? "") ?? .unrestricted
        let nutritionalGoal = NutritionalGoal(rawValue: UserDefaults.standard.object(forKey: "nutritionalGoal") as? String ?? "") ?? .none
    
        let currentWeeklyRecipeIdString = userDefaults.string(forKey: "currentWeeklyRecipeId")
        let currentWeeklyRecipeId = UUID(uuidString: currentWeeklyRecipeIdString ?? "")
    
        let currentWeeklyRecipePublisher = currentWeeklyRecipeId != nil
            ? Just(PersistenceController.shared.getRecipe(with: currentWeeklyRecipeId!))
                .setFailureType(to: Error.self)
                .compactMap { $0 }  // remove optional
                .eraseToAnyPublisher()
            : generateRecipe(thatIs: eatingPattern, for: nutritionalGoal)
                .tryMap { recipe -> Recipe in
                    userDefaults.setValue(recipe.id.uuidString, forKey: "currentWeeklyRecipeId")
                    return recipe
                }
                .eraseToAnyPublisher()
    
        return currentWeeklyRecipePublisher
            .receive(on: DispatchQueue.main)
            .flatMap { currentWeeklyRecipe -> AnyPublisher<Void, Error> in
                self.current = currentWeeklyRecipe
                if calendar.component(.weekOfYear, from: currentWeeklyRecipe.creationDate) != currentWeek {
                    let nextWeeklyRecipeIdString = userDefaults.string(forKey: "nextWeeklyRecipeId")
                    let nextWeeklyRecipeId = UUID(uuidString: nextWeeklyRecipeIdString ?? "")
                    let nextWeeklyRecipePublisher = nextWeeklyRecipeId != nil
                        ? Just(PersistenceController.shared.getRecipe(with: nextWeeklyRecipeId!))
                            .setFailureType(to: Error.self)
                            .compactMap { $0 }  // remove optional
                            .eraseToAnyPublisher()
                        : generateRecipe(thatIs: eatingPattern, for: nutritionalGoal)
                            .tryMap { recipe -> Recipe in
                                userDefaults.setValue(recipe.id.uuidString, forKey: "currentWeeklyRecipeId")
                                return recipe
                            }
                            .eraseToAnyPublisher()
            
                    return nextWeeklyRecipePublisher
                        .flatMap { nextWeeklyRecipe -> AnyPublisher<Void, Error> in
                            PersistenceController.shared.updateRecipe(with: nextWeeklyRecipe.id,
                                                                      name: nextWeeklyRecipe.name,
                                                                      ingredients: nextWeeklyRecipe.ingredients,
                                                                      instructions: nextWeeklyRecipe.instructions,
                                                                      time: nextWeeklyRecipe.time,
                                                                      eatingPattern: nextWeeklyRecipe.eatingPattern,
                                                                      imageUrl: nextWeeklyRecipe.imageUrl,
                                                                      isAdded: nextWeeklyRecipe.isAdded,
                                                                      creationDate: .now)
                            
                            return generateRecipe(thatIs: eatingPattern, for: nutritionalGoal)
                                .tryMap { nextRecipe -> Recipe in
                                    userDefaults.setValue(nextRecipe.id.uuidString, forKey: "nextWeeklyRecipeId")
                                    DispatchQueue.main.async {
                                        self.current = nextRecipe
                                    }
                                    return nextRecipe
                                }
                                .map { _ in () }
                                .eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
