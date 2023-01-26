//
//  ContentView.swift
//  TicTacToe
//
//  Created by AnatoliiOstapenko on 22.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(0..<9) { index in
                        ZStack {
                            Rectangle()
                                .frame(width: geometry.size.width/3.5, height: geometry.size.width/3.5)
                                .foregroundColor(.red).opacity(0.5)
                                .cornerRadius(20)
                            Image(systemName: moves[index]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            /// return from closure if element in Array has been already exist
                            if isSquareOccupied(moves, index) { return }
                            moves[index] = Move(player: .human, boardIndex: index)

                            /// check on win condition or draw
                            if checkWinCondition(player: .human, moves: moves) {
                                alertItem = AlertContect.humanWin
                                return
                            }
                            if checkForDraw(moves: moves) {
                                alertItem = AlertContect.draw
                                return
                            }
                            
                            /// when isGameboardDisabled it's activate disabled till computer make it's turn
                            isGameboardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let computerPosition = determineComputerMovePosition(moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisabled = false
                                /// check on win condition or draw
                                if self.checkWinCondition(player: .computer, moves: moves) {
                                    alertItem = AlertContect.computerWin
                                    return
                                }
                                if checkForDraw(moves: moves) {
                                    alertItem = AlertContect.draw
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboardDisabled) /// disable -  able user interaction with view
            .padding()
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { resetGame() }))
            }
        }
    }
    
    private func isSquareOccupied(_ moves: [Move?], _ index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    private func determineComputerMovePosition(_ moves: [Move?]) -> Int {
        
        // if AI can win, then win (the case, when remain 1 step to win for computer)
        
        /// filtering every nested objects which computer was chosen
        let computerMoves = moves.compactMap {$0}.filter {$0.player == .computer}
        /// map all indexes of computer
        let computerPositions = Set(computerMoves.map {$0.boardIndex})
        
        for pattern in Constants.winPattern {
            /// subtacting (delete) elements from nested Sets
            let winPosition = pattern.subtracting(computerPositions)

            if winPosition.count == 1 {
                // check if the last element
                let isAvailable = !isSquareOccupied(moves, winPosition[winPosition.startIndex])
                /// another way to get first element from Set is winPosition.first!
                if isAvailable { return winPosition[winPosition.startIndex] }
            }
        }
        
        // if AI can win, then block (the case, when remain 1 step to win for human)
        
        let playerMoves = moves.compactMap {$0}.filter {$0.player == .human}
        /// map all indexes of computer
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        
        for pattern in Constants.winPattern {
            /// subtacting (delete) elements from nested Sets
            let winPosition = pattern.subtracting(playerPositions)
            print("winPosition: \(winPosition)")
            if winPosition.count == 1 {
                // check if the last element
                let isAvailable = !isSquareOccupied(moves, winPosition[winPosition.startIndex])
                /// another way to get first element from Set is winPosition.first!
                if isAvailable { return winPosition[winPosition.startIndex] }
            }
        }
        
        // if AI can't block, then take a middle square #4
        if !isSquareOccupied(moves, 4) { return 4 }
        
        // if AI can't take the midle square, take random available square
        var movePosition = Int.random(in: Constants.range)
        
        while isSquareOccupied(moves, movePosition) {
            movePosition = Int.random(in: Constants.range)
        }
        return movePosition
    }
    
    private func checkForDraw(moves: [Move?]) -> Bool {
        return moves.compactMap {$0}.count == 9 /// true if the all cells are occupied
    }
    
    private func checkWinCondition(player: Player, moves: [Move?]) -> Bool {
        /// filtering every objects (elements) from moves depending on player or computer was chosen
        let playerMoves = moves.compactMap {$0}.filter {$0.player == player}
        
        /// map all indexes of player
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        
        /// check if any nested Set from winPattern == playerPositions
        for pattern in Constants.winPattern where pattern.isSubset(of: playerPositions) { return true }
        return false
    }
    
    private func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}

enum Player { case human, computer }

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
