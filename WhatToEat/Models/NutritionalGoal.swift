//
//  NutritionalGoal.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 02.05.23.
//

import Foundation

public enum NutritionalGoal: String, CaseIterable, Identifiable {
    case none, highProtein = "high protein", lowCarb = "low carb", lowCalorie = "low calorie"
    
    public var id: String { self.rawValue }
}
