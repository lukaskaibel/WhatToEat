//
//  ProfileScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

struct ProfileScreen: View {
    
    @AppStorage("eatingPattern") var eatingPattern: EatingPattern = .unrestricted
    
    var body: some View {
        List {
            Section {
                Picker("Eating Pattern", selection: $eatingPattern) {
                    ForEach(EatingPattern.allCases) { diataryPattern in
                        Text(diataryPattern.rawValue.capitalized)
                            .tag(diataryPattern)
                    }
                }
            }
            Section {
                NavigationLink(destination: RecentRecipesScreen()) {
                    Text("Recent Recipes")
                }
            }
        }
        .navigationTitle("Profile")
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileScreen()
        }
        .environmentObject(PersistenceController.preview)
    }
}
