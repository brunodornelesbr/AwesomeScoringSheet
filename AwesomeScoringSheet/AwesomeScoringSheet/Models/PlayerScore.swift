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
