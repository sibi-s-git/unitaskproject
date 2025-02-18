import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var errorMessage: String?
    var onLoginSuccess: (() -> Void)?

    var body: some View {
        VStack {
            Button(action: signInWithGoogle) {
                Text("Log in with School Email")
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }

    private func signInWithGoogle() {
        guard let presentingVC = getRootViewController() else {
            errorMessage = "Could not find root view controller"
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                errorMessage = "Google Sign-In failed: \(error.localizedDescription)"
                return
            }

            guard let idToken = result?.user.idToken?.tokenString,
                  let accessToken = result?.user.accessToken.tokenString else {
                errorMessage = "Error retrieving Google tokens"
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    errorMessage = "Firebase Sign-In failed: \(error.localizedDescription)"
                    return
                }

                guard let email = authResult?.user.email else { return }
                checkIfUserExists(email: email)
            }
        }
    }

    private func checkIfUserExists(email: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(email)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                navigateToHomeView()
            } else {
                verifyUniversityEmail(email: email)
            }
        }
    }

    private func verifyUniversityEmail(email: String) {
        guard let domain = email.split(separator: "@").last else {
            errorMessage = "Invalid email format."
            return
        }

        if let university = getUniversityFromJSON(domain: String(domain)) {
            navigateToSignUpView(email: email, university: university)
        } else {
            errorMessage = "Not a university email."
            try? Auth.auth().signOut()
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

    private func navigateToHomeView() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HomeView())
            window.makeKeyAndVisible()
        }
    }

    private func navigateToSignUpView(email: String, university: String) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: SignUpView(email: email, university: university))
            window.makeKeyAndVisible()
        }
    }

    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return nil
        }
        return rootVC
    }
}
