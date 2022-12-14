//
//  HowToPlayView.swift
//  Battleship
//
//  Created by Phuc Nguyen Phuoc Nhu on 20/08/2022.
//

import SwiftUI

struct HowToPlayView: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text("About")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("TextColor"))
                        .padding(.bottom, 8)
                    Text("Game of Battleships, also commonly known as Sea Battle and Battleship unblocked, was created during World War 1 as a pencil and paper game. It became a plastic board game in 1967 and was adapted later on to electronic versions. In this iOS game of Battleship, you can play with AI, in order to win points and obtain a higher ranking! Read our strategies and tactics to help you achieve your goal to become the Number One player! This multiplayer game enables you to enjoy the classic Battleship game while challenging your skills and sharpness! Since the system automatically indicates when a ship has been hit, you can maximize your time in tactical thinking rather than looking down on your bot opponent!")
                        .padding(.bottom, 20)
                    
                    Text("Rules of Battleship")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("TextColor"))
                        .padding(.bottom, 8)
                    Text("Two players challenge each other by using a 10×10 grid in virtual Battleship. The player who destroys the totality of their opponent’s fleet wins the game. After the ships are randomly positioned, each opponent fire upon squares in the adverse grid and tries to sink their enemies fleet in turns. The program indicates automatically whether there has been a hit or a miss. When a player hits an opponent’s ship, they can fire again. There are 5 ships in total: 3 ships with 2 compartments (Submarine and Destroyer) and 2 ships with 3 compartments (PT Boat, Battleship and Aircraft Carrier).")
                        .padding(.bottom, 20)
                    Text("Introduction")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("TextColor"))
                        .padding(.bottom, 8)
                    Text("Choose an empty cell and tap on it to strike. The gray circle represents the strike that missed the target.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("miss")
                    Text("A red X mark represents a hit that has damaged a compartment of one of the opponents' ships.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("hit")
                }

                VStack {
                    Text("The ships that you see on the ocean belong to your fleet. You have 5 ships in total with a sum of 12 in compartments length.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("fleet")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Text("A black X mark represents a hit struck by the opponents that has damaged a compartment of one of your ships.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("opponent_hit")
                    Text("Replay button is used to deploy both fleets in other locations and restart game.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "repeat.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                    Text("Quit Game button would take the player back to the menu and save the game state.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "stop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundColor(.gray.opacity(0.9))
        }
        .background(Color("BackgroundColor"))
        .navigationBarTitle(Text("How To Play"))
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
