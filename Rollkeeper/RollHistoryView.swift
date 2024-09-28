//
//  RollHistoryView.swift
//  Rollkeeper
//
//  Created by Nazar on 28/9/24.
//

import SwiftUI

struct RollHistoryView: View {
    @State var results: [RollResult]
    
    var body: some View {
        List {
            ForEach(results.indices, id: \.self) { index in
                HStack {
                    Image(systemName: "dice.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading) {
                        Text("Roll \(index + 1)")
                            .font(.title3)
                            .foregroundColor(.primary)
                        
                        Text("Dice Count: \(results[index].diceNumber)")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Result: \(results[index].rollResult)")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(results[index].rollTime, style: .time)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(results[index].rollTime, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .onDelete(perform: deleteRow)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Previous Rolls")
    }
    
    func deleteRow(at offsets: IndexSet) {
        results.remove(atOffsets: offsets)
    }
}
#Preview {
    RollHistoryView(results: [
        RollResult(id: UUID(), rollTime: Date.now, rollResult: 20, diceNumber: 4),
        RollResult(id: UUID(), rollTime: Date.now, rollResult: 16, diceNumber: 3),
        RollResult(id: UUID(), rollTime: Date.now, rollResult: 12, diceNumber: 2)
    ])
}
