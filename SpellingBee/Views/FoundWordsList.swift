//
//  FoundWordsList.swift
//  Test
//
//  Created by Justin Chester on 2024-02-28.
//

import SwiftUI

struct FoundWordsList: View {
    @Binding var foundWords: [String]
    
    var body: some View {
        VStack {
            Text("Found Words")
                .font(.extraLargeTitle)
            ScrollView {
                ForEach(foundWords, id: \.self) { word in
                    Text(word)
                        .font(.title3)
                        .transition(.opacity.animation(.linear))
                        .id(word)
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
}
