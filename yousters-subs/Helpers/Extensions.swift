//
//  Extensions.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 12.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation
import UIKit

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}


extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
    
    func emojiHash() -> String {
        // HashEmoji.txt is a line separated file of 256 emojis (1 per byte)
        guard let path = Bundle.main.path(forResource: "HashEmoji", ofType: "txt"),
            let emojiData = try? String(contentsOfFile: path, encoding: .utf8)
            else {
                return self
        }
        
        let emojis = emojiData.components(separatedBy: .newlines)
        
        var str = ""

        let length = Int(self.count / 4)
        let arr = self.split(by: length).map({String($0).data(using: .utf8)!})
        
        for elem in arr {
            var sum = 0
            for letter in elem {
                sum += Int(letter)
            }
            str.append(emojis[sum % 256])
        }
        
        return str
    }
}

extension URL {
    func absoluteStringByTrimmingQuery() -> String? {
        if var urlcomponents = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            urlcomponents.query = nil
            return urlcomponents.string
        }
        return nil
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
