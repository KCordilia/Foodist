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

    override func viewDidLoad() {
        super.viewDidLoad()

        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "This is a test. This is only a test. If this was an actual emergency, then this wouldn’t have been a test.")
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 3.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }

}
