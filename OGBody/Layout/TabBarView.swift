import SwiftUI

enum Tab { case home, workout, coach }

struct CustomTabBarView<Content: View>: View {
    @State private var selection: Tab = .home
    // Markiere content als @ViewBuilder, damit Switch-Blöcke direkt Views erzeugen dürfen.
    private let content: (Tab) -> Content

    init(@ViewBuilder content: @escaping (Tab) -> Content) {
        self.content = content
        // Verstecke die Standard-TabBar
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // 1) Der jeweils gewählte View
            content(selection)
                .ignoresSafeArea(.keyboard)

            // 2) Die Custom-Bar
            HStack {
                tabButton(.home,    icon: "house.fill",         title: "Home")
                Spacer()
                tabButton(.workout, icon: "figure.walk",        title: "Workout")
                Spacer()
                tabButton(.coach,   icon: "brain.head.profile", title: "Coach")
            }
            .padding(.horizontal, 4)
            .padding(.top, 12)
            .background(LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.9),
                    Color.white.opacity(0.6),
                    Color.white.opacity(0.0)
                    ]),
                startPoint: .top,
                endPoint: .bottom
                )
                .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                           )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -4)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
    }

    @ViewBuilder
    private func tabButton(_ tab: Tab, icon: String, title: String) -> some View {
        Button {
            withAnimation(.spring()) { selection = tab }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(selection == tab ? Color("PrimaryGreen") : .gray)
                Text(title)
                    .font(.footnote)
                    .foregroundColor(selection == tab ? Color("PrimaryGreen") : .gray)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
}
