//
//  Recipe+InitFromDecoder.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 25.04.23.
//

import Foundation

extension Recipe {
    
    // AnyCodingKey struct
    struct AnyCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }

    // Updated init(from decoder: Decoder) function
    public init(from decoder: Decoder) throws {
        // Helper function to find a matching key, checking if the key is contained in the property name
        func findKey<T: CodingKey>(_ propertyName: String, in container: KeyedDecodingContainer<T>) -> T? {
            return container.allKeys.first(where: { propertyName.lowercased().contains($0.stringValue.lowercased()) })
        }
        
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        
        if let key = findKey("name", in: container) {
            name = try container.decode(String.self, forKey: key)
        } else if let key = findKey("title", in: container) {
            name = try container.decode(String.self, forKey: key)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "No matching key found for 'name' property"))
        }

        if let key = findKey("ingredients", in: container) {
            ingredients = try container.decode([String].self, forKey: key)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "No matching key found for 'ingredients' property"))
        }

        if let key = findKey("instructions", in: container) {
            instructions = try container.decode([String].self, forKey: key)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "No matching key found for 'instructions' property"))
        }
        
        if let key = findKey("time", in: container) {
            time = try container.decode(Int.self, forKey: key)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "No matching key found for 'time' property"))
        }

        if let key = findKey("imageUrl", in: container) {
            imageUrl = try container.decodeIfPresent(URL.self, forKey: key)
        } else {
            imageUrl = nil
        }

        // Generate new UUID for id
        id = UUID()
        creationDate = .now
    }
    
}
