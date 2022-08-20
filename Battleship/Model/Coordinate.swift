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
 a simple x,y coordinate
 */
struct Coordinate: Hashable {
    var x: Int = 0
    var y: Int = 0
    static var zero = Coordinate(x: 0, y: 0)
    
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
            return "(\(x), \(y))"
        }
}
