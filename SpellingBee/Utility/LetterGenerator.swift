import Foundation

class LetterGenerator {
    
    static let shared = LetterGenerator()
    
    private init() {}
    
    func generate() -> [Character] {
        // Define the frequency of each letter in the English language
        let letterFrequency: [Character: Int] = [
            "A": 8167, "B": 1492, "C": 2782, "D": 4253, "E": 12702,
            "F": 2228, "G": 2015, "H": 6094, "I": 6966, "J": 153,
            "K": 772, "L": 4025, "M": 2406, "N": 6749, "O": 7507,
            "P": 1929, "Q": 95, "R": 5987, "S": 6327, "T": 9056,
            "U": 2758, "V": 978, "W": 2360, "X": 150, "Y": 1974, "Z": 74
        ]
        
        // Convert frequency dictionary to an array of tuples and capitalize the letters
        var sortedLetters = letterFrequency.map { ($0.key.uppercased().first!, $0.value) }.sorted { $0.1 > $1.1 }
        
        // Create an array to store the selected letters
        var selectedLetters: [Character] = []
        
        // Select the center letter based on weighted randomness
        var totalFrequency = sortedLetters.map { $0.1 }.reduce(0, +)
        let centerRandomNumber = Int.random(in: 1...totalFrequency)
        var cumulativeFrequency = 0
        var centerLetter: Character = " "
        for (letter, frequency) in sortedLetters {
            cumulativeFrequency += frequency
            if cumulativeFrequency >= centerRandomNumber {
                centerLetter = letter
                break
            }
        }
        
        // Remove the center letter from the list of available letters
        if let centerIndex = sortedLetters.firstIndex(where: { $0.0 == centerLetter }) {
            sortedLetters.remove(at: centerIndex)
        }
        
        // Select the remaining 6 letters based on their frequencies
        for _ in 0..<6 {
            let randomNumber = Int.random(in: 1...totalFrequency)
            var cumulativeFrequency = 0
            var selectedIndex = 0
            for (index, (_, frequency)) in sortedLetters.enumerated() {
                cumulativeFrequency += frequency
                if cumulativeFrequency >= randomNumber {
                    selectedIndex = index
                    break
                }
            }
            let selectedLetter = sortedLetters[selectedIndex].0 // Selected letter
            selectedLetters.append(selectedLetter)
            totalFrequency -= sortedLetters[selectedIndex].1 // Update total frequency
            sortedLetters.remove(at: selectedIndex) // Remove the selected letter
        }
        
        // Insert the center letter at the 3rd position
        selectedLetters.insert(centerLetter, at: 2)
        
        return selectedLetters
    }
}
