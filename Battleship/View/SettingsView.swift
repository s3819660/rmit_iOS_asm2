/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Nguyen Phuoc Nhu Phuc
  ID: 3819660
  Created  date: 14/08/2022
  Last modified: 28/08/2022
  Acknowledgement:
 
*/


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var game: Game
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            
            Form {
                Section(header: Text("Difficulty")) {
                    Picker(
                        selection: $settings.difficultyLevel,
                        label: Text("Bot's intelligence")
                    ) {
                        ForEach(SettingsStore.DifficultyLevel.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    // handle difficulty changed
                    .onChange(of: settings.difficultyLevel, perform: { (value) in
                        switch value {
                        case .moderate:
                            game.difficultyLevel = 1
                        case .hard:
                            game.difficultyLevel = 2
                        default:
                            game.difficultyLevel = 0
                        }
                        
                        print("game diff=", game.difficultyLevel)
                    })
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
                .listRowBackground(Color.gray.opacity(0.2))

                Section(header: Text("Sound")) {
                    Toggle(isOn: $settings.isSoundOn) {
                        Text("Sound on:")
                    }
                }
                .listRowBackground(Color.gray.opacity(0.2))
                Section(header: Text("Theme")) {
                    Toggle(isOn: $settings.isDarkMode) {
                        Text("Dark mode:")
                    }
                }
                .listRowBackground(Color.gray.opacity(0.2))
            }
        }
        .padding(.top, 70)
        .navigationBarTitle(Text("Settings"))
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.all)
        .font(.title2)
        .onAppear {
            let appearance = UINavigationBarAppearance()
            let textColor = UIColor(.white)

            appearance.backgroundColor = UIColor(Color("PrimaryColor"))
            appearance.largeTitleTextAttributes = [
               .foregroundColor: textColor,
               .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
            ]
            appearance.titleTextAttributes = [
               .foregroundColor: textColor,
//               .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
            ]

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
