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
import Combine

final class SettingsStore: ObservableObject {
    private enum Keys {
        static let isSoundOn = "sound_on"
        static let difficultyLevel = "difficulty_level"
        static let isDarkMode = "app_UI_mode"
    }

    private let cancellable: Cancellable
    private let defaults: UserDefaults

    let objectWillChange = PassthroughSubject<Void, Never>()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Keys.isSoundOn: true,
            Keys.difficultyLevel: DifficultyLevel.Moderate.rawValue
            ])

        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }

    var isSoundOn: Bool {
        set { defaults.set(newValue, forKey: Keys.isSoundOn) }
        get { defaults.bool(forKey: Keys.isSoundOn) }
    }
    
    var isDarkMode: Bool {
        set { defaults.set(newValue, forKey: Keys.isDarkMode) }
        get { defaults.bool(forKey: Keys.isDarkMode) }
    }

    enum DifficultyLevel: String, CaseIterable {
        case Easy
        case Moderate
        case Hard
    }

    var difficultyLevel: DifficultyLevel {
        get {
            return defaults.string(forKey: Keys.difficultyLevel)
                .flatMap { DifficultyLevel(rawValue: $0) } ?? .Moderate
        }

        set {
            defaults.set(newValue.rawValue, forKey: Keys.difficultyLevel)
        }
    }
}
