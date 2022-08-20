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
                    NavigationLink(destination: GameView()) {
                        Text("Play Now")
                    }
                    NavigationLink(destination: LeaderboardView()) {
                        Text("Leaderboard")
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
