//
//  ScoringSheetViewModel.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 22/11/23.
//

import SwiftUI
import Combine
extension ScoringSheet {
    @Observable class Model {
        var players: [Player] = []
        var categories: [Category] = []

        init(players: [Player], categories: [Category]) {
            self.players = players
            for category in categories {
                category.createPlayerScores(players)
            }
            self.categories = categories
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
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        guard self.indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
