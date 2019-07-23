import Foundation
import AVFoundation
import UIKit

enum State {
    case playing
    case paused
    case stopped
}

//let quote = "The annotations capture insights by the student’s teacher, using the features of quality, with a view to establishing the level of achievement the text reflects. The purpose of the annotations is to make the teacher's thinking visible. The annotations were confirmed by the Quality Assurance group, consisting of practicing English teachers and representatives of the Inspectorate, the SEC and JCT. "

let tagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]

func determineLanguage(for text: String) {
    tagger.string = text
    let language = tagger.dominantLanguage
    print("The language is \(language!)")
}

func tokenizeText(for text: String) {
    tagger.string = text
    let range = NSRange(location: 0, length: text.utf16.count)
    tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _, tokenRange, _ in
        let word = (text as NSString).substring(with: tokenRange)
        print(word)
    }
}

func lemmatization(for text: String) {
    tagger.string = text
    let range = NSRange(location: 0, length: text.utf16.count)
    tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, _, _ in
        if let lemma = tag?.rawValue {
            print(lemma)
        }
    }
}

func partsOfSpeech(for text: String) {
    tagger.string = text
    let range = NSRange(location: 0, length: text.utf16.count)
    tagger.enumerateTags(in: range, unit: .sentence, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
        if let tag = tag {
            let word = (text as NSString).substring(with: tokenRange)
            print("\(word): \(tag.rawValue)")
        }
    }
}

func namedEntityRecognition(for text: String) {
    tagger.string = text
    let range = NSRange(location: 0, length: text.utf16.count)
    let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
    tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, _ in
        if let tag = tag, tags.contains(tag) {
            let name = (text as NSString).substring(with: tokenRange)
            print("\(name): \(tag.rawValue)")
        }
    }
}
//
//determineLanguage(for: quote)
//tokenizeText(for: quote)
//lemmatization(for: quote)
partsOfSpeech(for: quote)
//namedEntityRecognition(for: quote)


