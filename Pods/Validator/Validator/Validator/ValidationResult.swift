/*

 ValidationResult.swift
 Validator

 Created by @adamwaite.

 Copyright (c) 2015 Adam Waite. All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

*/

import Foundation

public enum ValidationResult {
    
    case valid
    case invalid([ValidationErrorType])

    public var isValid: Bool { return self == .valid }

    public func merge(_ result: ValidationResult) -> ValidationResult {
        switch self {
        case .valid: return result
        case .invalid(let errorMessages):
            switch result {
            case .valid: return self
            case .invalid(let errorMessagesAnother): return .invalid([errorMessages, errorMessagesAnother].flatMap { $0 })
            }
        }
    }
    
    public func mergeWithMany(_ results: [ValidationResult]) -> ValidationResult {
        return results.reduce(self) { return $0.merge($1) }
    }
    
    public static func combine(_ results: [ValidationResult]) -> ValidationResult {
        return ValidationResult.valid.mergeWithMany(results)
    }
}

extension ValidationResult: Equatable {}
public func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.valid, .valid): return true
    case (.invalid(_), .invalid(_)): return true
    default: return false
    }
}
