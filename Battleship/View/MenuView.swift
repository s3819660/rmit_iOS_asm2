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
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                
                VStack {
                    NavigationLink(destination: GameView(isNewGame: false)) {
                        Text("Resume")
                    }
                    NavigationLink(destination: GameView()) {
                        Text("Play now")
                    }
                    NavigationLink(destination: LeaderboardView()) {
                        Text("Leaderboard")
                    }
                    NavigationLink(destination: HowToPlayView()) {
                        Text("How to play")
                    }
                }
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
                .edgesIgnoringSafeArea(.all)
        }
            // fix NSLayoutContraints warnings
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
