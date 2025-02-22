import SwiftUI
import Firebase
import FirebaseFirestore

struct SignUpView: View {
    let email: String
    let university: String
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedYear = "Freshman"
    @State private var instagramHandle = ""
    @State private var selectedGender = "Male"
    @State private var showValidationAlert = false // Alert for missing fields

    let years = ["Freshman", "Sophomore", "Junior", "Senior", "Grad Student"]
    let genders = ["Male", "Female", "Other"]

    var body: some View {
        VStack {
            Text("Verified with \(university)")
                .font(.headline)
                .padding()

            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Year", selection: $selectedYear) {
                ForEach(years, id: \.self) { Text($0) }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            HStack {
                Text("@")
                TextField("Instagram", text: $instagramHandle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()

            Picker("Gender", selection: $selectedGender) {
                ForEach(genders, id: \.self) { Text($0) }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Button(action: validateFields) {
                Text("Sign Up")
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .alert(isPresented: $showValidationAlert) {
            Alert(title: Text("Missing Fields"),
                  message: Text("Please fill out all fields before signing up."),
                  dismissButton: .default(Text("OK")))
        }
    }

    /// **🔹 Validates all fields before allowing sign-up**
    private func validateFields() {
        if firstName.trimmingCharacters(in: .whitespaces).isEmpty ||
            lastName.trimmingCharacters(in: .whitespaces).isEmpty ||
            instagramHandle.trimmingCharacters(in: .whitespaces).isEmpty {
            showValidationAlert = true
        } else {
            registerUser() // Proceed with registration
        }
    }

    private func registerUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(email)

        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "year": selectedYear,
            "instagram": instagramHandle,
            "gender": selectedGender,
            "university": university,
            "completed": 0,  // New field: default to 0
            "orders": [:]     // New field: empty map/dictionary
        ]

        // First, check if the university collection exists
        let universityRef = db.collection(university)
        universityRef.limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking university collection: \(error.localizedDescription)")
                return
            }

            if snapshot?.documents.isEmpty == true {
                // If collection doesn't exist, add a placeholder document to create it
                universityRef.document("placeholder").setData(["created": true]) { error in
                    if let error = error {
                        print("Error creating university collection: \(error.localizedDescription)")
                        return
                    }
                    print("University collection \(university) created.")
                }
            }

            // Now, save the user data
            userRef.setData(userData) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    navigateToHomeView()
                }
            }
        }
    }

    private func navigateToHomeView() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: HomeView())
            window.makeKeyAndVisible()
        }
    }
}
