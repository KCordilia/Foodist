//
//  SpeechViewController.swift
//  Foodist
//
//  Created by Karim Cordilia on 19/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechViewController: UIViewController {
    @IBOutlet weak var playButtonImage: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    let speechSynthesizer = AVSpeechSynthesizer()
    let speechUtterance = AVSpeechUtterance(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et purus sit amet arcu elementum suscipit id eu lacus. Morbi vitae ullamcorper.")

    var currentState: State = .stopped

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    }

    @IBAction func previous(_ sender: Any) {
        print("previous button is tapped")
    }

    @IBAction func playAndPause(_ sender: Any) {
        switch currentState {
        case .playing: pause()
        case .paused: play(stringToPlay: speechUtterance)
        case .stopped: play(stringToPlay: speechUtterance)
        }
    }

    @IBAction func stop(_ sender: Any) {
        stop()
        print("stop button is tapped")
    }

    @IBAction func next(_ sender: Any) {
        print("next button is tapped")
    }

    func play(stringToPlay: AVSpeechUtterance) {
        if currentState == .stopped {
            currentState = .playing
            setAvailabiltyForControls()
            playButtonImage.setImage(UIImage(named: "Navigation_Pause_2x"), for: .normal)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            speechSynthesizer.speak(stringToPlay)
        } else if currentState == .paused {
            speechSynthesizer.continueSpeaking()
            playButtonImage.setImage(UIImage(named: "Navigation_Pause_2x"), for: .normal)
        } else {
            speechSynthesizer.speak(stringToPlay)
        }
    }

    func pause() {
        // Speech synthesizer will pause
        currentState = .paused
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            playButtonImage.setImage(UIImage(named: "Navigation_Play_2x"), for: .normal)
        } else {
            play(stringToPlay: speechUtterance)
            currentState = .playing
        }
    }

    func stop() {
        // Speech synthesizer will stop
        currentState = .stopped
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.word)
            playButtonImage.setImage(UIImage(named: "Navigation_Play_2x"), for: .normal)
            disableAVSession()
            setAvailabiltyForControls()
        }
    }

    func initialSetup() {
        stop()
        setAvailabiltyForControls()
    }

    func setAvailabiltyForControls() {
        if currentState == .playing {
            previousButton.isEnabled = true
            nextButton.isEnabled = true
        } else {
            previousButton.isEnabled = false
            nextButton.isEnabled = false
        }
    }

    private func disableAVSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't disabled.")
        }
    }
}
