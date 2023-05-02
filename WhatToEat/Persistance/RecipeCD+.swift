//
//  RecipeCD+.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 02.05.23.
//

import Foundation

extension RecipeCD {
    
    var eatingPattern: EatingPattern {
        get {
            return EatingPattern(rawValue: eatingPatternRawValue ?? "") ?? .unrestricted
        }
        set {
            eatingPatternRawValue = newValue.rawValue
        }
    }
    
}
