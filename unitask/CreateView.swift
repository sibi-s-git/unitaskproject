import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit
import FirebaseAuth

struct CreateView: View {
    @Environment(\.presentationMode) var presentationMode  // To go back to HomeView

    @State private var taskName = ""
    @State private var taskDescription = ""
    @State private var location = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Default SF location
    @State private var showingMapSheet = false
    @State private var price = ""
    @State private var selectedTimeOption = "ASAP"
    @State private var scheduledDate = Date()
    @State private var showDatePicker = false  // Controls visibility of calendar popup
    @State private var showLimitAlert = false // Alert for task limit
    @State private var showValidationAlert = false // Alert for missing fields
    @State private var showMaxTaskBanner = false // Banner alert for 3-task limit

    let timeOptions = ["ASAP", "Scheduled"]

    var body: some View {
        VStack {
            if showMaxTaskBanner {
                Text("⚠️ Only 3 ongoing tasks at a time.")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
            }
            
            ScrollView {
                VStack(spacing: 15) {
                    TextField("Task Name", text: $taskName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Task Description", text: $taskDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: { showingMapSheet.toggle() }) {
                        Text("Select Location")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .sheet(isPresented: $showingMapSheet) {
                        MapSelectionView(selectedLocation: $location)
                    }
                    
                    HStack {
                        Text("$")
                            .font(.title)
                            .padding(.leading)
                        TextField("Amount", text: $price)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                    Picker("Time", selection: $selectedTimeOption) {
                        ForEach(timeOptions, id: \.self) { Text($0) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if selectedTimeOption == "Scheduled" {
                        Button(action: { showDatePicker.toggle() }) {
                            HStack {
                                Text(formattedDate(scheduledDate)) // Show selected date as text
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "calendar")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                        .padding()

                        if showDatePicker {
                            DatePicker("Select Date & Time", selection: $scheduledDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                        }
                    }
                    
                    Button(action: validateFields) {
                        Text("Create Task")
                            .frame(width: 250, height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .alert(isPresented: $showLimitAlert) {
                        Alert(title: Text("Task Limit Reached"),
                              message: Text("You cannot have more than 3 uncompleted tasks."),
                              dismissButton: .default(Text("OK")))
                    }
                    .alert(isPresented: $showValidationAlert) {
                        Alert(title: Text("Missing Fields"),
                              message: Text("Please fill out all fields before creating a task."),
                              dismissButton: .default(Text("OK")))
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Create Task")
    }

    /// **🔹 Validates that all fields are filled before proceeding**
    private func validateFields() {
        if taskName.trimmingCharacters(in: .whitespaces).isEmpty ||
            taskDescription.trimmingCharacters(in: .whitespaces).isEmpty ||
            price.trimmingCharacters(in: .whitespaces).isEmpty ||
            (selectedTimeOption == "Scheduled" && scheduledDate < Date()) {
            showValidationAlert = true
        } else {
            checkTaskLimit() // Proceed to check task limit
        }
    }

    /// **🔹 Checks if the user already has 3 uncompleted tasks**
    private func checkTaskLimit() {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.email ?? "")

        userRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let orders = document.data()?["orders"] as? [String: [String: Any]] else {
                print("Error fetching user tasks or no tasks found.")
                return
            }

            // Count uncompleted tasks
            let uncompletedTasks = orders.values.filter { ($0["completed"] as? Bool) == false }.count

            if uncompletedTasks >= 3 {
                showLimitAlert = true // **Show alert popup**
                showMaxTaskBanner = true // **Show red warning banner at the top**
            } else {
                createTask() // **Proceed with task creation**
            }
        }
    }

    private func createTask() {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.email ?? "")

        userRef.getDocument { (document, error) in
            guard let document = document, document.exists, let university = document.data()?["university"] as? String else {
                print("University not found")
                return
            }

            let tasksRef = db.collection(university)
            tasksRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching university tasks: \(error.localizedDescription)")
                    return
                }

                var newTaskID: String
                repeat {
                    newTaskID = UUID().uuidString
                } while snapshot?.documents.contains(where: { $0.documentID == newTaskID }) == true

                let taskData: [String: Any] = [
                    "title": taskName,
                    "description": taskDescription,
                    "location": ["latitude": location.latitude, "longitude": location.longitude],
                    "price": price,
                    "time": selectedTimeOption == "ASAP" ? "ASAP" : formattedDate(scheduledDate),
                    "completed": false,
                    "people": [],
                    "createdAt": FieldValue.serverTimestamp()
                ]

                // Add task to university collection
                tasksRef.document(newTaskID).setData(taskData) { error in
                    if let error = error {
                        print("Error creating task: \(error.localizedDescription)")
                        return
                    }

                    // Add task to user's orders map
                    userRef.updateData(["orders.\(newTaskID)": taskData]) { error in
                        if let error = error {
                            print("Error updating user orders: \(error.localizedDescription)")
                        } else {
                            print("Task successfully created and linked to user")
                            
                            // Go back to HomeView after successful task creation
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        return formatter.string(from: date)
    }
}
