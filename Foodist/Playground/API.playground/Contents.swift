//import Foundation
import AVFoundation

enum State {
    case playing
    case paused
    case stopped
}

let speechSynthesizer = AVSpeechSynthesizer()
let speechUtterance = AVSpeechUtterance(string: "This is a test. and now it will pause god knows where. Help me!")
speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")

func play(stringToPlay: AVSpeechUtterance, index: Int) {
    currentState = .playing
    // play button image should change to pause image
    speechSynthesizer.speak(stringToPlay)
}

func pause() {
    // Speech synthesizer will pause
    if speechSynthesizer.isSpeaking {
        speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        currentState = .paused
    } else {
        play(stringToPlay: speechUtterance, index: 0)
        currentState = .playing
    }
    // pause button image should change to play image
}

func stop() {
    // Speech synthesizer will stop
    if speechSynthesizer.isSpeaking {
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.word)
        currentState = .stopped
    }
    // previous and next buttons are disabled
}

func initialSetup() {
    stop()
}

var currentState: State = .stopped

play(stringToPlay: speechUtterance, index: 0)
print(currentState)
