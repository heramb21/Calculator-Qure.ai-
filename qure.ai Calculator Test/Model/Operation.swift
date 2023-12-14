//
//  Operation.swift
//  qure.ai Calculator Test
//
//  Created by Heramb on 14/12/23.
//

import Foundation

// Used by all calculators
// Defines set of possible operations
enum Operation: String {
    case Add = "+"
    case Subtract = "-"
    case Divide = "÷"
    case Multiply = "×"
    case Modulus = "%"
    case Exp = "^"
    case AND = "&"
    case OR = "|"
    case XOR = "⊕"
    case LeftShift = "<<"
    case RightShift = ">>"
    case Not = "!"
    case Sqrt = "√"
    case NULL = "Empty"
}
