//
//  TextStyles.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

public struct SectionHeaderModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.title2.weight(.bold))
            .foregroundColor(.primary)
            .textCase(nil)
    }
}

extension View {
    public func sectionHeaderStyle() -> some View {
        self.modifier(SectionHeaderModifier())
    }
}
