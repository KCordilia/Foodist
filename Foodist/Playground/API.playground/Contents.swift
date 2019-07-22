import Foundation
import AVFoundation

enum State {
    case playing
    case paused
    case stopped
}

func initialSetup() {
    stop()
}

func play(stringToPlay: AVSpeechUtterance, index: Int) {
    currentState = .playing
    // Speech synthesizer will play
    // play button image should change to pause image
    speechSynthesizer.speak(stringToPlay)
}

func pause() {
    currentState = .paused
    // Speech synthesizer will pause
    // pause button image should change to play image
}

func stop() {
    currentState = .stopped
    // Speech synthesizer will stop
    // previous and next buttons are disabled
}

var currentState: State = .stopped
let speechSynthesizer = AVSpeechSynthesizer()
let speechUtterance = AVSpeechUtterance(string: "This is a test. This is only a test. If this was an actual emergency, then this wouldn’t have been a test.")
speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
play(stringToPlay: speechUtterance, index: 0)




