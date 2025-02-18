//
//  FinalScoreViewModel.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 04/02/25.
//
import SwiftUI

enum Position: Int, CaseIterable {
    case firstPlace = 0
    case secondPlace = 1
    case thirdPlace = 2
}

enum FinalScoreError: Error {
    case noPositionError(position: Position)
}
extension FinalScoreView {
    @Observable class Model {
        var playerFinalScores: [PlayerScore]
        var firstPlayers: [PlayerScore] = []
        var secondPlayers: [PlayerScore] = []
        var thirdPlayers: [PlayerScore] = []
        var hasSingleWinner: Bool {
            firstPlayers.count > 1 ? false : true
        }
        var finalText = "You win"
        init(game: Game) {
            playerFinalScores = game.scores().sorted { a, b in
                a.intScore < b.intScore
            }

            do {
                let firstMax = try assign(position: .firstPlace, maxValue: Int.max)
                let secondMax = try assign(position: .secondPlace, maxValue: firstMax)
                try assign(position: .thirdPlace, maxValue: secondMax)
            } catch {
                switch error {
                case .noPositionError(position: let position):
                    print("No available position for \(position)")
                }
            }

            finalText = hasSingleWinner ? "\(firstPlayers.first?.player.name ?? "You") wins!" : "It's a tie!"
        }

        @discardableResult
        func assign(position: Position, maxValue: Int) throws(FinalScoreError) -> Int {
           guard let runnerUpsMaxValue = (playerFinalScores.filter {
                $0.intScore < maxValue
           }.max {
                $0.intScore < $1.intScore
           })else {
               throw FinalScoreError.noPositionError(position: position)
            }

            let runnersUp = playerFinalScores.compactMap {
                $0.intScore == runnerUpsMaxValue.intScore ? $0 : nil
            }

            for runnerUp in runnersUp {
                switch position {
                case .firstPlace:
                    firstPlayers.append(runnerUp)
                case .secondPlace:
                    secondPlayers.append(runnerUp)
                case .thirdPlace:
                    thirdPlayers.append(runnerUp)
                }
            }
            return runnerUpsMaxValue.intScore
        }
        func getMinScore() -> Int {
            playerFinalScores.min { $0.intScore < $1.intScore }?.intScore ?? 0
        }

        func getMaxScore() -> Int {
            playerFinalScores.max { $0.intScore < $1.intScore }?.intScore ?? 0
        }
    }
}
