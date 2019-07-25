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
    var sourceVC: RecipeDetailViewController?
    var spokenTextLengths = 0
    var currentUtterance = 0
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?

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
            playButtonImage.setImage(UIImage(named: "Navigation_Pause_2x"), for: .normal)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
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

    func next() {
        currentIndex += 1
        if currentIndex <= recipeInstructions.count - 1 {
            stop()
            play(stringToPlay: recipeInstructions[currentIndex])
        }
        if currentIndex == recipeInstructions.count - 1 {
            nextButton.isEnabled = false
        }
    }

    func recordAndRecognizeSpeech() {
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
                let bestString = result.bestTranscription.formattedString

                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                DispatchQueue.main.async {
                    self.voiceNextLine(resultString: lastString)
                }

            } else if let error = error {
                print(error)
            }
        })
    }
    func voiceNextLine(resultString: String) {
        if resultString == "next" {
            next()
            print(resultString)
        }
    }
}

extension SpeechViewController: Speakable {
    func setUpTextToSpeak(_ text: String) {
        recipeInstructions.append(text)
        playButtonImage.isEnabled = true
    }
}

extension SpeechViewController: AVSpeechSynthesizerDelegate {
   /* func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        // Determine the current range in the whole text (all utterances), not just the current one.
        let rangeInTotalText = NSMakeRange(spokenTextLengths + characterRange.location, characterRange.length)

        // Select the specified range in the textfield.
        tvEditor.selectedRange = rangeInTotalText

        // Store temporarily the current font attribute of the selected text.
        let currentAttributes = tvEditor.attributedText.attributes(at: rangeInTotalText.location, effectiveRange: nil)
        let fontAttribute: AnyObject? = currentAttributes[NSAttributedString.Key.font] as AnyObject?

        // Assign the selected text to a mutable attributed string.
        let attributedString = NSMutableAttributedString(string: tvEditor.attributedText.attributedSubstring(from: rangeInTotalText).string)

        // Make the text of the selected area orange by specifying a new attribute.
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSMakeRange(0, attributedString.length))

        // Make sure that the text will keep the original font by setting it as an attribute.
        attributedString.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributedString.string.utf16.count))

        // In case the selected word is not visible scroll a bit to fix this.
        tvEditor.scrollRangeToVisible(rangeInTotalText)

        // Begin editing the text storage.
        tvEditor.textStorage.beginEditing()

        // Replace the selected text with the new one having the orange color attribute.
        tvEditor.textStorage.replaceCharacters(in: rangeInTotalText, with: attributedString)


        let indexPath = IndexPath(row: 0, section: 1)
        sourceVC?.highlightWord(recipeInstructions[currentIndex], indexPath: indexPath)
    }*/

  /*  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        spokenTextLengths = spokenTextLengths + utterance.speechString.utf16.count + 1
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        currentUtterance = currentUtterance + 1
    }*/
}
