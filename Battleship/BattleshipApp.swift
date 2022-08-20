//
//  BattleshipApp.swift
//  Battleship
//
//  Created by Phuc Nguyen Phuoc Nhu on 20/08/2022.
//

import SwiftUI

@main
struct BattleshipApp: App {
    @StateObject private var game = Game()
       
    var body: some Scene {
       WindowGroup {
           ContentView()
               .environmentObject(game)
               .preferredColorScheme(.dark)
       }
    }
}
