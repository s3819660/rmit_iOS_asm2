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
 represents a compartment within a ship which has a location and can also be flooded
 */
class ShipCompartment {
    var location: Coordinate = .zero
    var flooded: Bool = false
    
    init(location: Coordinate, flooded:Bool = false) {
        self.location = location
        self.flooded = flooded
    }
}

extension ShipCompartment: CustomStringConvertible {
    var description: String {
        return location.description
        }
}
