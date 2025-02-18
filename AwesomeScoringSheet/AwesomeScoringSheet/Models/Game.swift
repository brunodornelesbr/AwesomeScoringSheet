//
//  Game.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 18/02/25.
//

import Foundation

struct Game {
    var players: [Player]
    var categories: [Category]
    var name: String = "Example Game"
    
    func scores() -> [PlayerScore] {
        var finalPlayersScore: [PlayerScore] = []
        for player in players {
            var playerScores: [PlayerScore] = []
            for category in categories {
                if let score = category.playerScores.first(where: { $0.player.id == player.id }) {
                    playerScores.append(score)
                }
            }
            let finalValue = playerScores.reduce(into: 0) { result, score in
                if let intValue = Int(score.score) {
                    result += intValue
                }
            }
            finalPlayersScore.append(PlayerScore(player: player, score: String(finalValue)))
        }
        return finalPlayersScore
    }
    
    #if DEBUG
    func mockScores() -> Self {
        for category in categories {
            let playerScores: [PlayerScore] = players.compactMap {
                return PlayerScore(player: $0, score: "\(Int.random(in: -2...15))")
            }
            categories[safe: categories.firstIndex(of: category) ?? -1]?.playerScores = playerScores
        }
        return self
    }
    #endif
}
