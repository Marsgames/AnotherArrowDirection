//
//  GameOverView.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import Charts
import OSLog
import SwiftUI

struct Score: Identifiable, Codable, Equatable {
    var id = UUID().uuidString
    let date: Date
    let score: Int

    static func == (lhs: Score, rhs: Score) -> Bool {
        return lhs.id == rhs.id
    }
}

struct GameOverView: View {
    private let Log = Logger(subsystem: "AnotherArrowDirection", category: "GameOverView")

    private let actualScore: Score
    private let currentDate = Date()
    private let scoreAmount: Int
    private var previousScores: [Score] = []
    private var bestScores: [Score] = []

    init(score: Int) {
        self.scoreAmount = score
        self.actualScore = Score(date: Date(), score: self.scoreAmount)

        #if targetEnvironment(simulator)
        // Generate fake datas for preview
        self.previousScores = [
            Score(date: Date().addingTimeInterval(-800), score: 100),
            Score(date: Date().addingTimeInterval(-700), score: 200),
            Score(date: Date().addingTimeInterval(-400), score: 183),
            Score(date: Date().addingTimeInterval(-153), score: 465),
            Score(date: Date().addingTimeInterval(-486), score: 351),
            Score(date: Date().addingTimeInterval(-864), score: 894),
            Score(date: Date().addingTimeInterval(-867), score: 245),
            Score(date: Date().addingTimeInterval(-456), score: 645),
            Score(date: Date().addingTimeInterval(-120), score: 1204),
            Score(date: Date().addingTimeInterval(-945), score: 543),
        ]
        #else
        // Get previous scores
        if let scoresString = UserDefaults.standard.string(forKey: "previousScores") {
            let strings = scoresString.components(separatedBy: ",")
            for string in strings {
                let components = string.components(separatedBy: ":")
                let timestamp = components[0]
                let score = components[1]
                if let date = Double(timestamp), let score = Int(score) {
                    self.previousScores.append(Score(date: Date(timeIntervalSince1970: date), score: score))
                }
            }
        }
        #endif
        // Add actual score to previous scores
        self.previousScores.append(self.actualScore)

        // Sort previous scores by date
        self.previousScores = self.previousScores.sorted(by: { $0.date < $1.date })

        // Save previous scores
        let scoresString = self.previousScores.map { "\($0.date.timeIntervalSince1970):\($0.score)" }.joined(separator: ",")
        UserDefaults.standard.setValue(scoresString, forKey: "previousScores")

        //////////////////////////////////////////

        // Add the current score
        self.bestScores = previousScores

        // Sort best scores by score
        self.bestScores = self.bestScores.sorted(by: { $0.score > $1.score })

        // Keep 5 best scores
        if self.bestScores.count > 5 {
            self.bestScores.removeLast(self.bestScores.count - 5)
        }

        if !self.bestScores.contains(actualScore)
        {
            self.bestScores.append(actualScore)
            self.bestScores = self.bestScores.sorted(by: { $0.score > $1.score })

            // Remove the last one except if it's the actual score
            if self.bestScores.count > 5 {
                self.bestScores.removeLast()
            }

            if !self.bestScores.contains(actualScore)
            {
                self.bestScores.removeLast()
                self.bestScores.append(actualScore)
            }
        }

        UserDefaults.standard.setValue(self.bestScores.first?.score ?? 0, forKey: "bestScore")

        // Remove old entries from previous scores (but keep them in user database for best score)
        if self.previousScores.count > 10 {
            self.previousScores.removeFirst(self.previousScores.count - 10)
        }
    }

    var body: some View {
        ZStack {
            Background()

            VStack(spacing: 10) {
                HStack {
                    Text("Score: \(self.scoreAmount)")
                        .font(.title)
                        .textCase(.uppercase)
                        .bold()

                    Spacer()
                }
                .padding(.bottom)

                if self.previousScores.count > 1 {
                    // Charts with previous scores. X will be time, Y will be score
                    Chart(self.previousScores.sorted(by: { $0.date < $1.date })) {
                        AreaMark(x: .value("Date", $0.date), y: .value("Score", $0.score))
                            .foregroundStyle(LinearGradient(colors: [.green, .clear], startPoint: .top, endPoint: .bottom))

                        LineMark(x: .value("Date", $0.date), y: .value("Score", $0.score))
                            .foregroundStyle(.green)

                        PointMark(x: .value("Date", $0.date), y: .value("Score", $0.score))
                            .foregroundStyle(.gray)
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                } else {
                    Color.clear
                }

                Divider()

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.25))

                    VStack(spacing: 5) {
                        ForEach(self.bestScores) { score in
                            ScoreRow(score: score, neo: score == self.actualScore)
                        }
                    }
                    .padding()
                }

                Spacer(minLength: 0)

                HStack(spacing: 25) {
                    Button {
                        AppManager.shared.currentScreen = .Home
                    } label: {
                        HStack {
                            Spacer()

                            Text("Home")
                                .foregroundColor(.primary)
                                .textCase(.uppercase)
                                .font(.headline)
                                .bold()
                                .padding(10)

                            Spacer()
                        }
                        .background {
                            Capsule()
                                .stroke(style: StrokeStyle(lineWidth: 2))
                        }
                        .accentColor(.gray)
                    }

                    Button {
                        AppManager.shared.currentScreen = .Game
                    } label: {
                        HStack {
                            Spacer()

                            Text("Play again")
                                .foregroundColor(.white)
                                .textCase(.uppercase)
                                .font(.title2)
                                .bold()
                                .padding(10)

                            Spacer()
                        }
                        .background {
                            Capsule()
                        }
                        .accentColor(.green)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview("Dark") {
    GameOverView(score: 493)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    GameOverView(score: 2500)
}
