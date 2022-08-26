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

struct MenuView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var game: Game
//    @State var isResumeHidden = true // should be true for new user
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                
                VStack {
                    NavigationLink(destination: GameView(isNewGame: false)) {
                        Text("Resume")
                    }
                        // hide Resume button if it is a new user
                        .opacity((game.prevZoneStates.isEmpty) ? 0 : 1)
//                        .onDisappear {
//                            // (Workaround) unhide Resume button for when new user creates a new game then go back to menu
//                            self.isResumeHidden = false
//                        }
                    NavigationLink(destination: GameView()) {
                        Text("New game")
                    }
                    NavigationLink(destination: LeaderboardView()) {
                        Text("Leaderboard")
                    }
                    NavigationLink(destination: HowToPlayView()) {
                        Text("Settings")
                    }
                    NavigationLink(destination: HowToPlayView()) {
                        Text("How to play")
                    }
                    Text("Log Out")
                        .onTapGesture {
                            self.presentation.wrappedValue.dismiss()
                        }
                }
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
                .edgesIgnoringSafeArea(.all)
        }
            // fix NSLayoutContraints warnings
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true) // hide navigation from Log In page
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
