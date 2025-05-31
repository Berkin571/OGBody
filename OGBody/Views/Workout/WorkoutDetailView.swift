import SwiftUI

struct WorkoutDetailView: View {
    let day: TrainingDay
    
    var body: some View {
        List {
            Section {
                ForEach(day.items, id: \.self) { Text($0) }
            }
        }
        .navigationTitle(day.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
