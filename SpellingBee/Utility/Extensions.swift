//
//  Extensions.swift
//  SpellingBee
//
//  Created by Justin Chester on 2024-02-29.
//

import Foundation

extension Array where Element: StringProtocol {

    /// Return combinations of the elements of the array (ignoring the order of items in those combinations).
    ///
    /// - Parameters:
    ///   - size: The size of the combinations to be returned.
    ///   - allowDuplicates: Boolean indicating whether an item in the array can be repeated in the combinations (e.g. is the sampled item returned to the original set or not).
    ///
    /// - Returns: A collection of resulting combinations.

    func combinations(size: Int, allowDuplicates: Bool = false) -> [String] {
        let n = count

        if size > n && !allowDuplicates { return [] }

        var combinations: [String] = []

        var indices = [0]

        var i = 0

        while true {
            // build out array of indexes (if not complete)

            while indices.count < size {
                i = indices.last! + (allowDuplicates ? 0 : 1)
                if i < n {
                    indices.append(i)
                }
            }

            // add combination associated with this particular array of indices

            combinations.append(indices.map { self[$0] }.joined())

            // prepare next one (incrementing the last component and/or deleting as needed

            repeat {
                if indices.count == 0 { return combinations }
                i = indices.last! + 1
                indices.removeLast()
            } while i > n - (allowDuplicates ? 1 : (size - indices.count))
            indices.append(i)
        }
    }
}

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
