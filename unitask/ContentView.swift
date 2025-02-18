import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var isCheckingAuth = true
    @State private var userEmail: String? = nil
    @State private var university: String? = nil

    var body: some View {
        Group {
            if isCheckingAuth {
                ProgressView("Checking authentication...") // Show a loading indicator while checking
            } else if isAuthenticated {
                if let university = university {
                    SignUpView(email: userEmail ?? "", university: university) // If they need to sign up
                } else {
                    HomeView() // If they are fully registered
                }
            } else {
                LoginView() // If they are not logged in
            }
        }
        .onAppear(perform: checkAuthentication)
    }

    private func checkAuthentication() {
        if let user = Auth.auth().currentUser, let email = user.email {
            self.userEmail = email
            checkIfUserExists(email: email)
        } else {
            isAuthenticated = false
            isCheckingAuth = false
        }
    }

    private func checkIfUserExists(email: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(email)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                isAuthenticated = true
                university = nil // Already registered, proceed to HomeView
            } else {
                verifyUniversityEmail(email: email)
            }
            isCheckingAuth = false
        }
    }

    private func verifyUniversityEmail(email: String) {
        guard let domain = email.split(separator: "@").last else {
            isAuthenticated = false
            return
        }

        if let uniName = getUniversityFromJSON(domain: String(domain)) {
            university = uniName
            isAuthenticated = true // Proceed to signup
        } else {
            try? Auth.auth().signOut()
            isAuthenticated = false
        }
    }

    private func getUniversityFromJSON(domain: String) -> String? {
        guard let path = Bundle.main.path(forResource: "world_universities_and_domains", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return nil
        }

        for university in json {
            if let domains = university["domains"] as? [String], domains.contains(domain) {
                return university["name"] as? String
            }
        }
        return nil
    }
}
