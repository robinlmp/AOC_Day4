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
        let _ = stepThroughCalledNumbersPart2()
    }
    
    
    func loadFile(fileName: String) -> String? {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: "txt"),
              let contents = try? String(contentsOfFile: filepath) else { return nil }
        return contents
    }
    
    func stepThroughCalledNumbersPart2() -> Int? {
        guard let rawString = loadFile(fileName: "input-4") else {return nil}
        guard let exampleNumbers = separateCalledNumbers(input: rawString) else {return nil}
        //        guard let exampleNumbers = separateCalledNumbers(input: example) else {return nil}
        
        var calledNumbers: [Int] = []
        let rowGrids = numberGridsInRows(input: rawString)
        let columnGrids = makeColumnGrid(numberGridInRows: numberGridsInRows(input: rawString))
        let allGrids = rowGrids + columnGrids
        
    outerLoop: for number in exampleNumbers {
        calledNumbers.append(number)
        let calledNumbersSet: Set = Set(calledNumbers)
        
        var count = 0
        
        for grid in allGrids {
            count += 1
            for rowOrColumn in grid {
                let rowOrColumnSet: Set = Set(rowOrColumn)
                
                if rowOrColumnSet.isSubset(of: calledNumbersSet) {
                    var flatGrid = grid.flatMap { $0 }
                    
                    for num in calledNumbers {
                        if flatGrid.contains(num) {
                            if let index = flatGrid.firstIndex(of: num) {
                                flatGrid.remove(at: index)
                            }
                        }
                    }
                    let total = flatGrid.reduce(0, +)
                    if let lastCalledNumber = calledNumbers.last {
                        let output = total * lastCalledNumber
                        print("output = \(output)")
//                        return total * lastCalledNumber
                    }
//                    break outerLoop
                }
            }
        }
    }
        return nil
    }
    
    
    func stepThroughCalledNumbers() -> Int? {
        guard let rawString = loadFile(fileName: "input-4") else {return nil}
        guard let exampleNumbers = separateCalledNumbers(input: rawString) else {return nil}
        //        guard let exampleNumbers = separateCalledNumbers(input: example) else {return nil}
        
        var calledNumbers: [Int] = []
        let rowGrids = numberGridsInRows(input: rawString)
        let columnGrids = makeColumnGrid(numberGridInRows: numberGridsInRows(input: rawString))
        let allGrids = rowGrids + columnGrids
        
        outerLoop: for number in exampleNumbers {
            calledNumbers.append(number)
            let calledNumbersSet: Set = Set(calledNumbers)

            for grid in allGrids {

                for rowOrColumn in grid {
                    let rowOrColumnSet: Set = Set(rowOrColumn)
                    
                    if rowOrColumnSet.isSubset(of: calledNumbersSet) {
                        var flatGrid = grid.flatMap { $0 }
                        
                        for num in calledNumbers {
                            if flatGrid.contains(num) {
                                if let index = flatGrid.firstIndex(of: num) {
                                    flatGrid.remove(at: index)
                                }
                            }
                        }
                        let total = flatGrid.reduce(0, +)
                        if let lastCalledNumber = calledNumbers.last {
                            return total * lastCalledNumber
                        }
                        break outerLoop
                    }
                }
            }
        }
        return nil
    }
    
    func separateCalledNumbers(input: String) -> [Int]? {
        let stringBlocks = input.components(separatedBy: "\n\n")
        let firstBlock = stringBlocks[0].trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .compactMap(Int.init)
        print("first block (numbers to be called): \(firstBlock)")
        return firstBlock
    }
    
    func numberGridsInRows(input: String) -> [[[Int]]] {
        var intBlocks: [[[Int]]] = []
        var stringBlocks = input.components(separatedBy: "\n\n")
        stringBlocks.remove(at: 0)
        
        for block in stringBlocks {
            var tempBlock: [[Int]] = []
            let rows = block.components(separatedBy: "\n")
            for row in rows {
                if !row.isEmpty {
                    tempBlock.append(row.components(separatedBy: " ").compactMap(Int.init))
                }
            }
            intBlocks.append(tempBlock)
        }
        return intBlocks
    }
    
    
    func makeColumnGrid(numberGridInRows: [[[Int]]]) -> [[[Int]]] {
        var tempGrids: [[[Int]]] = []
        
        for grid in numberGridInRows {
            let numberOfColumns = grid[0].count
            var columns: [[Int]] = []
            
            for i in 0..<numberOfColumns {
                var tempColumn: [Int] = []
                for row in grid {
                    tempColumn.append(row[i])
                }
                columns.append(tempColumn)
            }
            tempGrids.append(columns)
        }
        return tempGrids
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
