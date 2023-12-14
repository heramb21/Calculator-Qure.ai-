//
//  HistoryButtonViewConverter.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 14/12/23.
//

import Foundation

// Utility class for converting between history button view options
class HistoryButtonViewConverter {
    static func getViewFromIndex(index: Int) -> String {
        switch index {
        case 0:
            return "Icon Image"
        case 1:
            return "Text Label"
        case 2:
            return "Off"
        default:
            return "Icon Image"
        }
    }
}
