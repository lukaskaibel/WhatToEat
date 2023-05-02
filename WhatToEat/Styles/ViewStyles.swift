//
//  ViewStyles.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 29.04.23.
//

import SwiftUI

public struct TileStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
    }
}

extension View {
    public func tileStyle() -> some View {
        self.modifier(TileStyle())
    }
}
