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

            Button(action: registerUser) {
                Text("Sign Up")
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
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
            "university": university
        ]

        userRef.setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                navigateToHomeView()
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
