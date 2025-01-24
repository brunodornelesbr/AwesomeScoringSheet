//
//  FinalScoreView.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 22/01/25.
//

import SwiftUI
import Charts
enum AnimationStatus {
    case initial
    case reveal
    case congratulations
}
struct FinalScoreView: View {
    @State var model: FinalScoreView.Model
    @State var animationStatus: AnimationStatus = .initial
    fileprivate func animateChart() {
        for (index, _) in model.playerFinalScores.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500 * index)) {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5)) {
                    model.playerFinalScores[index].animate = true

                    if index >= model.playerFinalScores.count - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeOut) {
                                animationStatus = .reveal
                            }
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        Chart {
            ForEach(model.playerFinalScores) { item in
                BarMark(
                    x: .value("Player name", animationStatus != .initial ? item.player.name : "\(model.playerFinalScores.count - model.playerFinalScores.firstIndex(of: item)!)"),
                    y: .value("Final Score", item.animate ? item.intScore : 0)
                )
                .foregroundStyle(animationStatus != .initial ? Color(item.player.chosenColor.name()).gradient : Color.gray.gradient)
                .annotation(position: .overlay, alignment: .center) { Text(item.animate ? item.score : "") }
            }
        } .chartYScale(domain: 0...model.getMaxScore())
        .onAppear {
            animateChart()
        }
        .frame(height: 200)
    }
}

extension FinalScoreView {
    @Observable class Model {
        var playerFinalScores: [PlayerScore]

        init(game: Game) {
            playerFinalScores = game.scores().sorted { a, b in
                a.intScore < b.intScore
            }
        }

        func getMinScore() -> Int {
            playerFinalScores.min { $0.intScore < $1.intScore }?.intScore ?? 0
        }

        func getMaxScore() -> Int {
            playerFinalScores.max { $0.intScore < $1.intScore }?.intScore ?? 0
        }
    }
}
