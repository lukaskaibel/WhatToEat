//
//  ProfileScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

struct ProfileScreen: View {
    
    @AppStorage("diataryPattern") var diataryPattern: DiataryPattern = .unrestricted
    
    var body: some View {
        List {
            Picker("Diatary Pattern", selection: $diataryPattern) {
                ForEach(DiataryPattern.allCases) { diataryPattern in
                    Text(diataryPattern.rawValue.capitalized)
                        .tag(diataryPattern)
                }
            }
        }
        .navigationTitle("Profile")
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
