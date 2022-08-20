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

/*
 the Fleet of ships in the game
 */
class Fleet {
//    static let shipsInFleet:[(name: String, length: Int)] = [("PT Boat", 2),
//                                                         ("Submarine", 3),
//                                                         ("Destroyer", 3),
//                                                         ("Battleship", 4),
//                                                         ("Aircraft Carrier", 5)]
    static let shipsInFleet:[(name: String, length: Int)] = [("PT Boat", 2),
                                                         ("Submarine", 3),
                                                         ("Destroyer", 3),
                                                         ("Battleship", 2),
                                                         ("Aircraft Carrier", 2)]
    var ships: [Ship]
    var isBot: Bool
    var opponentCoordinates: [Coordinate]
//    var opponentShips: [Ship]
    
    init() {
        ships = [Ship]()
        isBot = true
        opponentCoordinates = [Coordinate]()
//        opponentShips = [Ship]()
    }
    
    init(isBot: Bool) {
        ships = [Ship]()
        self.isBot = isBot
        opponentCoordinates = [Coordinate]()
//        opponentShips = [Ship]()
    }
    
    /*
     return true if he fleet is destoryed
     */
    func isDestroyed() -> Bool {
        //if our fleet contains a ship that is NOT sunk then our fleet is not destoryed yet
        return !ships.contains(where:{!$0.isSunk()})
    }
    
    /*
     return the ship occupying the given Coordinate or nil if none found
     */
    func ship(at location: Coordinate) -> Ship? {
        return ships.first(where:{$0.occupies(location)})
    }
    
    /*
     deploy the fleet in random locations on the given ocean
     */
    func deploy(on ocean: Ocean) {
        ships.removeAll()
        for ship in Fleet.shipsInFleet {
            //get all the possible locations that the ship can fit in the ocean without intersecting
            //with a ship that is already deployed
            let fleetCoordinates = self.coordinates()
            let oceanCoordinates = ocean.locationsThatFit(length: ship.length)
            let possibleLocations = oceanCoordinates.filter {Set($0).intersection(fleetCoordinates).isEmpty}
            guard (possibleLocations.count > 0) else {
                assertionFailure("Cannot fit ship in ocean.!")
                return
            }
            
            //pick one of the locations at random and deploy the ship there
            let randomIndex = Int.random(in: 0..<possibleLocations.count)
            let shipCoordinates = possibleLocations[randomIndex]
            let deployedShip = Ship(ship.name, coordinates: shipCoordinates)
            ships.append(deployedShip)
        }
    }
    
    // deploy fleet for bot
    func deployPlayerFleet(on ocean: Ocean, opponentCoordinates: [Coordinate]) {
        ships.removeAll()
        
//        for e in opponentCoordinates {
//            print(e)
//        }

        for ship in Fleet.shipsInFleet {
            //get all the possible locations that the ship can fit in the ocean without intersecting
            //with a ship that is already deployed
            let fleetCoordinates = self.coordinates()
            let oceanCoordinates = ocean.locationsThatFit(length: ship.length)

            // merge opponents coordinates and own coordinates
            let allShipCoordinates = fleetCoordinates + opponentCoordinates
            // get all possible locations
            let possibleLocations = oceanCoordinates.filter {Set($0).intersection(allShipCoordinates).isEmpty}
            
            guard (possibleLocations.count > 0) else {
                assertionFailure("Cannot fit ship in ocean.!")
                return
            }

            //pick one of the locations at random and deploy the ship there
            let randomIndex = Int.random(in: 0..<possibleLocations.count)
            let shipCoordinates = possibleLocations[randomIndex]
            let deployedShip = Ship(ship.name, coordinates: shipCoordinates)
            ships.append(deployedShip)
        }
//        print("opponentCoordinates\n")
//        print(opponentCoordinates)
//        print("\n\ndeployed ships\n")
//        print(ships)
    }
    
    /*
     returns all the Coordinates of the deployed fleet in an array
     */
    func coordinates() -> [Coordinate] {
        let coordinates = ships.map {$0.compartments.map {$0.location}}
        
//        print(ships)
//        print(coordinates)
        
        
        return Array(coordinates.joined())
    }
}
