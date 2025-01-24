//
//  AwesomeScoringSheetApp.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 07/11/23.
//

import SwiftUI

@main
struct AwesomeScoringSheetApp: App {
    var body: some Scene {
        WindowGroup {
            let players = [Player(name: "Player 1", chosenColor: .green),
                           Player(name: "Player 2", chosenColor: .yellow),
                           Player(name: "Player 3", chosenColor: .blue),
                           Player(name: "Player 4", chosenColor: .orange),
                           Player(name: "Player 5", chosenColor: .black),
                           Player(name: "Player 6", chosenColor: .red)
                          ]

            var categories = [Category(name: "TR", odd: true),
                              Category(name: "AWARDS", odd: false),
                              Category(name: "MILESTONES", odd: true),
                                                Category(name: "Two", odd: false),
                              Category(name: "GREENERIES", odd: true),
                              Category(name: "CITIES", odd: false),
                              Category(name: "CARDS", odd: true)
            ]
            let model = ScoringSheet.Model(
                players: players, categories: categories)

//            FinalScoreView(model: FinalScoreView.Model(game: Game(players: players, categories: categories).mockScores()))

            ScoringSheet(model: model)
        }
    }
}
