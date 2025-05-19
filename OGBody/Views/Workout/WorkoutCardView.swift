import SwiftUI

struct WorkoutCardView: View {
    let workout: Workout

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(workout.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(16)

            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(16)

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(workout.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
    }
}
