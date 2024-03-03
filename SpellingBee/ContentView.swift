import SwiftUI

struct ContentView: View {
    @State private var letters: [Character] = Array(repeating: " ", count: 7)
    @State private var showAlert = false
    @State private var foundWords: [String] = []
    @State private var selectedLetters: String = ""
    @State private var gameHasStarted: Bool = false
    @State private var errorText: String = ""

    private var requiredLetter: Character {
        get {
            return letters[2]
        }
    }
    
    var body: some View {
        // Using this layout allows for the board to animate smoothly into place when the game starts
        let layout = gameHasStarted ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        ZStack {
            layout {
                VStack {
                    gameBoard
                    gameHasStarted ? enteredLetters : nil
                }
                if gameHasStarted {
                    gameScreen
                } else {
                    startScreen
                }
            }
            .padding()
            if !errorText.isEmpty {
                Text(errorText)
                    .background(.black.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // Start Screen
    private var startScreen: some View {
        ZStack {
            VStack {
                welcomeText
                playButton
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Could not retrieve a set of letters."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var gameBoard: some View {
        LetterButtonGrid(selectedLetters: $selectedLetters, letters: letters)
    }
    
    private var welcomeText: some View {
        Text("""
            Find as many words as you can.
            You must use the center letter.
            You can use letters multiple times.
            """)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
    }
    
    private var playButton: some View {
        Button(action: startGame) {
            Text("Play")
                .foregroundColor(.black)
        }
        .buttonStyle(.borderedProminent)
        .tint(.yellow)
    }
    
    // Game Screen
    private var gameScreen: some View {
        HStack {
            if gameHasStarted {
                submissionButtons
                FoundWordsList(foundWords: $foundWords)
            }
        }
    }
    
    private var enteredLetters: some View {
        Text(selectedLetters)
            .font(.title3)
            .padding()
            .frame(minWidth: 60)
            .frame(height: 60)
            .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.black.opacity(0.5)))
            .lineLimit(1)
    }
    
    private var submissionButtons: some View {
        VStack {
            Button(action: submitWord) {
                Text("Submit")
            }
            Button(action: deleteLastLetter) {
                Text("Delete")
            }
        }
    }
    
    // Actions
    private func startGame() {
        do {
            try withAnimation {
                letters = try LetterSets.shared.RequestSet() ?? []
                gameHasStarted = true
            }
        } catch {
            showAlert = true
        }
    }
    
    private func submitWord() {
        var err: String = ""
        if (!DictionaryWords.shared.exists(selectedLetters)) {
            err += "Not a valid word"
        }
        if (!selectedLetters.contains(requiredLetter)) {
            err += "Word must contain \"\(requiredLetter)\""
        }
        if (foundWords.contains(selectedLetters)) {
            err += "You have already guessed this word"
        }
        if err.isEmpty {
            withAnimation(.none) {
                foundWords.append(selectedLetters)
            }
            selectedLetters = ""
        } else {
            withAnimation(.easeInOut) {
                errorText = err
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    errorText = ""
                })
            }
        }
    }
    
    private func isValidWord(word: String) -> Bool {
        return DictionaryWords.shared.exists(word) && word.contains(requiredLetter) && !foundWords.contains(word)
    }
    
    private func deleteLastLetter() {
        withAnimation {
            guard !selectedLetters.isEmpty else { return }
            selectedLetters.removeLast()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
