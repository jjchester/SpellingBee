//
//  PermutationGenerator.swift
//  Test
//
//  Created by Justin Chester on 2024-02-28.
//
/**
 This stuff only ever gets used for generating new words. Will probably move these to a web service eventually but just needed an initial word list.
 */

import Foundation

struct WordGenerator {
    
    static let shared = WordGenerator()

    func generateAndCheckPermutations() {
        var successfulWordsCount: [String: Int] = [:]
        
        for _ in 1...20000 {
            let generatedCharacters = LetterGenerator.shared.generate()
            let characterSet = Set(generatedCharacters)

            // Generate permutations including duplicate letters up to 13 characters
            for length in 2...12 {
                let permutations = Array(characterSet).permutations(length: length)

                // Check if each permutation exists in the dictionary words
                for permutation in permutations {
                    let permutationString = String(permutation)
                    if permutationString.contains(generatedCharacters[2]) && DictionaryWords.shared.exists(permutationString) {
                        // Increment the count of successful words for the associated 7-letter group
                        let sevenLetterGroup = String(generatedCharacters.prefix(7))
                        successfulWordsCount[sevenLetterGroup, default: 0] += 1
                    }
                }
            }
        }
        
        // Sort the results by highest count of successful letters
        let sortedResults = successfulWordsCount.sorted { $0.value > $1.value }
        
        // Output the results to a file
        let filePath = "/Users/justin/Desktop/results.txt"
        do {
            let outputString = sortedResults.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
            try outputString.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Results written to \(filePath)")
        } catch {
            print("Error writing to file:", error.localizedDescription)
        }
    }
    
    func getValidWordsFromSet(set: [Character]) {
        var results: [Int: [String]] = [:]
        for length in 2...9 {
            let permutations = ["\(set[0])","\(set[1])","\(set[2])","\(set[3])","\(set[4])","\(set[5])","\(set[6])"].permutations(length: length, allowRepeats: true)

            // Check if each permutation exists in the dictionary words
            for permutation in permutations {
                let permutationString = String(permutation.joined())
                if permutationString.contains(set[2]) && DictionaryWords.shared.exists(permutationString) {
                    // Increment the count of successful words for the associated 7-letter group
                    if results[length] != nil {
                        results[length]?.append(permutationString)
                    } else {
                        results[length] = [permutationString]
                    }
                }
            }
        }
        for key in results.keys.sorted() {
            print("Words for length \(key)")
            for str in results[key]! {
                print(str)
            }
        }
    }

    private func generatePermutations<T>(ofLength length: Int, from elements: [T]) -> [[T]] {
        guard length <= elements.count else { return [] }
        if length == 0 { return [[]] }
        if length == 1 { return elements.map { [$0] } }

        var permutations: [[T]] = []
        for (index, element) in elements.enumerated() {
            var remainingElements = elements
            remainingElements.remove(at: index)
            let subPermutations = generatePermutations(ofLength: length - 1, from: remainingElements)
            permutations += subPermutations.map { [element] + $0 }
        }
        return permutations
    }
}

