//
//  GameView.swift
//  TicTacToe
//
//  Created by AnatoliiOstapenko on 22.01.2023.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: gameViewModel.columns, spacing: 8) {
                    ForEach(0..<9) { index in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            PlayerIndicatorView(systemImageName: gameViewModel.moves[index]?.indicator ?? "")
                        }
                        .onTapGesture {
                            gameViewModel.processPlayerMove(index)
                        }
                    }
                }
                Spacer()
            }
            .disabled(gameViewModel.isGameboardDisabled) /// disable -  able user interaction with view
            .padding()
            .alert(item: $gameViewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { gameViewModel.resetGame() }))
            }
        }
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
        GameView()
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .frame(width: proxy.size.width/3.5, height: proxy.size.width/3.5)
            .foregroundColor(.red).opacity(0.5)
            .cornerRadius(20)
    }
}

struct PlayerIndicatorView: View {
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
