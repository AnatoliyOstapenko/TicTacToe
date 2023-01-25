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
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(0..<9) { index in
                        ZStack {
                            Rectangle()
                                .frame(width: geometry.size.width/3.5,
                                       height: geometry.size.width/3.5)
                                .foregroundColor(.red).opacity(0.5)
                                .cornerRadius(20)
                            Image(systemName: moves[index]?.indicator ?? " ")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            /// return from closure if element in Array has been already exist
                            if isSquareOccupied(moves, index) { return }
                            moves[index] = Move(player: .human, boardIndex: index)
                            /// when isGameboardDisabled it's activate disabled till computer make it's turn
                            isGameboardDisabled = true
                            
                            // check on win condition or draw
                            if checkWinCondition(player: .human, moves: moves) {
                                print("Human Wins")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let computerPosition = determineComputerMovePosition(moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisabled = false
                                
                                if self.checkWinCondition(player: .computer, moves: moves) {
                                    print("Computer Wins")
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboardDisabled) /// disable -  able interaction user with view
            .padding()
        }
    }
    
    private func isSquareOccupied(_ moves: [Move?], _ index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    private func determineComputerMovePosition(_ moves: [Move?]) -> Int {
        var movePosition = Int.random(in: Constants.range)
        
        while isSquareOccupied(moves, movePosition) {
            movePosition = Int.random(in: Constants.range)
        }
        return movePosition
    }
    
    private func checkWinCondition(player: Player, moves: [Move?]) -> Bool {
        /// filtering every objects (elements) from moves depending on player or computer was chosen
        let playerMoves = moves.compactMap {$0}.filter {$0.player == player}
        /// map all indexes of player
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        print("playerPositions: \(playerPositions)")
        
        /// check if any nested Set from winPattern == playerPositions
        for pattern in Constants.winPattern where pattern.isSubset(of: playerPositions) { return true }
        return false
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
