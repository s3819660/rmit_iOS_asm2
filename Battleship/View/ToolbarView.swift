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
        GeometryReader { geo in
            HStack {
                Button(action: reset) {
                    Image(systemName: "repeat.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (geo.size.width > 700) ? 45 : 30, height: (geo.size.width > 700) ? 45 : 30)
                }
                    .help("Start a new game.")
                    .foregroundColor(.accentColor)
                    .padding(.top, 20)
                Spacer()
                Text(game.message)
                Spacer()
                Button(action: backToMenu) {
                    Image(systemName: "stop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (geo.size.width > 700) ? 45 : 30, height: (geo.size.width > 700) ? 45 : 30)
                }
                    .foregroundColor(.accentColor)
                    .padding(.leading, 10)
                    .padding(.top, 20)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 20)
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
