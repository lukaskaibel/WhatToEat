//
//  DiataryPattern.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 23.04.23.
//

import Foundation

public enum DiataryPattern: String, CaseIterable, Identifiable {
    case unrestricted, vegetarian, vegan, pescatarian, keto, glutenFree = "gluten free", diaryFree = "diary free"
    
    public var id: String { self.rawValue }
}
