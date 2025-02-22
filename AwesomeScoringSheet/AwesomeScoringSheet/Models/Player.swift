//
//  Player.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 14/11/23.
//

import Foundation

struct Player: Identifiable, Hashable {
    var id = UUID()

    var name: String
    var chosenColor: Player.Color

    enum Color {
        case black, red, blue, yellow, orange, green

        func name() -> String {
            switch self {
            case .black:
                return "PlayerBlack"
            case .red:
                return "PlayerRed"
            case .blue:
                return "PlayerBlue"
            case .yellow:
                return "PlayerYellow"
            case .orange:
                return "PlayerOrange"
            case .green:
                return "PlayerGreen"
            }
        }
    }
}
