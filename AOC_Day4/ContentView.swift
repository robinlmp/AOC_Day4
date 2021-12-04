//
//  ContentView.swift
//  AOC_Day4
//
//  Created by Robin Phillips on 04/12/2021.
//

import SwiftUI

let example = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""



struct ContentView: View {
    var calledNumbers:[Int] = []
    var numberCards:[[Int]] = []
    var numberOfCards: Int = 0
    
    
    var body: some View {
        Text("Hello, world!")
            .padding()
        let _ = print(numberGrids(input: example)[0])
    }
    
    func separateCalledNumbers(input: String) -> [Int]? {
        let stringBlocks = input.components(separatedBy: "\n\n")
        return stringBlocks[0].trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .compactMap(Int.init)
    }
    
    func numberGrids(input: String) -> [[[Int]]] {
        var intBlocks: [[[Int]]] = []
        var stringBlocks = input.components(separatedBy: "\n\n")
        stringBlocks.remove(at: 0)

        for block in stringBlocks {
            var tempBlock: [[Int]] = []
            let rows = block.components(separatedBy: "\n")
            for row in rows {
                tempBlock.append(row.components(separatedBy: " ").compactMap(Int.init))
            }
            let tempColumns = makeColumns(numberGrid: tempBlock)
            tempBlock += tempColumns
            intBlocks.append(tempBlock)
        }
        return intBlocks
    }
    
    func makeColumns(numberGrid: [[Int]]) -> [[Int]] {
        let numberOfColumns = numberGrid[0].count
        var columns: [[Int]] = []
        
        for i in 0..<numberOfColumns {
            var tempColumn: [Int] = []
            for row in numberGrid {
                tempColumn.append(row[i])
            }
            columns.append(tempColumn)
        }
        return columns
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
