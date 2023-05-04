//
//  ProfileScreen.swift
//  WhatToEat
//
//  Created by Lukas Kaibel on 20.04.23.
//

import SwiftUI

struct ProfileScreen: View {
    
    @AppStorage("eatingPattern") var eatingPattern: EatingPattern = .unrestricted
    @AppStorage("nutritionalGoal") var nutritionalGoal: NutritionalGoal = .none
    
    var body: some View {
        List {
            Section {
                Picker("Eating Pattern", selection: $eatingPattern) {
                    ForEach(EatingPattern.allCases) { eatingPattern in
                        Label {
                            Text(eatingPattern.rawValue.capitalized)
                        } icon: {
                            Symbol.symbol(for: eatingPattern)
                        }
                        .tag(eatingPattern)
                    }
                }
                Picker("Nutritional Goal", selection: $nutritionalGoal) {
                    ForEach(NutritionalGoal.allCases) { nutritionalGoal in
                        Text(nutritionalGoal.rawValue.capitalized)
                            .tag(nutritionalGoal)
                    }
                }
            } header: {
                Text("Dietary Lifestyle")
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
