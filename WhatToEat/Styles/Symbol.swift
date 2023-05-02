//
//  Symbols.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 02.05.23.
//

import SwiftUI

struct Symbol {
    
    static var unrestrictedEating: Image { Image(systemName: "fork.knife") }
    static var vegetarian: Image { Image(systemName: "leaf") }
    static var vegan: Image { Image(systemName: "carrot") }
    static var pescatarian: Image { Image(systemName: "fish") }
    static var ketogenic: Image { Image(systemName: "pawprint") }
    static var glutenFree: Image { Image(systemName: "laurel.trailing") }
    static var diaryFree: Image { Image(systemName: "drop") }
    
}

extension Symbol {
    
    static func symbol(for eatingPattern: EatingPattern) -> Image {
        switch eatingPattern {
        case .unrestricted: return Symbol.unrestrictedEating
        case .vegetarian: return Symbol.vegetarian
        case .vegan: return Symbol.vegan
        case .pescatarian: return Symbol.pescatarian
        case .ketogenic: return Symbol.ketogenic
        case .glutenFree: return Symbol.glutenFree
        case .diaryFree: return Symbol.diaryFree
        }
    }
    
}


struct Symbol_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Symbol.unrestrictedEating
            Symbol.vegetarian
            Symbol.vegan
            Symbol.pescatarian
            Symbol.ketogenic
            Symbol.glutenFree
            Symbol.diaryFree
        }
        .font(.title)
    }
}
