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

struct MenuView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var game: Game
//    @State var isResumeHidden = true // should be true for new user
    @State private var selection: Int? = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                
                VStack {
                    Image("battleship_180")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .border(Color("AppIconBorderColor"), width: 4)

                    NavigationLink(destination: GameView(isNewGame: false), tag: 1, selection: $selection) {
                        EmptyView()
                    }
                        // hide Resume button if it is a new user
                        .opacity((game.prevZoneStates.isEmpty) ? 0 : 1)
//                        .onDisappear {
//                            // (Workaround) unhide Resume button for when new user creates a new game then go back to menu
//                            self.isResumeHidden = false
//                        }
                    NavigationLink(destination: GameView()) {
                        EmptyView()
                    }
                    NavigationLink(destination: LeaderboardView()) {
                        EmptyView()
                    }
                    NavigationLink(destination: SettingsView()) {
                        EmptyView()
                    }
                    NavigationLink(destination: HowToPlayView()) {
                        EmptyView()
                    }

                    Button(action: {
                        self.selection = 1
                    }) {
                        HStack {
                            Spacer()
                            Text("Resume").foregroundColor(Color.white).bold()
                            Spacer()
                        }
                    }
                        .opacity((game.prevZoneStates.isEmpty) ? 0 : 1)
                        .accentColor(Color.white)
                        .padding()
                        .background(Color("PrimaryColor"))
                        // .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)

                    Button(action: {
                        self.selection = 2
                    }) {
                        HStack {
                            Spacer()
                            Text("New Game").foregroundColor(Color.white).bold()
                            Spacer()
                        }
                    }
                        .opacity((game.prevZoneStates.isEmpty) ? 0 : 1)
                        .accentColor(Color.white)
                        .padding()
                        .background(Color("PrimaryColor"))
                        // .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)

                    Button(action: {
                        self.selection = 3
                    }) {
                        HStack {
                            Spacer()
                            Text("Leaderboard").foregroundColor(Color.white).bold()
                            Spacer()
                        }
                    }
                        .opacity((game.prevZoneStates.isEmpty) ? 0 : 1)
                        .accentColor(Color.white)
                        .padding()
                        .background(Color("PrimaryColor"))
                        // .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)

                    Button(action: {
                        self.selection = 4
                    }) {
                        HStack {
                            Spacer()
                            Text("Settings").foregroundColor(Color.white).bold()
                            Spacer()
                        }
                    }
                        .opacity((game.prevZoneStates.isEmpty) ? 0 : 1)
                        .accentColor(Color.white)
                        .padding()
                        .background(Color("PrimaryColor"))
                        // .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)                        

                    Button(action: {
                        self.selection = 5
                    }) {
                        HStack {
                            Spacer()
                            Text("How to play").foregroundColor(Color.white).bold()
                            Spacer()
                        }
                    }
                        .opacity((game.prevZoneStates.isEmpty) ? 0 : 1)
                        .accentColor(Color.white)
                        .padding()
                        .background(Color("PrimaryColor"))
                        // .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)   

                }
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    // Fetch leaderboard
                    game.fetchLeaderboard()
                    
                    // Initialize Navigation Bar style
                    initNavigationBarStyle()

                    // Play background music
                    if game.isSoundOn {
                        playBackgroundAudio(sound: "menu_background_audio", type: "mp3")
                    }

                    // if log out
                    if game.isLoggedOut {
                        self.presentation.wrappedValue.dismiss()
                    }
                }
                .onDisappear {
                    pauseBackgroundAudio()
                }
        }
            // fix NSLayoutContraints warnings
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true) // hide navigation from Log In page
            .accentColor(Color("TextColor"))
    }
    
    /*
     Initialize Navigation Bar style
     */
    func initNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        let textColor = UIColor(.white)

        appearance.backgroundColor = UIColor(Color("PrimaryColor"))
        appearance.largeTitleTextAttributes = [
           .foregroundColor: textColor,
           .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]
        appearance.titleTextAttributes = [
           .foregroundColor: textColor,
//               .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
