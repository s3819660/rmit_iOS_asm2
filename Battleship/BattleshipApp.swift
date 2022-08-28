//
//  BattleshipApp.swift
//  Battleship
//
//  Created by Phuc Nguyen Phuoc Nhu on 20/08/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

let db = Firestore.firestore()

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Settings form UI
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        return true
    }
}

@main
struct BattleshipApp: App {
    @StateObject private var game = Game()
    @StateObject private var settings = SettingsStore()
    
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
       WindowGroup {
           ContentView()
               .environmentObject(game)
               .environmentObject(settings)
               .preferredColorScheme(settings.isDarkMode ? .dark : .light)
       }
    }
}
