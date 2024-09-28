import SwiftUI
import SwiftData

struct RollHistoryView: View {
    @Query(sort: [
        SortDescriptor(\RollResult.rollTime, order: .reverse) // Sort in reverse order
    ]) var results: [RollResult]
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            ForEach(results.indices, id: \.self) { index in
                HStack {
                    Image(systemName: "dice.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading) {
                        Text("Roll \(results.count - index)") // Reverse the index
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
            .onDelete(perform: delete)
        }
        .navigationBarBackButtonHidden()
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Roll History")
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                Text("Back")
            }
        })
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let result = results[offset]
            modelContext.delete(result)
        }
    }
}
