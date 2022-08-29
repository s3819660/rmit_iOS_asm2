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
    @State private var animatingButton = false
    
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
                    .rotationEffect(.degrees(self.animatingButton ? 360 : 0))
                    .animation(.easeInOut(duration: 1), value: self.animatingButton)
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
                    .rotationEffect(.degrees(self.animatingButton ? 360 : 0))
                    .animation(.easeInOut(duration: 1), value: self.animatingButton)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 20)
        .onChange(of: game.over, perform: { (value) in
            if value {
                animatingButton = true
            }
        })
    }
    
    func reset() {
        game.reset()
    }
    
    func backToMenu() {
        game.prevZoneStates = game.zoneStates
        self.presentation.wrappedValue.dismiss()
    }
}

extension Animation {
    static func ripple() -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
            .environmentObject(Game())
    }
}
