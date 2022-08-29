//
//  PlaySound.swift
//  Battleship
//
//  Created by Phuc Nguyen Phuoc Nhu on 28/08/2022.
//

import AVFoundation

var backgroundAudioPlayer: AVAudioPlayer?
var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR: Could not find and play the sound file!")
        }
    }
}

func playBackgroundAudio(sound: String, type: String) {
         if let path = Bundle.main.path(forResource: sound, ofType: type) {
         do {
             backgroundAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
             // backgroundAudioPlayer.currentTime = 0
             // infinite loop
             backgroundAudioPlayer?.numberOfLoops =  -1
             backgroundAudioPlayer?.play()
         } catch {
             print("ERROR: Could not find and play the sound file!")
         }
     }
 }

 func stopBackgroundAudio() {
     backgroundAudioPlayer?.stop()
 }
