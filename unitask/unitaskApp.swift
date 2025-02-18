import SwiftUI
import Firebase
import FirebaseAuth

@main
struct unitaskApp: App {
    @StateObject private var authStateManager = AuthStateManager()

    init() {
        FirebaseApp.configure() // Initialize Firebase
        authStateManager.initialize() // Check authentication state
    }

    var body: some Scene {
        WindowGroup {
            if authStateManager.isLoggedIn {
                HomeView()
            } else {
                LoginView(onLoginSuccess: {
                    authStateManager.isLoggedIn = true // Update state manually
                })
            }
        }
    }
}

class AuthStateManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func initialize() {
        isLoggedIn = Auth.auth().currentUser != nil

        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = (user != nil)
        }
    }
}
