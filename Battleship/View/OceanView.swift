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

/*
 An OceanView consists of a grid of OceanZoneViews
 */
struct OceanView: View {
    @EnvironmentObject var game: Game
    let range = (0..<(Game.numCols * Game.numRows))
    let columns = [GridItem](repeating: GridItem(.flexible(), spacing: 0), count: Game.numCols)
    
    var body: some View {
        GeometryReader {geo in
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(range, id: \.self) {index in
                    let y = index / Game.numRows
                    let x = index - (y * Game.numCols)
                    let location = Coordinate(x: x, y: y)
                    OceanZoneView(state: $game.zoneStates[x][y])
                        .frame(height: geo.size.height/CGFloat(Game.numRows))
                        .onTapGesture {
                            // if my turn
                            if (game.isMyTurn) {                                game.zoneTapped(location)
                            }
                        }
                    
                }
            }
        }
    }
}

struct OceanView_Previews: PreviewProvider {
    static var previews: some View {
        OceanView()
            .environmentObject(Game())
    }
}
