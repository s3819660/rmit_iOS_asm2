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
 a Ship represents a ship with a name and a set of coordiantes that it occupies via ShipCompartments
 Each compartment can be individually flooded.
 If all compartments are flooded, the ship is sunk.
 */
class Ship: Codable {
    var name: String
    var compartments: [ShipCompartment]
    var length: Int {return compartments.count}
    
    init(_ name: String, coordinates: [Coordinate]) {
        self.name = name
        self.compartments = [ShipCompartment]()
        for coordinate in coordinates {
            compartments.append(ShipCompartment(location: coordinate))
        }
    }
    
    /*
     return all the coordinates that the ship occupies
     */
    func coordinates() -> [Coordinate] {
        return Array(compartments.map {$0.location})
    }
    
    /*
     return true if the ship occupies the given coordinate
     */
    func occupies(_ location: Coordinate) -> Bool
    {
        return compartments.contains(where:{$0.location == location})
    }
    
    /*
     return true if the ship is sunk (ie; all compartments are flooded)
     */
    func isSunk() -> Bool
    {
        //we're not sunk if at least one of our compartments is empty (ie not flooded)
        return !compartments.contains(where: {!$0.flooded})
    }
    
    /*
     the ship is hit at the given coordinate.
     */
    func hit(at location: Coordinate) {
        if let compartment = compartments.first(where: {$0.location == location}) {
            compartment.flooded = true
        }
    }
}

extension Ship: CustomStringConvertible {
    var description: String {
        return name + ": " + compartments.description
        }
}

