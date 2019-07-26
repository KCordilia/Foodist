//
//  SpeechViewController.swift
//  Foodist
//
//  Created by Karim Cordilia on 19/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SwiftSiriWaveformView

protocol Speakable: class {
    func setUpTextToSpeak(_ text: String)
}

enum PlayerState {
    case playing
    case paused
    case stopped
}

class SpeechViewController: UIViewController {
    @IBOutlet weak var playAndPauseButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var siriWaveForm: SwiftSiriWaveformView!
    let speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance?
    var recipeInstructions: [String] = []
    var currentState: PlayerState = .stopped
    var currentIndex = 0
    var sourceVC: RecipeDetailViewController?
    var spokenTextLengths = 0
    var currentUtterance = 0
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var timer: Timer?
    var change: CGFloat = 0.01

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        playAndPauseButton.isEnabled = false
        speechSynthesizer.delegate = self
        siriWaveForm.isHidden = true

        self.siriWaveForm.density = 1.0

        timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(SpeechViewController.refreshAudioView(_:)), userInfo: nil, repeats: true)
    }

    @IBAction func previous(_ sender: Any) {
        previous()
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
        next()
    }

    @IBAction func enableVoiceControl(_ sender: Any) {
        recordAndRecognizeSpeech()
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
            playAndPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            speechSynthesizer.speak(speechUtterance)
        } else if currentState == .paused {
            speechSynthesizer.continueSpeaking()
            playAndPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            currentState = .playing
        } else {
            speechSynthesizer.speak(speechUtterance)
        }
    }

    func pause() {
        currentState = .paused
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            playAndPauseButton.setImage(UIImage(named: "Play"), for: .normal)
        } else {
            play(stringToPlay: recipeInstructions[currentIndex])
            currentState = .playing
        }
    }

    func stop() {
        currentState = .stopped
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.word)
            playAndPauseButton.setImage(UIImage(named: "Play"), for: .normal)
            disableAVSession()
            setAvailabiltyForControls()
        }
        stopRecognition()
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

    func previous() {
        currentIndex -= 1
        if currentIndex == 0 {
            previousButton.isEnabled = false
            stopRecognition()
        }

        if currentIndex <= recipeInstructions.count + 1 {
            stop()
            play(stringToPlay: recipeInstructions[currentIndex])
            stopRecognition()
        }
    }

    func next() {
        currentIndex += 1
        if currentIndex <= recipeInstructions.count - 1 {
            stop()
            play(stringToPlay: recipeInstructions[currentIndex])
        }
        if currentIndex == recipeInstructions.count - 1 {
            nextButton.isEnabled = false
        }
        stopRecognition()
    }

    func recordAndRecognizeSpeech() {
        siriWaveForm.isHidden = false
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }

        guard
            let myRecognizer = SFSpeechRecognizer()
            else { return }
        if !myRecognizer.isAvailable {
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString.lowercased()

                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                self.voiceCommand(resultString: lastString)

            } else if let error = error {
                print(error)
            }
        })
    }
    func voiceCommand(resultString: String) {
        switch resultString {
        case "next":
            next()
        case "previous":
            previous()
        default:
            break
        }
    }

    func stopRecognition() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
        audioEngine.inputNode.removeTap(onBus: 0)
        siriWaveForm.isHidden = true
    }

    @objc internal func refreshAudioView(_:Timer) {
        if self.siriWaveForm.amplitude <= self.siriWaveForm.idleAmplitude || self.siriWaveForm.amplitude > 1.0 {
            self.change *= -1.0
        }

        // Simply set the amplitude to whatever you need and the view will update itself.
        self.siriWaveForm.amplitude += self.change
    }
}

extension SpeechViewController: Speakable {
    func setUpTextToSpeak(_ text: String) {
        recipeInstructions.append(text)
        playAndPauseButton.isEnabled = true
    }
}

extension SpeechViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        sourceVC?.highlightText(range: characterRange, indexPath: IndexPath(row: currentIndex, section: 1))
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        recordAndRecognizeSpeech()
        playAndPauseButton.setImage(UIImage(named: "Play"), for: .normal)
        siriWaveForm.isHidden = false
    }
}
