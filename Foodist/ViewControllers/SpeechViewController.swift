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
    let speechUtterance = AVSpeechUtterance(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et purus sit amet arcu elementum suscipit id eu lacus. Morbi vitae ullamcorper metus, vel pharetra sem. Nulla elementum libero in iaculis ullamcorper. Praesent fermentum erat sed arcu euismod lacinia. Integer eget felis dignissim, feugiat dolor quis, pellentesque velit. Ut ut pellentesque ex. Proin interdum sagittis turpis, at fringilla lacus consequat sit amet. Morbi eget felis dolor. Maecenas accumsan augue vitae dui porta rutrum. Maecenas libero massa, iaculis eu commodo eu, eleifend id neque. Nam posuere nisi eu dui ultricies, sed feugiat ipsum euismod. Phasellus sed nisi ex. Aliquam at ex nec nisi mollis venenatis a sed orci.")
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
    
    @IBAction func play(_ sender: Any) {
        play(stringToPlay: speechUtterance)
        playButtonImage.setImage(UIImage(named: "Navigation_Pause_2x"), for: .normal)
        currentState = .playing
        setAvailabiltyForControls()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
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
        currentState = .playing
        speechSynthesizer.speak(stringToPlay)
        setAvailabiltyForControls()
    }
    
    func pause() {
        // Speech synthesizer will pause
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            currentState = .paused
            playButtonImage.setImage(UIImage(named: "Navigation_Play_2x"), for: .normal)
        } else {
            play(stringToPlay: speechUtterance)
            currentState = .playing
        }
    }
    
    func stop() {
        // Speech synthesizer will stop
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.word)
            currentState = .stopped
        }
        
    }
    
    func initialSetup() {
        stop()
        previousButton.isEnabled = false
        nextButton.isEnabled = false
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

}
