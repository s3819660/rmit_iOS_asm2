//
//  AchievementsView.swift
//  Battleship
//
//  Created by Phuc Nguyen Phuoc Nhu on 29/08/2022.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            
            ScrollView {
                Spacer(minLength: 20)
                
                VStack {
                    ForEach(1...game.myScore, id: \.self) { i in
                        if (i == 1 || i == 3 || i == 5 || i == 10 || i == 20 || i == 50 || i == 100) {
                            AchievementCard(
                                       medalImage: "trophy_\(i)",
                                       rank: i)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 30)
                                        .padding(.horizontal, 10)
                        }
                    }
                }
            }
                .navigationViewStyle(.stack)
                .navigationBarTitle("Leaderboard", displayMode: .inline)
                .padding(.top, 55)
                .onAppear {
                    // Play background music
                    if game.isSoundOn {
                        playBackgroundAudio(sound: "achievements", type: "mp3")
                    }
                }
                .onDisappear {
                    stopBackgroundAudio()
                }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct AchievementCard: View {
    var medalImage = "trophy_1"
    var rank = 0
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                if !medalImage.isEmpty {
                    Image(medalImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geo.size.height * 5)
                        .padding(.leading, 10)
                } else {
                    Text("\(rank + 1)")
                        .font(.title)
                        .bold()
                        .padding(.trailing, 10)
                }
                
                HStack {
                    Spacer()
                    Text("You have won \(rank) times!")
                        .font(.title3)
                        .bold()
                        .padding(.leading, 10)
//                        .frame(width: (geo.size.width > 450) ? 200 : 110)
//                        .frame(height: 50)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(10)
//                        .padding(.leading, 10)
//                        .frame(maxWidth: (geo.size.width > 700) ? 450 : .infinity)

                    Spacer()
                }
                .frame(height: 50)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.leading, 10)
                .frame(maxWidth: (geo.size.width > 700) ? 450 : .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    func getUsernameStr(username: String, screenWidth: CGFloat) -> String {
        if (screenWidth < 451) {
            return username.count > 8 ? "\(username.prefix(6))..." : username
        }
        return username.count > 15 ? "\(username.prefix(12))..." : username
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
