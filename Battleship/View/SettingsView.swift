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
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var game: Game
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            
            Form {
                Spacer(minLength: 2).listRowBackground(Color.clear)
                
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
                        case .Moderate:
                            game.difficultyLevel = 1
                        case .Hard:
                            game.difficultyLevel = 2
                        default:
                            game.difficultyLevel = 0
                        }
                    })
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
                .listRowBackground(Color.gray.opacity(0.2))

                Section(header: Text("Sound")) {
                    Toggle(isOn: $settings.isSoundOn) {
                        Text("Sound on")
                    }
                    // handle sound settings changed
                    .onChange(of: settings.isSoundOn, perform: { (value) in
                        game.isSoundOn = value
                        
                        // Play/Stop background audio
                        if !value {
                            stopBackgroundAudio()
                        } else {
                            playBackgroundAudio(sound: "menu", type: "mp3")
                        }
                    })
                }
                .listRowBackground(Color.gray.opacity(0.2))
                
                Section(header: Text("Theme")) {
                    Toggle(isOn: $settings.isDarkMode) {
                        Text("Dark mode")
                    }
                }
                .listRowBackground(Color.gray.opacity(0.2))
                
                Section(header: Text("Account")) {
                    Button(action: {
                        game.isLoggedOut = true
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Log Out")
                    }
                }
                .listRowBackground(Color.gray.opacity(0.2))
            }
        }
        .navigationBarTitle(Text("Settings"))
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
