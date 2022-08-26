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
 represents a zone in an ocean
 A circle will be drawn if the state is not .clear
 */
struct OceanZoneView: View {
    @Binding var state: OceanZoneState
    private let circleScale = CGSize(width: 0.5, height: 0.5)
    
    var body: some View {
        ZStack {
            Rectangle()
                .strokeBorder(.gray.opacity(0.3), lineWidth: 2)
//                .background(.blue)
            
            if (state != .clear) {
                ScaledShape(shape: Circle(), scale: circleScale)
                    .fill(circleColor())
            }
        }
    }
    
    func circleColor() -> Color {
//        return (state == .hit) ? .red : .white
        
//        return (state == .hit) ? .red : (state == .myCompartment) ? .yellow : .white // yellow is my compartment
        
        // with bot's move
        return (state == .hit) ? .red : (state == .myCompartment) ? .yellow : (state == .opponentHit) ? .black : (state == .opponentMiss) ? .purple : .white // yellow is my compartment
    }
}

struct OceanZoneView_Previews: PreviewProvider {
    static var previews: some View {
        OceanZoneView(state: .constant(.miss))
    }
}
