//
//  SectionView.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 29.04.23.
//

import SwiftUI

struct SectionView<Content: View>: View {
    
    let title: String
    var subtitle: String? = nil
    let content: () -> Content
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading) {
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.secondary)
                }
                Text(title)
                    .sectionHeaderStyle()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            content()
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Section Header", subtitle: "(optional)") {
            Text("sldkfjlskdjf")
        }
    }
}
