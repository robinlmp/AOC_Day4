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

struct Grid {
    let rows: [Set<Int>] = []
    let columns: [Set<Int>] = []

    var hasWon = false
}



struct ContentView: View {
    var calledNumbers:[Int] = []
    var numberCards:[[Int]] = []
    var numberOfCards: Int = 0
    
    
    var body: some View {
        Text("Hello, world!")
            .padding()
        let _ = print("")
    }
    
    
    func loadFile(fileName: String) -> String? {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: "txt"),
              let contents = try? String(contentsOfFile: filepath) else { return nil }
        return contents
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
//        print("first block (numbers to be called): \(firstBlock)")
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



//    func stepThroughCalledNumbersPart2() -> Int? {
//        guard let rawString = loadFile(fileName: "input-4") else {return nil}
//        guard let exampleNumbers = separateCalledNumbers(input: rawString) else {return nil}
//        //        guard let exampleNumbers = separateCalledNumbers(input: example) else {return nil}
//
//        var calledNumbers: [Int] = []
//        let rowGrids = numberGridsInRows(input: rawString)
//        let columnGrids = makeColumnGrid(numberGridInRows: numberGridsInRows(input: rawString))
//        let allGrids = rowGrids + columnGrids
//
//        var gridsNotWon: Set<Int> = []
//        for i in 0..<rowGrids.count {
//            gridsNotWon.insert(i)
//        }
//
//        var gridsWon: Set<Int> = []
//
//    outerLoop: for number in exampleNumbers {
//        calledNumbers.append(number)
//        let calledNumbersSet: Set = Set(calledNumbers)
//
//
//        for i in 0..<rowGrids.count {
//
//            for j in 0..<5 {
//                if (Set(rowGrids[i][j]).isSubset(of: calledNumbersSet) || Set(columnGrids[i][j]).isSubset(of: calledNumbersSet)) && (gridsNotWon.count - gridsWon.count) > 1 {
//                    print("not won \(gridsNotWon.count)")
//                    print("won: \(gridsWon.count)")
//
//                    gridsWon.insert(i)
////                    print("grid won: \(Array(gridsWon).sorted())")
//                    print("")
//                } else if (Set(rowGrids[i][j]).isSubset(of: calledNumbersSet) || Set(columnGrids[i][j]).isSubset(of: calledNumbersSet)) && (gridsNotWon.count - gridsWon.count) == 1 {
//
//                    var flatGrid = rowGrids[i].flatMap { $0 }
//                    print("flat grid at start: \(flatGrid)")
//
//                    for num in calledNumbers {
//                        if flatGrid.contains(num) {
//                            if let index = flatGrid.firstIndex(of: num) {
//                                flatGrid.remove(at: index)
//                            }
//                        }
//                    }
//                    print("flat grid at end: \(flatGrid)")
//                    print("last called number: \(calledNumbers.last)")
//
//                    let total = flatGrid.reduce(0, +)
//                    if let lastCalledNumber = calledNumbers.last {
//                        return total * lastCalledNumber
//                    }
//                    break outerLoop
//
//                }
//
//            }
//
//        }
//
//
////        for grid in allGrids {
////            count += 1
////            for rowOrColumn in grid {
////                let rowOrColumnSet: Set = Set(rowOrColumn)
////
////                if rowOrColumnSet.isSubset(of: calledNumbersSet) {
////                    var flatGrid = grid.flatMap { $0 }
////
////                    for num in calledNumbers {
////                        if flatGrid.contains(num) {
////                            if let index = flatGrid.firstIndex(of: num) {
////                                flatGrid.remove(at: index)
////                            }
////                        }
////                    }
////                    let total = flatGrid.reduce(0, +)
////                    if let lastCalledNumber = calledNumbers.last {
////                        let output = total * lastCalledNumber
////                        print("output = \(output)")
//////                        return total * lastCalledNumber
////                    }
//////                    break outerLoop
////                }
////            }
////        }
//    }
//        return nil
//    }
//
//
//
//    func stepThroughCalledNumbersPart2A() -> Int? {
//        guard let rawString = loadFile(fileName: "input-4") else {return nil}
//        guard let exampleNumbers = separateCalledNumbers(input: rawString) else {return nil}
//        //        guard let exampleNumbers = separateCalledNumbers(input: example) else {return nil}
//
//        var calledNumbers: [Int] = []
//        let rowGrids = numberGridsInRows(input: rawString)
//        let columnGrids = makeColumnGrid(numberGridInRows: numberGridsInRows(input: rawString))
//        let allGrids = rowGrids + columnGrids
//
//        var gridsWon: Set<Int> = []
//
//    outerLoop: for number in exampleNumbers {
//        calledNumbers.append(number)
//        let calledNumbersSet: Set = Set(calledNumbers)
//
//        for i in 0..<rowGrids.count {
//
//            for j in 0..<5  {
//                let rowSet: Set = Set(rowGrids[i][j])
////                print("row set: \(rowSet)")
//                let columnSet: Set = Set(rowGrids[i][j])
////                print("column set: \(columnSet)")
//
//                if rowSet.isSubset(of: calledNumbersSet) || columnSet.isSubset(of: calledNumbersSet) && gridsWon.count < rowGrids.count {
//                    gridsWon.insert(i)
//
//                } else if rowSet.isSubset(of: calledNumbersSet) || columnSet.isSubset(of: calledNumbersSet) && (rowGrids.count - gridsWon.count == 1) {
//                    print(i)
//
//                    var flatGrid = rowGrids[i].flatMap { $0 }
//
//                    for num in calledNumbers {
//                        if flatGrid.contains(num) {
//                            if let index = flatGrid.firstIndex(of: num) {
//                                flatGrid.remove(at: index)
//                            }
//                        }
//                    }
//                    let total = flatGrid.reduce(0, +)
//                    if let lastCalledNumber = calledNumbers.last {
//                        return total * lastCalledNumber
//                    }
//                    break outerLoop
//                }
//            }
//        }
//    }
//        return nil
//    }
//
//
//    func finalCheck() -> Int? {
//        guard let rawString = loadFile(fileName: "input-4") else {return nil}
//        guard let exampleNumbers = separateCalledNumbers(input: rawString) else {return nil}
//        //        guard let exampleNumbers = separateCalledNumbers(input: example) else {return nil}
//
//        var calledNumbers: [Int] = []
//        let rowGrids = numberGridsInRows(input: rawString)
//        let columnGrids = makeColumnGrid(numberGridInRows: numberGridsInRows(input: rawString))
//        let allGrids = rowGrids + columnGrids
//        let lastGrids = [rowGrids[61], columnGrids[61]]
//
//    outerLoop: for number in exampleNumbers {
//        calledNumbers.append(number)
//        let calledNumbersSet: Set = Set(calledNumbers)
//
//        for grid in lastGrids {
//
//            for rowOrColumn in grid {
//                let rowOrColumnSet: Set = Set(rowOrColumn)
//
//                if rowOrColumnSet.isSubset(of: calledNumbersSet) {
//                    var flatGrid = grid.flatMap { $0 }
//
//                    for num in calledNumbers {
//                        if flatGrid.contains(num) {
//                            if let index = flatGrid.firstIndex(of: num) {
//                                flatGrid.remove(at: index)
//                            }
//                        }
//                    }
//                    let total = flatGrid.reduce(0, +)
//                    print(total)
//                    print(flatGrid)
//                    if let lastCalledNumber = calledNumbers.last {
//                        return total * lastCalledNumber
//                    }
//                    break outerLoop
//                }
//            }
//        }
//    }
//        return nil
//    }
//
