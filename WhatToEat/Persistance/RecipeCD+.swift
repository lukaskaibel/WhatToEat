//
//  Recipe+.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 02.05.23.
//

import Foundation

extension Recipe {
    
    var eatingPattern: EatingPattern {
        get {
            return EatingPattern(rawValue: eatingPatternRawValue ?? "") ?? .unrestricted
        }
        set {
            eatingPatternRawValue = newValue.rawValue
        }
    }
    
}

extension Recipe {
    public static var test: Recipe {
        PersistenceController.preview.createRecipe(
            id: UUID(),
            name: "Pasta with Olives and Tomatoes",
            ingredients: ["Pasta", "Olives", "Tomatoes", "Oil"],
            instructions: [
                "Bring a pot of salted water to a boil, add pasta and cook according to package instructions.",
                "Meanwhile, heat the oil in a skillet over medium-high heat. Add the tomatoes and cook until they soften and caramelize, about 7 minutes.",
                "Add the olives and cook for another 3 minutes before adding the cooked pasta to the skillet.",
                "Stir to combine and serve!"
            ],
            time: 15,
            eatingPattern: .vegan,
            imageUrl: URL(string: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F19%2F2014%2F01%2F31%2Fgrape-tomato-olive-spinach-pasta-ck-x.jpg&q=60"),
            isAdded: true
        )
    }
}
