//
//  SpeechViewController.swift
//  Foodist
//
//  Created by Karim Cordilia on 19/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit
import AVFoundation

protocol Speakable: class {
    func setUpTextToSpeak(_ text: String)
}

class SpeechViewController: UIViewController {
    @IBOutlet weak var playButtonImage: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    let speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance?
    var recipeInstructions: [String] = []
    var currentState: State = .stopped
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        playButtonImage.isEnabled = false
    }

    @IBAction func previous(_ sender: Any) {
        currentIndex -= 1
        if currentIndex <= recipeInstructions.count + 1 {
            stop()
            play(stringToPlay: recipeInstructions[currentIndex])
        }
        if currentIndex == 0 {
            previousButton.isEnabled = false
        }
    }

    @IBAction func playAndPause(_ sender: Any) {
        switch currentState {
        case .playing: pause()
        case .paused: play(stringToPlay: recipeInstructions[currentIndex])
        case .stopped: play(stringToPlay: recipeInstructions[currentIndex])
        }
    }

    @IBAction func stop(_ sender: Any) {
        stop()
    }

    @IBAction func next(_ sender: Any) {
        currentIndex += 1
        if currentIndex <= recipeInstructions.count - 1 {
            stop()
            play(stringToPlay: recipeInstructions[currentIndex])
        }
        if currentIndex == recipeInstructions.count - 1 {
            nextButton.isEnabled = false
        }
    }

    func play(stringToPlay: String) {
       speechUtterance = AVSpeechUtterance(string: stringToPlay)
        guard let
            speechUtterance = speechUtterance
            else { return }

        if currentIndex > 0 {
            previousButton.isEnabled = true
        }

        if currentState == .stopped {
            currentState = .playing
            setAvailabiltyForControls()
            playButtonImage.setImage(UIImage(named: "Navigation_Pause_2x"), for: .normal)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .allowBluetooth)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            speechSynthesizer.speak(speechUtterance)
        } else if currentState == .paused {
            speechSynthesizer.continueSpeaking()
            playButtonImage.setImage(UIImage(named: "Navigation_Pause_2x"), for: .normal)
            currentState = .playing
        } else {
            speechSynthesizer.speak(speechUtterance)
        }
    }

    func pause() {
        currentState = .paused
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            playButtonImage.setImage(UIImage(named: "Navigation_Play_2x"), for: .normal)
        } else {
            play(stringToPlay: recipeInstructions[0])
            currentState = .playing
        }
    }

    func stop() {
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
        guard let
            speechUtterance = speechUtterance
            else { return }
            speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    }

    func setAvailabiltyForControls() {
        if currentState == .playing {
//            previousButton.isEnabled = true
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

extension SpeechViewController: Speakable {
    func setUpTextToSpeak(_ text: String) {
        recipeInstructions.append(text)
        print(recipeInstructions)
        playButtonImage.isEnabled = true
    }
}
