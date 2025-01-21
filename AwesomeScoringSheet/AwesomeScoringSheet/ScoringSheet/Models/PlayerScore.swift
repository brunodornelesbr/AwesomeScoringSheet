//
//  PlayerScore.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 14/11/23.
//

import Foundation

struct PlayerScore : Identifiable, Equatable {
    var id: UUID = UUID()
    var player: Player
    var score: String = ""
}
