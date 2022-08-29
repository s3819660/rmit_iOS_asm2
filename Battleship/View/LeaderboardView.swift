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

struct LeaderboardView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            
            ScrollView {
                Spacer(minLength: 20)
                
                VStack {
                    ForEach(0..<game.leaderboard.count, id: \.self) { i in
                        LeaderCard(username: game.leaderboard[i].username,
                                   score: game.leaderboard[i].score,
                                   rating: (i < 1) ? 5 : (i < 2) ? 4.5 : (i < 4) ? 4 : (i < 8) ? 3.5 : (i < 12) ? 4 : (i < 16) ? 4.5 : 5,
                                   avatarImage: game.leaderboard[i].image,
                                   medalImage: (i < 1) ? "medal_1" : (i < 2) ? "medal_2" : (i < 3) ? "medal_3" : "",
                                   rank: i)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 30)
                                    .padding(.horizontal, 10)
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

struct LeaderCard: View {
    var username = ""
    var score = 0
    var rating:Float = 3.5
    var avatarImage = "avatar_1"
    var medalImage = "medal_1"
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
                        .padding(.leading, 10)
                        .frame(width: 45, height: geo.size.height * 5)
                }

                if (geo.size.width > 450) {
                    Image(avatarImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geo.size.height * 6)
                        .padding(.leading, 10)
                }
                
                HStack {
//                    Text(username.count > 15 ? "\(username.prefix(12))..." : username)
                    Text(getUsernameStr(username: username,screenWidth: geo.size.width))
                        .font(.title3)
                        .bold()
                        .padding(.leading, 10)
                        .frame(width: (geo.size.width > 450) ? 200 : 110)
                    Spacer()
                    StarsView(rating: self.rating)
                    Spacer()
                    Text("\(score)")
                        .font(.title3)
                        .bold()
                        .padding(.trailing, 20)
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

struct StarsView: View {
    private static let MAX_RATING: Float = 5 // Defines upper limit of the rating
    private static let COLOR = Color.orange // The color of the stars

    let rating: Float
    private let fullCount: Int
    private let emptyCount: Int
    private let halfFullCount: Int

    init(rating: Float) {
        self.rating = rating
        fullCount = Int(rating)
        emptyCount = Int(StarsView.MAX_RATING - rating)
        halfFullCount = (Float(fullCount + emptyCount) < StarsView.MAX_RATING) ? 1 : 0
    }

    var body: some View {
        HStack {
            ForEach(0..<fullCount, id: \.self) { _ in
                self.fullStar
            }
            ForEach(0..<halfFullCount, id: \.self) { _ in
                self.halfFullStar
            }
            ForEach(0..<emptyCount, id: \.self) { _ in
                self.emptyStar
            }
        }
    }

    private var fullStar: some View {
        Image(systemName: "star.fill").foregroundColor(StarsView.COLOR)
    }

    private var halfFullStar: some View {
        Image(systemName: "star.lefthalf.fill").foregroundColor(StarsView.COLOR)
    }

    private var emptyStar: some View {
        Image(systemName: "star").foregroundColor(StarsView.COLOR)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
