//
//  FileReader.swift
//  Test
//
//  Created by Justin Chester on 2024-02-28.
//

import Foundation

struct DictionaryWords {
    private var words: [String] = []
    static let shared = DictionaryWords()
    
    init() {
        words = readTextFile(filename: "words_alpha") ?? []
    }
    
    private func readTextFile(filename: String) -> [String]? {
        // Get the URL for the file
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") else {
            print("File not found.")
            return nil
        }
        
        do {
            // Read the contents of the file into a string
            let fileContents = try String(contentsOf: fileURL)
            
            // Split the string by newline characters to create an array of lines
            let lines = fileContents.components(separatedBy: .newlines)
            
            // Remove any empty lines
            let nonEmptyLines = lines.filter { !$0.isEmpty }
            
            return nonEmptyLines
        } catch {
            print("Error reading file:", error)
            return nil
        }
    }
    
    // Binary search as word list is sorted
    func exists(target: String) -> Bool {
        let target = target.lowercased()
        var left = 0
        var right = words.count - 1
        
        while left <= right {
            let mid = left + (right - left) / 2
            if words[mid] == target {
                return true // Element found
            } else if words[mid] < target {
                left = mid + 1 // Search in the right half
            } else {
                right = mid - 1 // Search in the left half
            }
        }
        
        return false // Element not found
    }
}
