//
//  FinalScoreView.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 22/01/25.
//

import SwiftUI
import Charts
import Combine
import ConfettiSwiftUI

struct FinalScoreView: View {
    @State var model: FinalScoreView.Model
    @State var animationStatus: AnimationStatus = .initial
    @State var fireConfetti: Bool = false
    fileprivate func animateChart() {
        for (index, _) in model.playerFinalScores.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500 * index)) {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5)) {
                    model.playerFinalScores[index].animate = true

                    if index >= model.playerFinalScores.count - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeOut) {
                                animationStatus = .reveal
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(.easeOut) {
                                        animationStatus = .congratulations
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            withAnimation {
                                                fireConfetti = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        Group {
            VStack(alignment: .center) {
                if animationStatus == .congratulations {
                    WinnerView(firstPlace: $model.firstPlayers, secondPlace: $model.secondPlayers, thirdPlace: $model.thirdPlayers, winnerText: $model.finalText, fireConfetti: $fireConfetti, hasSingleWinner: model.hasSingleWinner)
                }
                ChartView(model: $model, animationStatus: $animationStatus)
                    .chartYScale(domain: 0...model.getMaxScore())
                    .onAppear {
                        animateChart()
                    }
                    .frame(height: 200)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension FinalScoreView {
    struct WinnerView: View {
        @Binding var firstPlace: [PlayerScore]
        @Binding var secondPlace: [PlayerScore]
        @Binding var thirdPlace: [PlayerScore]
        @Binding var winnerText: String
        @Binding var fireConfetti: Bool
        var hasSingleWinner: Bool
        var body: some View {
            VStack(spacing: 6) {
                if hasSingleWinner {
                    Text(winnerText)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Color(firstPlace.first?.player.chosenColor.name() ?? "black"))
                } else {
                    Text(winnerText)
                        .font(.system(size: 26, weight: .semibold))
                }
                HStack(alignment: .bottom, spacing: 0) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach($secondPlace) { playerScore in
                                ScoringSheetView.PlayerHeader(player: playerScore.player)
                            }
                        }
                            Rectangle()
                                .fill(.gray.gradient)
                                .frame(minHeight: 20, maxHeight: 40)
                    }
                    VStack(spacing: 0) {
                        if hasSingleWinner {
                            Image(.trophyWinner)
                                .resizable()
                                .frame(width: 25, height: 20)
                                .confettiCannon(trigger: $fireConfetti, num: 70, rainHeight: 700, closingAngle: Angle(degrees: 330), radius: 350)
                        }
                        HStack(spacing: 0) {
                            ForEach($firstPlace) { playerScore in
                                ScoringSheetView.PlayerHeader(player: playerScore.player)
                            }
                        }
                            Rectangle()
                                .fill(.gray.gradient)
                                .frame(minHeight: 60, maxHeight: 70)
                    }
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach($thirdPlace) { playerScore in
                                ScoringSheetView.PlayerHeader(player: playerScore.player)
                            }
                        }
                            Rectangle()
                                .fill(.gray.gradient)
                                .frame(maxHeight: 20)
                    }
                }.padding([.leading, .trailing, .bottom], 12)
            }
        }
    }
}

struct ChartView: View {
    @Binding var model: FinalScoreView.Model
    @Binding var animationStatus: AnimationStatus
    var body: some View {
        Chart {
            ForEach(model.playerFinalScores) { item in
                BarMark(
                    x: .value("Player name", animationStatus != .initial ? item.player.name : "\(model.playerFinalScores.count - model.playerFinalScores.firstIndex(of: item)!)"),
                    y: .value("Final Score", item.animate ? item.intScore : 0)
                )
                .foregroundStyle(animationStatus != .initial ? Color(item.player.chosenColor.name()).gradient : Color.gray.gradient)
                .annotation(position: .top, alignment: .center) { Text(item.animate ? item.score : "") }
            }
        }
    }
}

struct FinalScoreView_Previews: PreviewProvider {
   static var previews: some View {
       let players = [Player(name: "Player 1", chosenColor: .green),
                      Player(name: "Player 2", chosenColor: .yellow),
                      Player(name: "Player 3", chosenColor: .blue),
                      Player(name: "Player 4", chosenColor: .orange),
                      Player(name: "Player 5", chosenColor: .black),
                      Player(name: "Player 6", chosenColor: .red)
                     ]

       let categories = [Category(name: "TR", odd: true),
                         Category(name: "AWARDS", odd: false),
                         Category(name: "MILESTONES", odd: true),
                                           Category(name: "Two", odd: false),
                         Category(name: "GREENERIES", odd: true),
                         Category(name: "CITIES", odd: false),
                         Category(name: "CARDS", odd: true)
       ]

       FinalScoreView(model: FinalScoreView.Model(game: Game(players: players, categories: categories).mockScores()))
   }
}

enum AnimationStatus {
    case initial
    case reveal
    case congratulations
}
