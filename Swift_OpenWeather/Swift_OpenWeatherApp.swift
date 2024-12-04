import SwiftUI
import SwiftData

@main
struct Swift_OpenWeatherApp: App {
    @State private var networkManager = NetworkManager()

    var body: some Scene {
        WindowGroup {
            FormView()
                .environmentObject(networkManager)
        }
    }
}
