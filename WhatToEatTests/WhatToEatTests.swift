//
//  WhatToEatTests.swift
//  WhatToEatTests
//
//  Created by Lukas Kaibel on 20.04.23.
//

import XCTest
@testable import WhatToEat

final class WhatToEatTests: XCTestCase {
    
    let ingredients = ["Pasta", "Olives", "Tomatoes", "Oil"]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGPTRequest() async throws {
        let prompt = "Say 'Hello World'"
        
        let result = try await makeGptRequest(prompt: prompt)
        
        XCTAssertFalse(result?.isEmpty ?? true, "Failed making GPT request")
    }
    
    func testDALLERequest() async throws {
        let prompt = "Cat"
        let url = try await makeDALLERequest(for: prompt)
        XCTAssertNotNil(url)
    }
    
    func testRequestRecipeJSON() async throws {
        let recipeJSON = try await Recipe.requestRecipeJSON(with: ingredients)
        
        XCTAssertNotNil(recipeJSON, "Recipe JSON object is nil")
    }
    
    func testCreateRecipe() async throws {
        let recipe = await Recipe.create(with: ingredients)
        XCTAssertNotNil(recipe, "Recipe.create returned nil")
    }
    
    
}
