//
//  SpeechViewController.swift
//  Foodist
//
//  Created by Karim Cordilia on 19/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit
import AVFoundation

protocol Speakable {
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
    var text = ""
   // weak var sourceVc: RecipeDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func previous(_ sender: Any) {
    }

    @IBAction func playAndPause(_ sender: Any) {
        switch currentState {
        case .playing: pause()
        case .paused: play(stringToPlay: text)
        case .stopped: play(stringToPlay: text)
        }
    }

    @IBAction func stop(_ sender: Any) {
        stop()
    }

    @IBAction func next(_ sender: Any) {
    }

    func recieveTextToSpeak(_ text: String) {
        self.text = text
    }

    func play(stringToPlay: String) {
       speechUtterance = AVSpeechUtterance(string: stringToPlay)
         initialSetup()
        if currentState == .stopped {
            currentState = .playing
//            setAvailabiltyForControls()
            playButtonImage.setImage(UIImage(named: "Navigation_Pause_2x"), for: .normal)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            speechSynthesizer.speak(speechUtterance!)
        } else if currentState == .paused {
            speechSynthesizer.continueSpeaking()
            playButtonImage.setImage(UIImage(named: "Navigation_Pause_2x"), for: .normal)
            currentState = .playing
        } else {
            speechSynthesizer.speak(speechUtterance!)
        }
    }

    func pause() {
        currentState = .paused
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            playButtonImage.setImage(UIImage(named: "Navigation_Play_2x"), for: .normal)
        } else {
            play(stringToPlay: text)
            currentState = .playing
        }
    }

    func stop() {
        currentState = .stopped
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.word)
            playButtonImage.setImage(UIImage(named: "Navigation_Play_2x"), for: .normal)
            disableAVSession()
//            setAvailabiltyForControls()
        }
    }

    func initialSetup() {
        stop()
//        setAvailabiltyForControls()
        speechUtterance!.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance!.voice = AVSpeechSynthesisVoice(language: "en-US")
    }
//
//    func setAvailabiltyForControls() {
//        if currentState == .playing {
//            previousButton.isEnabled = true
//            nextButton.isEnabled = true
//        } else {
//            previousButton.isEnabled = false
//            nextButton.isEnabled = false
//        }
//    }

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
        self.text = text
    }
}
