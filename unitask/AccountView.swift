import SwiftUI

struct AccountView: View {
    // MARK: - State Variables (User Input Fields)
    @State private var firstName: String = ""  // Stores the user's first name
    @State private var lastName: String = ""   // Stores the user's last name
    @State private var selectedYear: String? = nil  // Initially nil, so user selects year
    @State private var selectedGender: String? = nil  // Initially nil, so user selects gender
    @State private var instagramHandle: String = ""  // Stores the user's Instagram handle

    // MARK: - Dropdown Options
    let yearOptions = ["Freshman", "Sophomore", "Junior", "Senior", "Grad Student"]
    let genderOptions = ["Male", "Female", "Other"]

    var body: some View {
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

            // TODO: Add Gender Selection Here
            // - Similar to Year Selection 
            // - Use "Select Gender" placeholder

            // MARK: - Instagram Handle (Auto-Prefixed with "@")
            HStack {
                Text("@")
                    .bold()
                TextField("Instagram Handle", text: $instagramHandle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()

            // TODO: Save Button & Firebase Integration 
            // - Add a "Save Changes" button here

            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview for SwiftUI Canvas
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
