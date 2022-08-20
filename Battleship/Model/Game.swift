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

import Foundation
import Combine

/*
 The classic Battleship game
 */
final class Game: ObservableObject {
    static let numCols = 10
    static let numRows = 10
//    static let numCols = 6
//    static let numRows = 6
    var ocean: Ocean
    var fleet: Fleet
    var fleet2: Fleet
    @Published var zoneStates = [[OceanZoneState]]()
    @Published var message = ""
    @Published var isMyTurn = true
    var over: Bool {return fleet.isDestroyed()}
    var botWin: Bool {return fleet2.isDestroyed()} // game is over when player wins or bot wins
    var difficultyLevel = 1
    var botLastHitShip = [Coordinate]()
    
//    fleet: bot's fleet
//    fleet2: player's fleet
    init() {
        self.ocean = Ocean(numCols: Game.numCols, numRows: Game.numRows)
        self.fleet = Fleet()
        self.fleet2 = Fleet(isBot: false)
        reset()
    }
    
    /*
     start a new game
     */
    func reset() {
        self.zoneStates = defaultZoneStates()
        self.fleet.deploy(on: self.ocean)
        self.message = ""
        // reset isMyTurn
        isMyTurn = true
        
        // deploy bot fleet
        let opponentCoordinates: [Coordinate] = self.fleet.coordinates()
        // pass opponent coordinates so that player can deploy ship without intersecting
        self.fleet2.deployPlayerFleet(on: self.ocean, opponentCoordinates: opponentCoordinates)
        
        // set zone state Ship at player's coordinates
        for e in self.fleet2.coordinates() {
            zoneStates[e.x][e.y] = .myCompartment
        }
    }
    
    /*
     handle when an OceanZoneView is tapped
     */
    func zoneTapped(_ location: Coordinate) {
        //if we already tapped this location or the game is over, just ignore it
        if ((zoneStates[location.x][location.y] != .clear) || over || (zoneStates[location.x][location.y] == .myCompartment)) {
            print("invalid tap, tap again")
            return
        }
        
        //see if we hit a ship
        if let hitShip = fleet.ship(at: location) {
            hitShip.hit(at: location)
            zoneStates[location.x][location.y] = .hit
            message = hitShip.isSunk() ? "You sunk their \(hitShip.name)!" : "You Hit"
        } else {
            zoneStates[location.x][location.y] = .miss
            message = "You Miss"
        }
        
        //are we done?
        if (over) {
            message += " YOU WIN!"
            return
        }
        
        // turn off the 2 lines below to disable bot
        isMyTurn = false
        // isBotValidMove => getAdjacentMove => getBotNextMove => generateBotMove => placeBotMove
        placeBotMove()
    }
    
    // Place bot move on the Ocean
    func placeBotMove() {
//        print("Bot's turn")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Generate Bot's move
            let location = self.generateBotMove()

            //if we already tapped this location or the game is over, just ignore it
            if (((self.zoneStates[location.x][location.y] != .clear)
                 && (self.zoneStates[location.x][location.y] != .myCompartment))
                || self.botWin) {
                return
            }
    
            //see if we hit a ship
            if let hitShip = self.fleet2.ship(at: location) {
                hitShip.hit(at: location)
                self.zoneStates[location.x][location.y] = .opponentHit
                self.message = hitShip.isSunk() ? "Bot sunk your \(hitShip.name)!" : "Bot Hit"
                
                // TODO: Save to last hit location
                // find all coordinates of ship and append to botLastHitShip
                // after sunking a ship, clear botLastHitShip
                self.botLastHitShip.append(location)
                print(self.botLastHitShip)
                
            } else {
                self.zoneStates[location.x][location.y] = .opponentMiss
                self.message = "Bot Miss"
            }

            //are we done?
            if (self.botWin) {
                self.message += " BOT WIN!"
                return // end game so player can no longer tap
            }
            
            // Toggle isMyTurn
            self.isMyTurn = true
//            print("My turn")
        }
    }
    
    // generate bot move regarding to difficulty level (give bot hints)
    func generateBotMove() -> Coordinate {
        var location = Coordinate(x: 0, y: 0)
        
        // Bot doesn't know where my ships are
        // Random bot move
        if difficultyLevel == 0 {
            var found = false
            for (i, x) in self.zoneStates.enumerated() {
                for (j, y) in x.enumerated() {
                    // bot cannot hit their own ship
                    let coordinates = self.fleet.ships.map {$0.compartments.map {$0.location}}
                    location.x = i
                    location.y = j
                    if ((y == .clear || y == .myCompartment) && (!Array(coordinates.joined()).contains(location))) {
//                    if (y == .myCompartment) { //bot always wins
                        print([i, j])
                        location.x = i
                        location.y = j
                        found = true
                        break
                    }
                }
                
                if found {
                    break
                }
            }
        } else if difficultyLevel == 1 { // Bot knows where 30% of my ships are (2 ships)
            
            location = getBotNextMove()
//            var found = false
//            for (i, x) in self.zoneStates.enumerated() {
//                for (j, y) in x.enumerated() {
//                    // bot cannot hit their own ship
//                    let coordinates = self.fleet.ships.map {$0.compartments.map {$0.location}}
//                    location.x = i
//                    location.y = j
//                    if ((y == .clear || y == .myCompartment) && (!Array(coordinates.joined()).contains(location))) {
////                    if (y == .myCompartment) { //bot always wins
//                        print([i, j])
//                        location.x = i
//                        location.y = j
//                        found = true
//                        break
//                    }
//                }
//
//                if found {
//                    break
//                }
//            }
        } else { // Bot knows where 60% of my ships are (3.5 ships)
            
        }
        
        return location
    }
    
    // Get bot next move (searching)
    func getBotNextMove() -> Coordinate {
        var location = Coordinate(x: 0, y: 0)
        // if bot just hit
        // search for adjacent locations
        if !botLastHitShip.isEmpty {
            // get adjacent move to search for ship location
            let lastHitLocation = botLastHitShip[botLastHitShip.endIndex - 1]
            location = getAdjacentLocation(lastHitLocation: lastHitLocation)
            print("adjacentLocation=", location)
        } else {
            // get random (i + j) % 2 == 0 location
            var found = false
            for (i, x) in self.zoneStates.enumerated() {
                for (j, y) in x.enumerated() where ((i + j) % 2 == 0) {
                    // bot cannot hit their own ship
                    let coordinates = self.fleet.ships.map {$0.compartments.map {$0.location}}
                    location.x = i
                    location.y = j

                    if ((y == .clear || y == .myCompartment) && (!Array(coordinates.joined()).contains(location))) {
    //                if (y == .myCompartment) { //bot always wins
                        location.x = i
                        location.y = j
                        found = true
                        break
                    }
                }

                if found {
                    break
                }
            }
        }
        
        return location
    }
    
    // get adjacent move from last hit location
    func getAdjacentLocation(lastHitLocation: Coordinate) -> Coordinate {
        var location = Coordinate(x: -1, y: -1)
        let lastX = lastHitLocation.x
        let lastY = lastHitLocation.y
        
        if (lastX < Game.numCols && isBotValidMove(x: lastX + 1, y: lastY)) {
            location.x = lastX + 1
            location.y = lastY
        } else if (lastX > 0 && isBotValidMove(x: lastX - 1, y: lastY)) {
            location.x = lastX - 1
            location.y = lastY
        } else if (lastY < Game.numRows && isBotValidMove(x: lastX, y: lastY + 1)) {
            location.y = lastY + 1
            location.x = lastX
        } else if (lastY > 0 && isBotValidMove(x: lastX, y: lastY - 1)) {
            location.y = lastY - 1
            location.x = lastX
        }
        
        return location
    }
    
    // check if a location is valid for bot
    func isBotValidMove(x: Int, y: Int) -> Bool {
        return ((zoneStates[x][y] == .clear) || (zoneStates[x][y] == .myCompartment))
    }
    
    /*
     create a two dimensional array of OceanZoneStates all set to .clear
     */
    private func defaultZoneStates() -> [[OceanZoneState]] {
        var states = [[OceanZoneState]]()
        for x in 0..<Game.numCols {
            states.append([])
            for _ in 0..<Game.numRows {
                states[x].append(.clear)
            }
        }
        return states
    }
}
