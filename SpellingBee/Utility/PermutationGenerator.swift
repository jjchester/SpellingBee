//
//  PermutationGenerator.swift
//  Test
//
//  Created by Justin Chester on 2024-02-28.
//

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
                    if permutationString.contains(generatedCharacters[2]) && DictionaryWords.shared.exists(target: permutationString) {
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
        for length in 2...6 {
            let permutations = ["\(set[0])","\(set[1])","\(set[2])","\(set[3])","\(set[4])","\(set[5])","\(set[6])"].permutations(length: length, allowRepeats: true)

            // Check if each permutation exists in the dictionary words
            for permutation in permutations {
                let permutationString = String(permutation.joined())
                if permutationString.contains(set[2]) && DictionaryWords.shared.exists(target: permutationString) {
                    // Increment the count of successful words for the associated 7-letter group
                    if results[length] != nil {
                        results[length]?.append(permutationString)
                    } else {
                        results[length] = [permutationString]
                    }
                }
            }
        }
        var count = 0
        for key in results.keys.sorted() {
            print("Words for length \(key)")
            for str in results[key]! {
                print(str)
                count += results[key]!.count / key
            }
        }
        print("Total words: \(count)")
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
    
    func removeDuplicateCombinations() {
        do {
            let inputFilePath = "/Users/justin/Desktop/results.txt"
            let outputFilePath = "/Users/justin/Desktop/filtered.txt"
            // Read contents from input file
            let contents = try String(contentsOfFile: inputFilePath, encoding: .utf8)
            
            // Split contents into lines
            let lines = contents.components(separatedBy: .newlines)
            
            // Create a set to store unique combinations
            var uniqueCombinations: [String: (String, Int)] = [:]
            
            // Process each line
            for line in lines {
                // Extract letters and number from the line
                let components = line.components(separatedBy: ":")
                guard components.count == 2, let letters = components.first, let numberString = components.last else {
                    continue // Skip invalid lines
                }
                
                // Extract number
                guard let number = Int(numberString.trimmingCharacters(in: .whitespaces)) else {
                    continue // Skip invalid numbers
                }
                let sorted = String(letters.sorted())
                if let _ = uniqueCombinations[sorted] {
                    uniqueCombinations[sorted] = (uniqueCombinations[sorted]!.0, uniqueCombinations[sorted]!.1)
                } else {
                    uniqueCombinations[sorted] = (letters, number)
                }
            }
            
            let sorted = uniqueCombinations.values.sorted() { $1.1 < $0.1 }
            // Write unique combinations to output file
            let outputContent = sorted.map { (letters, num) in
                "\(letters): \(num)"
            }.joined(separator: "\n")
            
            try outputContent.write(toFile: outputFilePath, atomically: true, encoding: .utf8)
            
            print("Unique combinations written to \(outputFilePath)")
        } catch {
            print("Error:", error.localizedDescription)
        }
    }
}

