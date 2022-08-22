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
import FirebaseCore
import FirebaseFirestore

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
                            if (game.isMyTurn) {
                                game.zoneTapped(location)
                            }
                        }

                }
            }
        }
        .onDisappear(perform: saveStateToFirestore)
    }
    
    func saveStateToFirestore() {
        let arr = getCurrentZoneStates(zoneStates: game.zoneStates)
        
        // Consert array to json string
        let jsonStr = arrToJson(arr: arr)!
        
        // Save to Firestore
//        db.collection("users").document("nhu").updateData([
//            "state": jsonStr
//        ]) {err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Successfully updated state to Firestore!")
//            }
//        }
        db.collection("users").document("nhu").setData([
            "pwd": "1234",
            "state": jsonStr
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                // Update prev state
                game.prevZoneStates = game.zoneStates
            }
        }
    }
    
    func arrToJson(arr: [[Int]]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: arr, options:  []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func getOceanZoneStateRawValue(zoneState: OceanZoneState) -> Int {
        return zoneState.rawValue
    }
    
    func getCurrentZoneStates(zoneStates: [[OceanZoneState]]) -> [[Int]] {
        var arr = [[Int]]()
        
        // Init game state 2D array of Int
        for (i, x) in zoneStates.enumerated() {
            arr.append([])
            for y in x {
                arr[i].append(getOceanZoneStateRawValue(zoneState: y))
            }
        }
        
        return arr
    }
}

struct OceanView_Previews: PreviewProvider {
    static var previews: some View {
        OceanView()
            .environmentObject(Game())
    }
}
