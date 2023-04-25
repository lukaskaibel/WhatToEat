//
//  PersistanceController+Preview.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 24.04.23.
//

import CoreData

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        result.createRecipe(name: "Margherita Pizza",
                                          ingredients: ["Pizza dough", "Tomato sauce", "Fresh mozzarella", "Fresh basil", "Olive oil", "Salt"],
                                          instructions: ["Preheat oven to 475°F (245°C).",
                                                        "Roll out pizza dough on a lightly floured surface.",
                                                        "Place dough on a parchment-lined pizza stone or baking sheet.",
                                                        "Spread a thin layer of tomato sauce over the dough, leaving a small border.",
                                                        "Add slices of fresh mozzarella and fresh basil leaves.",
                                                        "Drizzle with olive oil and sprinkle with salt.",
                                                        "Bake for 12-15 minutes or until crust is golden and cheese is bubbly."],
                                          imageUrl: URL(string: "https://www.tazzipizza.com/wp-content/uploads/2020/11/margherita-1024x1024.jpg"))
        result.createRecipe(name: "Caesar Salad",
                                          ingredients: ["Romaine lettuce", "Croutons", "Parmesan cheese", "Caesar dressing"],
                                          instructions: ["Wash and dry romaine lettuce, then tear into bite-sized pieces.",
                                            "Toss lettuce with Caesar dressing.",
                                            "Add croutons and grated Parmesan cheese.",
                                            "Toss again to combine and serve immediately."],
                                          imageUrl: URL(string: "https://fraicheliving.com/wp-content/uploads/2022/06/Roasted-Garlic-Caesar-Salad-in-bowl-1024x1024.jpg"))
        result.createRecipe(name: "Chocolate Chip Cookies",
                                          ingredients: ["Butter", "White sugar", "Brown sugar", "Eggs", "Vanilla extract", "All-purpose flour", "Baking soda", "Salt", "Chocolate chips"],
                                          instructions: ["Preheat oven to 350°F (175°C).",
                                            "Cream together butter, white sugar, and brown sugar until smooth.",
                                            "Beat in the eggs one at a time, then stir in the vanilla extract.",
                                            "Combine the flour, baking soda, and salt; stir into the creamed mixture.",
                                            "Mix in the chocolate chips.",
                                            "Drop dough by rounded tablespoons onto ungreased cookie sheets.",
                                            "Bake for 8 to 10 minutes, or until edges are golden. Cool on wire racks."],
                                          imageUrl: URL(string: "https://savorysweetlife.com/wp-content/uploads/2009/10/CHOCOLATE-CHIP-COOKIES-3-1024x1024.jpg"))
        result.createRecipe(name: "Shrimp Scampi",
                                          ingredients: ["Butter", "Olive oil", "Garlic", "Raw shrimp", "White wine", "Lemon juice", "Parsley", "Red pepper flakes", "Salt", "Black pepper"],
                                          instructions: ["In a large skillet, melt butter with olive oil over medium heat.",
                                            "Add garlic and cook until fragrant, about 1 minute.",
                                            "Add shrimp, wine, and lemon juice to the skillet.",
                                            "Cook shrimp until pink, about 2-3 minutes per side.",
                                            "Stir in parsley, red pepper flakes, salt, and black pepper.",
                                            "Serve shrimp scampi over cooked pasta or with crusty bread."],
                                          imageUrl: URL(string: "https://insanelygoodrecipes.com/wp-content/uploads/2022/11/Ina-Garten-Shrimp-Scampi-With-Parsley-683x1024.webp"))
        result.createRecipe(name: "Veggie Stir-Fry",
                                          ingredients: ["Olive oil", "Bell peppers", "Broccoli", "Carrots", "Snap peas", "Mushrooms", "Soy sauce", "Honey", "Garlic", "Ginger", "Cornstarch"],
                                          instructions: ["In a small bowl, whisk together soy sauce, honey, garlic, ginger, and cornstarch. Set aside.",
                                            "Heat olive oil in a large skillet or wok over medium-high heat.",
                                            "Add bell peppers, broccoli, carrots, snap peas, and mushrooms to the skillet.",
                                            "Stir-fry vegetables for 5-7 minutes, or until tender-crisp.",
                                            "Pour the sauce mixture over the vegetables and stir to coat.",
                                            "Cook for an additional 2-3 minutes, or until the sauce has thickened.",
                                            "Serve the veggie stir-fry over cooked rice or noodles."],
                                          imageUrl: URL(string: "https://www.lastingredient.com/wp-content/uploads/2019/02/rainbow-vegetable-peanut-stir-fry1-1024x1024.webp"))
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
