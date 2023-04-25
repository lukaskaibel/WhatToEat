//
//  JSONUtilities.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import Foundation
import OSLog

func extractJsonFromString(_ inputString: String) -> String? {
    guard let data = inputString.data(using: .utf8) else {
        Logger().error("Failed to convert input string to data")
        return nil
    }
    
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        if let jsonData = try? JSONSerialization.data(withJSONObject: json ?? [:], options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8)
        }
    } catch {
        Logger().error("Error parsing JSON: \(error.localizedDescription)")
    }
    
    Logger().error("Failed to extract JSON from input string")
    return nil
}
