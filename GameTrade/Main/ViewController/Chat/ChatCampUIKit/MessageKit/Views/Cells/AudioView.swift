//
//  AudioView.swift
//  ChatCamp Demo
//
//  Created by Saurabh Gupta on 12/06/18.
//  Copyright © 2018 iFlyLabs Inc. All rights reserved.
//

import UIKit
import AVFoundation

class AudioView: UIView {
    
    var audioFileURL: URL!
    var audioPlayer: AVAudioPlayer?
    
    func playAudio(_ audioUrl: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            print("Could not load file")
        }
    }
}

extension AudioView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer = nil
        print("finished playing")
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
