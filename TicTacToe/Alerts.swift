//
//  Alerts.swift
//  TicTacToe
//
//  Created by AnatoliiOstapenko on 25.01.2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContect {
    static let humanWin = AlertItem(
         title: Text("You Win!"),
         message: Text("You are so smart. You beat your own AI."),
         buttonTitle: Text("Yeh")
    )
    static let computerWin = AlertItem(
         title: Text("You Lost!"),
         message: Text("AI is so well programmed. You was beaten by your own AI."),
         buttonTitle: Text("Rematch")
    )
    static let draw = AlertItem(
         title: Text("Draw"),
         message: Text("What a battle of wits we have here..."),
         buttonTitle: Text("Try Again")
    )
}

