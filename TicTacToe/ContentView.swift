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
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(0..<9) { _ in
                        ZStack {
                            Rectangle()
                                .frame(width: geometry.size.width/3.5,
                                       height: geometry.size.width/3.5)
                                .foregroundColor(.red).opacity(0.5)
                                .cornerRadius(20)
                            Image(systemName: player.indicator)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }
            .padding()
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
        ContentView()
    }
}