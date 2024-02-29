//
//  ContentView.swift
//  Test
//
//  Created by Justin Chester on 2024-02-17.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var letters: [Character] = []
    @State private var showAlert = false
    @State private var foundWords: [String] = []
    @State private var rectangleOpacity: Double = 0.6 // Add a state for the opacity
    @State private var selectedLetters: String = ""
    
    @State private var selectedLettersShouldShow: Bool = false
    @State private var submitAndDeleteShouldShow: Bool = false
    

    var body: some View {
        ZStack {
            if self.letters.count > 0 {
                HStack {
                    VStack {
                        LetterButtonGrid(selectedLetters: $selectedLetters, letters: self.letters)
                            .padding()
                        if (selectedLetters.count > 0 || selectedLettersShouldShow) {
                            Text(selectedLetters)
                                .font(.title3)
                                .padding()
                                .frame(minWidth: 60)
                                .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.black.opacity(0.5)))
                                .lineLimit(1)
                                .onAppear() {
                                    selectedLettersShouldShow = true
                                }
                        }
                    }
                    if (selectedLetters.count > 0) {
                        VStack {
                            Button {
                                if DictionaryWords.shared.exists(target: selectedLetters) {
                                    withAnimation {
                                        foundWords.append(selectedLetters)
                                        selectedLetters = ""
                                    }
                                }
                            } label: {
                                Text("submit")
                            }
                            Button {
                                withAnimation {
                                    guard selectedLetters.count > 0 else {
                                        return
                                    }
                                    _ = selectedLetters.removeLast()
                                }
                            } label: {
                                Text("Delete")
                            }
                        }

                    }
                    if foundWords.count > 0 {
                        FoundWordsList(foundWords: $foundWords)
                    }
                }
            } else {
                LetterButtonGrid(selectedLetters: $selectedLetters, letters: Array.init(repeating: ".", count: 7))
                    .padding(32)
                VStack {
                    Text("""
                        Find as many words as you can.
                        You must use the center letter.
                        You can use letters multiple times.
                        """)

                    .multilineTextAlignment(.center)
                    Button {
                        do {
                            try withAnimation {
                                rectangleOpacity = 0
                                letters = try LetterSets.shared.RequestSet() ?? []
                            }
                        } catch {
                            showAlert = true
                        }
                    } label: {
                        Text("Play")
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                }
                .padding()
                .background(.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .zIndex(2)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Could not retrieve a set of letters."), dismissButton: .default(Text("OK")))
                }
            }
            RoundedRectangle(cornerRadius: 20.0)
                .fill(.black)
                .opacity(rectangleOpacity)
                .shadow(radius: 10.0)
                .padding()
                
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
