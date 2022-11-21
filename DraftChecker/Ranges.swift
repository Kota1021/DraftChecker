//
//  Ranges.swift
//  DraftChecker
//
//  Created by 松本幸太郎 on 2022/11/21.
//

import Foundation
import SwiftUI

extension AttributedString {
    func ranges<T: StringProtocol>(of stringToFind: T) -> [Range<AttributedString.Index>] {
        var ranges: [Range<AttributedString.Index>] = []
        var substring = self[self.startIndex ..< self.endIndex]
        while let range = substring.range(of: stringToFind) {
        ranges.append(range)
            substring = self[range.upperBound...]
    }
        return ranges
    }
}
