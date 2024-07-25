//
//  ScoreRow.swift
//  AnotherArrowDirection
//
//  Created by Raphaël Daumas on 25/07/2024.
//

import SwiftUI

struct ScoreRow: View {
    let score: Score
    let neo: Bool
    
    var body: some View {
        
        ZStack
        {
            RoundedRectangle(cornerRadius: 10)
                .fill(neo ? .green.opacity(0.25) : .gray.opacity(0.25))
                .frame(height: 50)
            
            HStack {
                Text("\(score.score)")
                    .bold()
                
                Spacer(minLength: 10)
                
                Text(score.date, style: .date) +
                Text(" - ") +
                Text(score.date, style: .time)
            }
            .padding()
        }
    }
}

#Preview {
    ScoreRow(score: Score(date: Date().addingTimeInterval(-800), score: 100), neo: false)
        .preferredColorScheme(.dark)
}
