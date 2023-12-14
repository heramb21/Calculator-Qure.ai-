//
//  CopyOrPasteActionConverter.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 14/12/23.
//

import Foundation

// Utility class for converting between copy/paste actions and indexes
class CopyOrPasteActionConverter {
    static func getActionFromIndex(index: Int, paste: Bool) -> String {
        switch index {
        case 0:
            return "Single Tap"
        case 1:
            return "Double Tap"
        case 2:
            return "Off"
        default:
            return paste ? "Double Tap" : "Single Tap"
        }
    }
}
