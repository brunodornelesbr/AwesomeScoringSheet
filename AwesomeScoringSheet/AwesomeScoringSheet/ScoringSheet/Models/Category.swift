//
//  Category.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 14/11/23.
//

import Foundation

@Observable class Category: Identifiable, Hashable {

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    var id = UUID()
    var name: String
    var odd: Bool
    var isSelected: Bool = false
    var colorName: String { odd ? "CategoryOff" : "CategoryOn" }
    var playerScores: [PlayerScore] = []

    init(id: UUID = UUID(), name: String, odd: Bool) {
        self.id = id
        self.name = name
        self.odd = odd
    }

    func createPlayerScores(_ players: [Player]) {
        playerScores = players.map { PlayerScore(player: $0, score: "") }
    }

}
