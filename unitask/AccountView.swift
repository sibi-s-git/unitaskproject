import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit
import FirebaseAuth

struct AccountView: View {
    // MARK: - State Variables (User Input Fields)
    @State private var firstName: String = ""  // Stores the user's first name
    @State private var lastName: String = ""   // Stores the user's last name
    @State private var selectedYear: String? = nil  // Initially nil, so user selects year
    @State private var selectedGender: String? = nil  // Initially nil, so user selects gender
    @State private var instagramHandle: String = ""  // Stores the user's Instagram handle
    @State public var saveBool: Bool = false // Boolean to saveData and refresh all State Variables
    
    // MARK: - Dropdown Options
    let yearOptions = ["Freshman", "Sophomore", "Junior", "Senior", "Grad Student"]
    let genderOptions = ["Male", "Female", "Other", "Prefer not to answer"]
    
    var body: some View {
        Text("Account View")
            .font(.title)
        VStack {
            // MARK: - Page Title
            Text("Edit Account")
                .font(.largeTitle)
                .bold()
                .padding()
            
            // MARK: - First Name Input
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // MARK: - Last Name Input
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // MARK: - Year Selection (Button Placeholder)
            Menu {
                ForEach(yearOptions, id: \.self) { year in
                    Button(action: { selectedYear = year }) {
                        Text(year)
                    }
                }
            } label: {
                HStack {
                    Text(selectedYear ?? "Select Year")
                        .foregroundColor(selectedYear == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .padding()
            
            // MARK: - Gender Selection (Button Placeholder)
            Menu {
                ForEach(genderOptions.reversed(), id: \.self) { gender in
                    Button(action: { selectedGender = gender }) {
                        Text(gender)
                    }
                }
            } label: {
                HStack {
                    Text(selectedGender ?? "Select Gender")
                        .foregroundColor(selectedGender == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .padding()
            
            // MARK: - Instagram Handle (Auto-Prefixed with "@")
            HStack {
                Text("@")
                    .bold()
                TextField("Instagram Handle", text: $instagramHandle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            // MARK: - Save Changes
            Button(action: {
                saveBool = true
            }) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)  // Makes the button take the full width of its container
                    .background(Color.blue)  // Blue background
                    .cornerRadius(8)  // Rounded corners
                    .padding()
            }
            .alert(isPresented: $saveBool) {
                Alert(
                    title: Text("Are you sure you want to save the changes?"),
                    primaryButton: .default(
                        Text("Yes"),
                        action: savedata
                    ),
                    secondaryButton: .destructive(
                        Text("No")
                    )
                )
            }
        }
        .padding()
    }
    
    public func savedata(){
        
        //authenticate user
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }
        
        //initiate firebase using user and email
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.email ?? "")
        
        var updateData: [String: Any] = [:]
        
        // Conditionally add fields to the update dictionary
        // MARK: - Variables to Update
        if !firstName.isEmpty {
            updateData["firstName"] = firstName
        }
        if !lastName.isEmpty {
            updateData["lastName"] = lastName
        }
        if let selectedYear = selectedYear {
            updateData["year"] = selectedYear
        }
        if let selectedGender = selectedGender {
            updateData["gender"] = selectedGender
        }
        if !instagramHandle.isEmpty {
            updateData["instagram"] = instagramHandle
            
        }
        
        // Update the Firestore document with the new data
        userRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating user info: \(error.localizedDescription)")
            } else {
                print("User information updated successfully!")
            }
        }
        
        
        //Reset entries
        firstName  = ""
        lastName = ""
        selectedYear = nil
        selectedGender = nil
        instagramHandle = ""
        saveBool = false
        print("save data placeholder button")
    }
}



// MARK: - Preview for SwiftUI Canvas
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
