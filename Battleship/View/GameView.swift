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

struct GameView: View {
    @EnvironmentObject var game: Game
    var isNewGame = true
    
    var body: some View {
        VStack {
            ToolbarView()
            OceanView()
        }
        .onAppear(perform: handleResumeGame)
        // Hide navigation bar
        .navigationBarHidden(true)
        .background(Color("BackgroundColor"))
    }
    
    func handleResumeGame() {
        if !isNewGame {
            // fetch game state from Firestore
            game.fetchStateFromFirestore()
        } else {
            // if not reset to new game
            game.reset()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(Game())
    }
}
