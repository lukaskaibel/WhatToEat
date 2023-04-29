//
//  SectionView.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 29.04.23.
//

import SwiftUI

struct SectionView<Content: View>: View {
    
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack {
            Text(title)
                .sectionHeaderStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
            content()
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Section Header") {
            Text("sldkfjlskdjf")
        }
    }
}
