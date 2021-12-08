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


struct Game {
    var calledNumbers: CalledNumbers
    static var grids: [Grid] = []
    
    
//    init(fileName: String) {
//        if let contents = loadFile(fileName: fileName) {
//            let separatedContentsOfFile = separateCalledNumbers(input: contents)
//            if let tempCalledNums = separatedContentsOfFile.0 {
//                self.calledNumbers = CalledNumbers(allNumbers: tempCalledNums)
//            }
//
////            if let tempBlocks = separatedContentsOfFile.1 {
////                for block in tempBlocks {
////                    self.loadGridsIntoGame(input: block)
////                }
////
////            }
//
//        }
//    }
    
    func loadGridsIntoGame(input: String) {
        var tempBlock: [[Int]] = []
        var tempGrid = Grid()
        let rows = input.components(separatedBy: "\n")
        for row in rows {
            if !row.isEmpty {
                tempBlock.append(row.components(separatedBy: " ").compactMap(Int.init))
            }
        }
        
        for i in 0..<tempBlock.count {
            for j in 0..<tempBlock[i].count {
                let numberPosition = GridNumber(number: tempBlock[i][j], coordinates: (x: i, y: j))
                tempGrid.numbers.append(numberPosition)
            }
        }
        Game.grids.append(tempGrid)
    }
    
    mutating func checkGridsAgainstCalledNumbers() {
        for i in 0..<Game.grids.count {
            if Game.grids[i].hasWon == false {
                if let gridWon = Game.grids[i].checkRowsAndColumns(calledNumbers: calledNumbers.calledNumbers) {
                    print("grid \(i) won")
                    print("called numbers when grid \(i) won \(gridWon.1)\n")
                    
                    let f
                }
                
            }
        }
    }

}

struct Grid {
    static var gridsCreated = 0
    
    let gridIndex: Int
    var numbers: [GridNumber] = []
    var hasWon = false
    
    var rows = 0
    var columns = 0
    
    init() {
        self.gridIndex = Grid.gridsCreated
        Grid.gridsCreated += 1
    }
    
    
    mutating func countGridRowsAndColumns() {
        for number in numbers {
            if number.coordinates.y > rows {
                rows = number.coordinates.y
            }
            if number.coordinates.x > columns {
                columns = number.coordinates.x
            }
        }
    }
    
    mutating func checkRowsAndColumns(calledNumbers: Set<Int>) -> (Bool, Set<Int>)? {
        countGridRowsAndColumns()

        for i in 0..<rows {
            let tempRow = numbers.filter { $0.coordinates.y == i }
//            print("temp row: \(tempRow)")
            let tempRowSet = Set(tempRow.map { $0.number } )
//            print(tempRowSet)
            if tempRowSet.isSubset(of: calledNumbers) {
                hasWon = true
                return (true, calledNumbers)
            }
        }
        
        for i in 0..<columns {
            let tempColumn = numbers.filter { $0.coordinates.x == i }
//            print("temp row: \(tempColumn)")
            let tempColumnSet = Set(tempColumn.map { $0.number } )
//            print(tempColumnSet)
            if tempColumnSet.isSubset(of: calledNumbers) {
                hasWon = true
                return (true, calledNumbers)
                
            }
        }
        
        return nil
    }
    
}

struct GridNumber {
    let number: Int
    let coordinates: (x: Int, y: Int)
}

struct CalledNumbers {
    let allNumbers: [Int]
    let allNumbersSet: Set<Int>
    var calledNumbers: Set<Int> = []
    
    init(allNumbers: [Int]) {
        self.allNumbers = allNumbers
        self.allNumbersSet = Set(allNumbers)
    }
}





struct ContentView: View {
    var calledNumbers:[Int] = []
    var numberCards:[[Int]] = []
    var numberOfCards: Int = 0
    
    

    
    
    var body: some View {
        Text("Hello, world!")
            .padding()
//        let _ = setUpGame(fileName: "input-4")
        let _ = playGame1(fileName: "input-4")
        
        
    }
    
    func playGame1(fileName: String) {

        if var game = setUpGame(fileName: fileName) {
            for number in game.calledNumbers.allNumbers {
                game.calledNumbers.calledNumbers.insert(number)
                game.checkGridsAgainstCalledNumbers()
            }
        }
    }
    
    func setUpGame(fileName: String) -> Game? {
        guard let contents = loadFile(fileName: fileName) else { return nil }
        let separatedBlocks = separateCalledNumbers(input: contents)
        guard let tempCalledNums = separatedBlocks.0 else {return nil}
        guard let tempGridBlocks = separatedBlocks.1 else {return nil}
        let calledNumbers = CalledNumbers(allNumbers: tempCalledNums)
        
        let game = Game(calledNumbers: calledNumbers)
        
        for block in tempGridBlocks {
            game.loadGridsIntoGame(input: block)
        }

        return game
    }
    
    
    
    func loadFile(fileName: String) -> String? {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: "txt"),
              let contents = try? String(contentsOfFile: filepath) else { return nil }
        return contents
    }
    
    func separateCalledNumbers(input: String) -> ([Int]?, [String]?) {
        let stringBlocks = input.components(separatedBy: "\n\n")
        let firstBlock = stringBlocks[0].trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .compactMap(Int.init)
        var gridBlocks = stringBlocks
        gridBlocks.remove(at: 0)
        return (firstBlock, gridBlocks)
    }
    
    
//    func part2(fileName: String) -> Int? {
//        guard let contents = loadFile(fileName: fileName) else {return nil}
//        guard let calledNumbersFromFile = separateCalledNumbers(input: contents).0 else {return nil}
//        var calledNumbers = CalledNumbers(allNumbers: calledNumbersFromFile)
//        guard let gridsFromFile = separateCalledNumbers(input: contents).1 else {return nil}
//
//        var game = Game(calledNumbers: calledNumbers)
//
//        for i in 0..<gridsFromFile.count {
//            game.loadGridsIntoGame(input: gridsFromFile[i])
//        }
//
//        game.checkGridsAgainstCalledNumbers()
//
//        return nil
//    }
    

    
//    func part2(fileName: String) -> Int? {
//        guard let contents = loadFile(fileName: fileName) else {return nil}
//        guard let calledNumbersFromFile = separateCalledNumbers(input: contents).0 else {return nil}
//        var calledNumbers = CalledNumbers(allNumbers: calledNumbersFromFile)
//        guard let gridsFromFile = separateCalledNumbers(input: contents).1 else {return nil}
//
//        for i in 0..<gridsFromFile.count {
//            let rows: [Set<Int>] = makeRows(input: gridsFromFile[i])
//            let columns: [Set<Int>] = makeRows(input: gridsFromFile[i])
//
//            var grid = Grid(rows: rows, columns: columns, index: <#T##Int#>)
//
//            Grids.shared.append(grid)
//        }
//
//        return nil
//    }
//
//    func makeRows(input: String) -> [Set<Int>] {
//            var tempBlock: [Set<Int>] = []
//            let rows = input.components(separatedBy: "\n")
//            for row in rows {
//                if !row.isEmpty {
//                    tempBlock.append(Set(row.components(separatedBy: " ").compactMap(Int.init)))
//                }
//            }
//        return tempBlock
//    }
//
//    func makeColumns(input: [[Int]]) -> [[Int]] {
//        let numberOfColumns = input[0].count
//        var columns: [[Int]] = []
//
//        for i in 0..<numberOfColumns {
//            var tempColumn: [Int] = []
//            for row in input {
//                tempColumn.append(row[i])
//            }
//            columns.append(tempColumn)
//        }
//        return columns
//    }
    

    
    
    
//    func createGameGrid(input: String) -> String {
//        var stringBlocks = input.components(separatedBy: "\n\n")
//        stringBlocks.remove(at: 0)
//        return ""
//    }
//
//    func separateCalledNumbers(input: String) -> ([Int]?, [String]?) {
//        let stringBlocks = input.components(separatedBy: "\n\n")
//        let firstBlock = stringBlocks[0].trimmingCharacters(in: .whitespacesAndNewlines)
//            .components(separatedBy: ",")
//            .compactMap(Int.init)
//        var gridBlocks = stringBlocks
//        gridBlocks.remove(at: 0)
////        print("first block (numbers to be called): \(firstBlock)")
//        return (firstBlock, gridBlocks)
//    }
    
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
    
//    func stepThroughCalledNumbers() -> Int? {
//        guard let rawString = loadFile(fileName: "input-4") else {return nil}
//        guard let exampleNumbers = separateCalledNumbers(input: rawString).0 else {return nil}
//        //        guard let exampleNumbers = separateCalledNumbers(input: example) else {return nil}
//
//        var calledNumbers: [Int] = []
//        let rowGrids = numberGridsInRows(input: rawString)
//        let columnGrids = makeColumnGrid(numberGridInRows: numberGridsInRows(input: rawString))
//        let allGrids = rowGrids + columnGrids
//
//        outerLoop: for number in exampleNumbers {
//            calledNumbers.append(number)
//            let calledNumbersSet: Set = Set(calledNumbers)
//
//            for grid in allGrids {
//
//                for rowOrColumn in grid {
//                    let rowOrColumnSet: Set = Set(rowOrColumn)
//
//                    if rowOrColumnSet.isSubset(of: calledNumbersSet) {
//                        var flatGrid = grid.flatMap { $0 }
//
//                        for num in calledNumbers {
//                            if flatGrid.contains(num) {
//                                if let index = flatGrid.firstIndex(of: num) {
//                                    flatGrid.remove(at: index)
//                                }
//                            }
//                        }
//                        let total = flatGrid.reduce(0, +)
//                        if let lastCalledNumber = calledNumbers.last {
//                            return total * lastCalledNumber
//                        }
//                        break outerLoop
//                    }
//                }
//            }
//        }
//        return nil
//    }
    
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
