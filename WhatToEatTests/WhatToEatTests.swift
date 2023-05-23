//
//  WhatToEatTests.swift
//  WhatToEatTests
//
//  Created by Lukas Kaibel on 20.04.23.
//

import XCTest
@testable import WhatToEat

final class WhatToEatTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGPTRequest() {
        let prompt = "Say 'Hello World'"
        
        let expectation = XCTestExpectation(description: "GPT request")
        
        let cancellable = makeGptRequest(prompt: prompt)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { result in
                XCTAssertFalse(result.isEmpty, "Failed making GPT request")
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testDALLERequest() {
        let prompt = "Cat"
        
        let expectation = XCTestExpectation(description: "DALLE request")
        
        let cancellable = makeDALLERequest(for: prompt)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { url in
                XCTAssertNotNil(url)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 20.0)
        cancellable.cancel()
    }
    
    func testCreateRecipe() {
        let exclusively = false
        let ingredients = ["pasta", "oil"]
        let eatingPattern = EatingPattern.unrestricted
        let nutritionalGoal = NutritionalGoal.none
        
        let expectation = XCTestExpectation(description: "Create recipe")
        
        let cancellable = generateRecipe(exclusively: exclusively, with: ingredients, thatIs: eatingPattern, for: nutritionalGoal)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { recipe in
                // Perform additional assertions on the recipe if needed
                XCTAssertNotNil(recipe)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 120.0)
        cancellable.cancel()
    }

    func testDownloadImage() {
        let imageURL = URL(string: "https://example.com/image.jpg")!
        
        let expectation = XCTestExpectation(description: "Download image")
        
        let cancellable = downloadImage(from: imageURL)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { downloadedURL in
                XCTAssertNotNil(downloadedURL)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 10.0)
        cancellable.cancel()
    }
    
}
