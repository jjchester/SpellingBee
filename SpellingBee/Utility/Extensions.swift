//
//  Extensions.swift
//  SpellingBee
//
//  Created by Justin Chester on 2024-02-29.
//

import Foundation

extension Array where Element: Hashable {
    func permutations(length: Int, allowRepeats: Bool = false) -> [[Element]] {
        var results: [[Element]] = []
        
        func backtrack(path: [Element]) {
            if path.count == length {
                results.append(path)
                return
            }
            
            for element in self {
                if !allowRepeats && path.contains(element) {
                    continue
                }
                var newPath = path
                newPath.append(element)
                backtrack(path: newPath)
            }
        }
        
        backtrack(path: [])
        return results
    }
}
