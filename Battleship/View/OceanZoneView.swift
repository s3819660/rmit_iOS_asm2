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
    var image: String
    private let circleScale = CGSize(width: 0.65, height: 0.65)
    
    var body: some View {
        ZStack {
            Rectangle()
                .strokeBorder(.gray.opacity(0.3), lineWidth: 2)
                .background(Color("BackgroundColor"))
            if !image.isEmpty {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if (state != .clear && state != .myCompartment) {
                ScaledShape(shape: XMark(), scale: circleScale)
                    .stroke(circleColor(), lineWidth: 6)
            }
        }
    }
    
    func circleColor() -> Color {
//        return (state == .hit) ? .red : .white
        
//        return (state == .hit) ? .red : (state == .myCompartment) ? .yellow : .white // yellow is my compartment
        
        // with bot's move
//        return (state == .hit) ? .red : (state == .myCompartment) ? .yellow : (state == .opponentHit) ? .black : (state == .opponentMiss) ? .purple : .white // yellow is my compartment
        
        return (state == .hit) ? .red : (state == .opponentHit) ? .black : .white
    }
}

struct XMark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.size.width))
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.width))
        path.closeSubpath()
        return path
    }
}

struct OceanZoneView_Previews: PreviewProvider {
    static var previews: some View {
        OceanZoneView(state: .constant(.miss), image: "ship2_1h")
    }
}
