//
//  PlayerScore.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 14/11/23.
//

import Foundation

struct PlayerScore: Identifiable, Equatable {
    var id = UUID()
    var player: Player
    var score: String = ""
    var intScore: Int { Int(score) ?? 0 }
    var animate = false
}

struct Game {
    var players: [Player]
    var categories: [Category]

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

    func mockScores() -> Self {
        for category in categories {
            let playerScores: [PlayerScore] = players.compactMap {
                return PlayerScore(player: $0, score: "\(Int.random(in: -2...10))")
            }
            categories[safe: categories.firstIndex(of: category) ?? -1]?.playerScores = playerScores
        }
        return self
    }
}
