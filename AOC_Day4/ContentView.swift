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
                if let gridWon = Game.grids[i].checkRowsAndColumns(calledNumbers: calledNumbers) {
                    print("grid \(i) won")
                    print("called numbers when grid \(i) won \(gridWon.1)\n")
                    
                }
                
            }
        }
    }

}

struct Grid {
    static var gridsCreated = 0
    
    let gridIndex: Int
    var numbers: [GridNumber] = [] {
        didSet {
            numbersSet = Set(numbers.map { $0.number })
        }
    }
    var numbersSet: Set<Int> = []
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
    
    mutating func checkRowsAndColumns(calledNumbers: CalledNumbers) -> (Bool, [Int])? {
        countGridRowsAndColumns()
        

        for i in 0..<rows {
            let tempRow = numbers.filter { $0.coordinates.y == i }
            let tempRowSet = Set(tempRow.map { $0.number } )
            if tempRowSet.isSubset(of: calledNumbers.calledNumbersSet) {
                hasWon = true
                
                var tempGridSet: Set<Int> = numbersSet
                
                for num in calledNumbers.calledNumbers {
                    if tempGridSet.contains(num) {
                        if let index = tempGridSet.firstIndex(of: num) {
                            tempGridSet.remove(at: index)
                        }
                    }
                }
                let total = tempGridSet.reduce(0, +)
                if let lastCalledNumber = calledNumbers.calledNumbers.last {
                    print( total * lastCalledNumber )
                }
                
                return (true, calledNumbers.calledNumbers)
            }
        }
        
        for i in 0..<columns {
            let tempColumn = numbers.filter { $0.coordinates.x == i }
            let tempColumnSet = Set(tempColumn.map { $0.number } )
            if tempColumnSet.isSubset(of: calledNumbers.calledNumbersSet) {
                hasWon = true
                
                var tempGridSet: Set<Int> = numbersSet
                
                for num in calledNumbers.calledNumbers {
                    if tempGridSet.contains(num) {
                        if let index = tempGridSet.firstIndex(of: num) {
                            tempGridSet.remove(at: index)
                        }
                    }
                }
                let total = tempGridSet.reduce(0, +)
                if let lastCalledNumber = calledNumbers.calledNumbers.last {
                    print( total * lastCalledNumber )
                }
                return (true, calledNumbers.calledNumbers)
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
    var calledNumbers: [Int] = [] {
        didSet {
            calledNumbersSet = Set(calledNumbers)
        }
    }
    var calledNumbersSet: Set<Int> = []
    
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
        let _ = playGame(fileName: "input-4")
    }
    
    func playGame(fileName: String) {
        if var game = setUpGame(fileName: fileName) {
            for number in game.calledNumbers.allNumbers {
                game.calledNumbers.calledNumbers.append(number)
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
