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
                    OceanZoneView(state: $game.zoneStates[x][y], image: game.fleet2.getShipImage(location: Coordinate(x: x, y: y)))
//                        .frame(height: geo.size.height/CGFloat(Game.numRows))
                    // comment the line below to disable square ocean view
                        .frame(height: min(geo.size.height/CGFloat(Game.numRows), geo.size.width/CGFloat(Game.numCols)))
                        .onTapGesture {
                            // if my turn
                            if (game.isMyTurn) {
                                game.zoneTapped(location)
                            }
                        }

                }
            }
            // comment the 3 lines below to disable square ocean view
            .frame(width: min(geo.size.width, geo.size.height))
            .frame(maxHeight: .infinity, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onDisappear(perform: saveStateToFirestore)
        
//        Spacer(minLength: 20)
    }
    
    func saveStateToFirestore() {
        let arr = getCurrentZoneStates(zoneStates: game.zoneStates)
        
        // Convert array to json string
        let jsonStr = arrToJson(arr: arr)!
        
        // Convert my fleet
//        var myFleet = [(name: String, length: [(x: Int, y: Int, state: Int)])]()
//        var ship1 = [(x: Int, y: Int, state: Int)]()
//        for ship in game.fleet2.ships {
//            myFleet.append((name: ship.name, length: [(x: 0, y: 0, state: 0)]))
//            for (index, coordinate) in ship.coordinates().enumerated() {
//                myFleet[myFleet.endIndex - 1].length.append((x: coordinate.x, y: coordinate.y, state: (ship.compartments[index].flooded == false ? 0 : 1)))
////                ship1.append((x: coordinate.x, y: coordinate.y, state: (ship.compartments[index].flooded == false ? 0 : 1)))
//            }
//        }
//        print("line 62 myFleet", myFleet)
        
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
        
        // Convert Fleet to String
//        print("line 76", fleetToStr(fleet: game.fleet2)!)
        let myFleetStr = fleetToStr(fleet: game.fleet2)!
        let botFleetStr = fleetToStr(fleet: game.fleet)!
        db.collection("users").document(game.username).setData([
            "pwd": "1234",
            "state": jsonStr,
            "myFleet": myFleetStr,
            "botFleet": botFleetStr,
            "score": game.myScore
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                // Update prev state
                game.prevZoneStates = game.zoneStates
            }
        }
        
        // Update leaderboard
        game.updateLeaderboard(username: game.username, score: game.myScore)
    }
    
    func fleetToStr(fleet: Fleet) -> String? {
        do {
            let encodedData = try JSONEncoder().encode(fleet)
            let jsonString = String(data: encodedData,
                                    encoding: .utf8)
            return jsonString
        } catch {
            //handle error
            print(error)
            
            return ""
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
