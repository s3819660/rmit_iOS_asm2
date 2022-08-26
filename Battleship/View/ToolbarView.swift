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

struct ToolbarView: View {
    @EnvironmentObject var game: Game
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        HStack {
            Button(action: reset) {Image(systemName: "repeat")}
                .help("Start a new game.")
                .foregroundColor(.accentColor)
                .padding(.leading, 10)
            Spacer()
            Text(game.message)
            Spacer()
            Button(action: backToMenu) {Image(systemName: "stop")}
                .foregroundColor(.accentColor)
                .padding(.leading, 10)
        }.frame(height: 30)
    }
    
    func reset() {
        game.reset()
    }
    
    func backToMenu() {
        game.prevZoneStates = game.zoneStates
        self.presentation.wrappedValue.dismiss()
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
            .environmentObject(Game())
    }
}
