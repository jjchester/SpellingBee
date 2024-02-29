//
//  LetterButtonGrid.swift
//  Test
//
//  Created by Justin Chester on 2024-02-28.
//

import SwiftUI
import HexGrid

struct HexCell: Identifiable, OffsetCoordinateProviding {
    var id: Int { offsetCoordinate.hashValue }
    var offsetCoordinate: OffsetCoordinate
    var index: Int
}

struct LetterButtonGrid: View {
    
    @Binding var selectedLetters: String
    
    let cells: [HexCell] = [
        .init(offsetCoordinate: .init(row: 0, col: 1), index: 0),
        .init(offsetCoordinate: .init(row: 1, col: 0), index: 1),
        .init(offsetCoordinate: .init(row: 1, col: 1), index: 2),
        .init(offsetCoordinate: .init(row: 1, col: 2), index: 3),
        .init(offsetCoordinate: .init(row: 2, col: 0), index: 4),
        .init(offsetCoordinate: .init(row: 2, col: 1), index: 5),
        .init(offsetCoordinate: .init(row: 2, col: 2), index: 6),
    ]
    let letters: [Character]

    var body: some View {
        HexGrid(cells) { cell in
            LetterButton(letter: self.letters[cell.index], color: cell.index == 2 ? Color("darkYellow") : .gray, selectedLetters: $selectedLetters)
                .padding(6)
        }
        .padding()
    }
}
