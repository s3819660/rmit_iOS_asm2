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

struct LeaderboardView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(game.leaderboard) { e in
                    Text(e.username + " score:\(e.score)")
                }
            }
        }
            .navigationBarTitle("Leaderboard", displayMode: .inline)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
