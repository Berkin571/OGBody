import SwiftUI

enum Tab { case home, workout, coach, settings }

struct CustomTabBarView<Content: View>: View {
    @State private var selection: Tab = .home
    private let content: (Tab) -> Content
    
    init(@ViewBuilder content: @escaping (Tab) -> Content) {
        self.content = content
        UITabBar.appearance().isHidden = true  
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // ------------------------ aktiver Screen
            content(selection)
                .ignoresSafeArea(.keyboard)
            
            // ------------------------ eigene Tab-Bar
            HStack(spacing: 0) {
                tabButton(.home,     icon: "house.fill",           title: "Home")
                tabButton(.workout,  icon: "figure.walk",          title: "Workout")
                tabButton(.coach,    icon: "brain.head.profile",   title: "Coach")
                tabButton(.settings, icon: "gearshape.fill",       title: "Einstellungen")
            }
            .padding(.horizontal, 4)
            .padding(.top, 12)
            .background(barBackground)
        }
    }
    
    // MARK: – Tab-Button
    @ViewBuilder
    private func tabButton(_ tab: Tab,
                           icon: String,
                           title: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selection = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(selection == tab
                                     ? Color("PrimaryGreen")
                                     : .gray)
                Text(title)
                    .font(.footnote)
                    .foregroundColor(selection == tab
                                     ? Color("PrimaryGreen")
                                     : .gray)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: – Hintergrund mit Markenfarben
    private var barBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color("AccentLight").opacity(0.95),
                Color("AccentLight").opacity(0.75),
                Color("AccentLight").opacity(0.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(
            Color("White")
                .clipShape(RoundedRectangle(cornerRadius: 20,
                                            style: .continuous))
        )
        .clipShape(RoundedRectangle(cornerRadius: 20,
                                    style: .continuous))
        .shadow(color: .black.opacity(0.1),
                radius: 8, x: 0, y: -4)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
