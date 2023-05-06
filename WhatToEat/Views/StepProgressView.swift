//
//  StepProgressView.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 04.05.23.
//

import SwiftUI

struct StepProgressView: View {
    
    let currentStep: Int
    let stepSymbols: [Image]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Capsule()
                    .foregroundColor(similarToTertiarySystemFill)
                    .overlay {
                        Capsule()
                            .foregroundColor(.accentColor)
                            .frame(width: geometry.size.width * CGFloat(currentStep) / CGFloat(stepSymbols.count - 1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
            }
            .frame(height: 10)
            .padding(.horizontal)
            HStack {
                ForEach(stepSymbols.indices, id:\.self) { index in
                    if index > 0 {
                        Spacer()
                    }
                    stepSymbols[index]
                        .fontWeight(.bold)
                        .foregroundColor(index <= currentStep ? .white : .secondary)
                        .padding(10)
                        .background(index <= currentStep ? Color.accentColor : similarToTertiarySystemFill)
                        .clipShape(Circle())
                        .padding(10)
                        .background(index == currentStep ? Color.accentColor.opacity(0.2) : .clear)
                        .clipShape(Circle())
                    if index < stepSymbols.count - 1 {
                        Spacer()
                    }
                }
            }
        }
    }
    
    var similarToTertiarySystemFill: Color {
        let lightColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        let darkColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1.0)
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? darkColor : lightColor
        })
    }
}

struct StepProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StepProgressView(currentStep: 1, stepSymbols: [Image(systemName: "car"), Image(systemName: "bus"), Image(systemName: "flag"), Image(systemName: "checkmark")])
            .padding()
    }
}
