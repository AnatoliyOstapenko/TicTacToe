//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by AnatoliiOstapenko on 26.01.2023.
//

import SwiftUI

class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(_ index: Int) {
        // Human move processing
        if isSquareOccupied(moves, index) { return }
        moves[index] = Move(player: .human, boardIndex: index)

        if checkWinCondition(player: .human, moves: moves) {
            alertItem = AlertContect.humanWin
            return
        }
        if checkForDraw(moves: moves) {
            alertItem = AlertContect.draw
            return
        }
        isGameboardDisabled = true /// when isGameboardDisabled it's activate disabled till computer make it's turn
       
        // Computer move processing
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let computerPosition = self.determineComputerMovePosition(self.moves)
            self.moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            self.isGameboardDisabled = false
            /// check on win condition or draw
            if self.checkWinCondition(player: .computer, moves: self.moves) {
                self.alertItem = AlertContect.computerWin
                return
            }
            if self.checkForDraw(moves: self.moves) {
                self.alertItem = AlertContect.draw
                return
            }
        }
    }
    
    private func isSquareOccupied(_ moves: [Move?], _ index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    private func determineComputerMovePosition(_ moves: [Move?]) -> Int {
        
        // MARK: - if AI can win, then win (the case, when remain 1 step to win for computer)
        
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
        
        // MARK: - if AI can't win, then block (the case, when remain 1 step to win for human)
        
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
        
        /// if AI can't block, then take a middle square #4
        if !isSquareOccupied(moves, 4) {
            return 4
            
            // MARK: - Make AI invincible
            /// Add block which make AI invincible. Start block ->
        } else if playerPositions.contains(4) {
            let corners: Set<Int> = [0,2,6,8]
            for item in corners {
                let availableCorner = !isSquareOccupied(moves, item)
                if availableCorner { return item }
            }
        } else {
            let cross: Set<Int> = [1,3,5,7]
            for item in cross {
                let availableCorner = !isSquareOccupied(moves, item)
                if availableCorner { return item }
            }
        }
        ///  -> End block
        
        // MARK: - if AI can't take the midle square, take random available square
        
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
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
