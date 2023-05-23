//
//  JSONUtilities.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import Foundation
import OSLog

func extractJsonDataFromString(_ inputString: String) -> Data? {
    guard let startRange = inputString.range(of: "{"),
          let endRange = inputString.range(of: "}", options: .backwards) else {
        Logger().error("Failed to find JSON boundaries in input string")
        return nil
    }

    let jsonRange = startRange.lowerBound..<endRange.upperBound
    let jsonString = String(inputString[jsonRange])

    guard let jsonData = jsonString.data(using: .utf8),
          (try? JSONSerialization.jsonObject(with: jsonData)) != nil else {
        Logger().error("Invalid JSON extracted from input string")
        return nil
    }

    return jsonData
}

