//
//  ScoringSheetViewModel.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 22/11/23.
//

import SwiftUI
import Combine
extension ScoringSheetView {
    @Observable class Model {
        var players: [Player] = []
        var categories: [Category] = []
        var gameName = ""
        init(game: Game) {
            players = game.players
            for category in game.categories {
                category.createPlayerScores(players)
            }
            categories = game.categories
            gameName = game.name
        }

        func getNextFocus(currentFocus: UUID?) -> PlayerScore? {
            guard let currentFocus = currentFocus else {
                return nil
            }
            for categoryIndex in 0..<categories.count {
                if let index = categories[safe: categoryIndex]?.playerScores.firstIndex(where: { $0.id == currentFocus }) {
                    if let nextPlayerScore = categories[categoryIndex].playerScores[safe: index + 1] {
                        return nextPlayerScore
                    } else {
                        return categories[safe: categoryIndex + 1]?.playerScores.first
                    }
                }
            }
            return nil
        }

        func sumOrMinus(currentFocus: UUID?) {
            guard let currentFocus = currentFocus else { return }
            for categoryIndex in 0..<categories.count {
                if let categoryPlayerScores = categories[safe: categoryIndex]?.playerScores, let index = categoryPlayerScores.firstIndex(where: { $0.id == currentFocus }) {
                    var currentValue = Int(categoryPlayerScores[index].score)
                    currentValue?.negate()
                    let value = currentValue == nil ? "-" : "\(currentValue ?? 0)"
                    categories[categoryIndex].playerScores[index].score = value
                }
            }
        }

        func getCurrentPlayerScore(_ id: UUID) -> PlayerScore? {
            for categoryIndex in 0..<categories.count {
                if let categoryPlayerScores = categories[safe: categoryIndex]?.playerScores,
                   let index = categoryPlayerScores.firstIndex(where: { $0.id == id }) {
                    return categoryPlayerScores[index]
                }
            }
            return nil
        }

        func getGame() -> Game {
            return Game(players: players, categories: categories)
        }
    }
}
