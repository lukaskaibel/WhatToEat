//
//  EatingPattern.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 23.04.23.
//

import SwiftUI

public enum EatingPattern: String, CaseIterable, Identifiable {
    case unrestricted, vegetarian, vegan, pescatarian, ketogenic, glutenFree = "gluten free", diaryFree = "diary free"
    
    public var id: String { self.rawValue }
}
