import Foundation
import AVFoundation
import UIKit

enum State {
    case playing
    case paused
    case stopped
}

import UIKit
import PlaygroundSupport

let text = "This is\n some placeholder\n text\nwith newlines."
let textView = UITextView(frame: CGRect(x: 0, y:0, width: 200, height: 100))
textView.backgroundColor = .white
textView.text = text

let textStorage = textView.textStorage

// Use NSString here because textStorage expects the kind of ranges returned by NSString,
// not the kind of ranges returned by String.
let storageString = textStorage.string as NSString
var lineRanges = [NSRange]()
storageString.enumerateSubstrings(in: NSMakeRange(0, storageString.length), options: .byLines, using: { (_, lineRange, _, _) in
    lineRanges.append(lineRange)
})

func setBackgroundColor(_ color: UIColor?, forLine line: Int) {
    if let color = color {
        textStorage.addAttribute(.backgroundColor, value: color, range: lineRanges[line])
    } else {
        textStorage.removeAttribute(.backgroundColor, range: lineRanges[line])
    }
}
//
//func scheduleHighlighting(ofLine line: Int) {
//    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//        if line > 0 { setBackgroundColor(nil, forLine: line - 1) }
//        guard line < lineRanges.count else { return }
//        setBackgroundColor(.yellow, forLine: line)
//        scheduleHighlighting(ofLine: line + 1)
//    }
//}

setBackgroundColor(.red, forLine: 1)

//let quote = "The annotations capture insights by the student’s teacher, using the features of quality, with a view to establishing the level of achievement the text reflects. The purpose of the annotations is to make the teacher's thinking visible. The annotations were confirmed by the Quality Assurance group, consisting of practicing English teachers and representatives of the Inspectorate, the SEC and JCT. "

//let tagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
//let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
//
//func determineLanguage(for text: String) {
//    tagger.string = text
//    let language = tagger.dominantLanguage
//    print("The language is \(language!)")
//}
//
//func tokenizeText(for text: String) {
//    tagger.string = text
//    let range = NSRange(location: 0, length: text.utf16.count)
//    tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _, tokenRange, _ in
//        let word = (text as NSString).substring(with: tokenRange)
//        print(word)
//    }
//}
//
//func lemmatization(for text: String) {
//    tagger.string = text
//    let range = NSRange(location: 0, length: text.utf16.count)
//    tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, _, _ in
//        if let lemma = tag?.rawValue {
//            print(lemma)
//        }
//    }
//}
//
//func partsOfSpeech(for text: String) {
//    tagger.string = text
//    let range = NSRange(location: 0, length: text.utf16.count)
//    tagger.enumerateTags(in: range, unit: .sentence, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
//        if let tag = tag {
//            let word = (text as NSString).substring(with: tokenRange)
//            print("\(word): \(tag.rawValue)")
//        }
//    }
//}
//
//func namedEntityRecognition(for text: String) {
//    tagger.string = text
//    let range = NSRange(location: 0, length: text.utf16.count)
//    let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
//    tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, _ in
//        if let tag = tag, tags.contains(tag) {
//            let name = (text as NSString).substring(with: tokenRange)
//            print("\(name): \(tag.rawValue)")
//        }
//    }
//}
//
//determineLanguage(for: quote)
//tokenizeText(for: quote)
//lemmatization(for: quote)
//partsOfSpeech(for: quote)
//namedEntityRecognition(for: quote)




