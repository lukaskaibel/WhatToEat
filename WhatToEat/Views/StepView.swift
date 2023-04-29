//
//  StepView.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 29.04.23.
//

import SwiftUI

struct StepView: View {
    @Binding var currentStep: Int
    let contents: [AnyView]
    let continueText: String
    let backText: String
    let onContinueButtonPress: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<contents.count, id:\.self) { i in
                        contents[i]
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .offset(x: offsetForStep(i, geometrySize: geometry.size))
                    }
                }
            }
            .animation(.interactiveSpring())
            .frame(height: 300)
            
            HStack(spacing: 20) {
                ForEach(0..<contents.count, id:\.self) { stepIndex in
                    Circle()
                        .fill(stepIndex <= currentStep ? Color.accentColor : Color.secondary)
                        .frame(width: 8, height: 8)
                        .onTapGesture {
                            currentStep = stepIndex
                        }
                }
            }
            .padding()
            
            Button(action: {
                onContinueButtonPress()
                if currentStep < contents.count - 1 {
                    withAnimation {
                        currentStep += 1
                        offset -= UIScreen.main.bounds.width
                    }
                }
            }) {
                Text(continueText)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 400)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            
            Button(action: {
                if currentStep > 0 {
                    withAnimation {
                        currentStep -= 1
                        offset += UIScreen.main.bounds.width
                    }
                }
            }) {
                Text(backText)
                    .padding()
            }
        }
    }
    
    private func offsetForStep(_ step: Int, geometrySize: CGSize) -> CGFloat {
        let difference = CGFloat(step - currentStep)
        return difference * geometrySize.width
    }
}


struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(currentStep: .constant(0), contents: [AnyView(Text("1")), AnyView(HStack{ Text("2")})], continueText: "Continue", backText: "Back") {  } 
    }
}
