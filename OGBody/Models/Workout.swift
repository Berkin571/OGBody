// Kann gelöscht werden, wenn du keine Demo-Workouts mehr brauchst.
// Lass sie ruhig im Projekt, falls du Beispiel-Cards anzeigen willst.

import Foundation
@available(*, deprecated, message: "Nicht mehr im Einsatz – Trainingsdaten kommen aus Firestore.")
struct Workout: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let instructions: String
}
