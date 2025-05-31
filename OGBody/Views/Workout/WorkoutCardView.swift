import SwiftUI

struct WorkoutCardView: View {
    let day: TrainingDay
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Hintergrund-Gradient je Kategorie
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(day.category.gradient)
                .frame(height: 180)
            
            // Icon
            Image(systemName: day.category.icon)
                .font(.system(size: 28))
                .foregroundColor(.white.opacity(0.9))
                .padding(10)
            
            // Titel & Info
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                Text(day.name)
                    .font(.headline).bold()
                    .foregroundColor(.white)
                Text("\(day.items.count) Übungen")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
        }
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
    }
}
