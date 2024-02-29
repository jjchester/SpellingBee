//
//  LetterSets.swift
//  Test
//
//  Created by Justin Chester on 2024-02-28.
//

import Foundation

struct LetterSets {
    static let shared = LetterSets()
    
    func RequestSet() throws -> [Character]? {
        do {
            guard let fileURL = Bundle.main.url(forResource: "LetterBank", withExtension: "txt") else {
                throw FetchLettersError.fileNotFound
            }
            var sets: [[Character]] = []
            // Read contents from input file
            let contents = try String(contentsOf: fileURL)
            // Split contents into lines
            let lines = contents.components(separatedBy: .newlines)
            // Process each line
            for line in lines {
                // Extract letters and number from the line
                let components = line.components(separatedBy: ":")
                guard components.count == 2, let letters = components.first else {
                    continue // Skip invalid lines
                }
                sets.append(Array(letters))
            }
            return sets.randomElement()
        }
    }
}
