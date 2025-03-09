import SwiftUI
import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit
import FirebaseAuth

struct MyOrdersView: View {
    //Placeholder Tasks
    @State var taskholder = pullOrder(taskName: "First Task Placeholder", taskDescription: "Placeolder", taskAmount: 5, taskTime: nil, taskLocation: nil)
    @State var task1: pullOrder?
    @State var task2: pullOrder?
    @State var task3: pullOrder?
    
    //Data Structure to put firebase data into
    class pullOrder {
        var taskName: String
        var taskDescription: String
        var taskAmount: Int
        var taskTime: String? = nil
        var taskLocation: String? = nil
        init(taskName: String, taskDescription: String, taskAmount: Int, taskTime: String?, taskLocation: String?) {
            self.taskName = taskName
            self.taskDescription = taskDescription
            self.taskAmount = taskAmount
            self.taskTime = taskTime
            self.taskLocation = taskLocation
        }
    }
    
    //Display Tasks
    var body: some View {
        Text("My Orders")
            .font(.largeTitle)
            .padding()
            .bold()
        
        VStack{
            //change to task !=nil later
            if task1 == nil{
                Text("First Task:")
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            if task2 == nil {
                Text("Second Task:")
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            if task3 == nil{
                Text("Third Task:")
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .padding()
        
    }
//    
//    @State private var selectedTimeOption = "ASAP"
//    @State private var taskName = ""
//    @State private var taskDescription = ""
//    @State private var price = ""
//    @State private var location = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Default SF location
//    @Environment(\.presentationMode) var presentationMode
//    @State private var scheduledDate = Date()
//    @State private var showDatePicker = false  // Controls visibility of calendar popup
//    private func createPulledTask() {
//        //learning how to get firebase data
//        
//            guard let user = Auth.auth().currentUser else {
//                print("User not authenticated")
//                return
//            }
//
//            let db = Firestore.firestore()
//            let userRef = db.collection("users").document(user.email ?? "")
//
//            userRef.getDocument { (document, error) in
//                guard let document = document, document.exists, let university = document.data()?["university"] as? String else {
//                    print("University not found")
//                    return
//                }
//
//                let tasksRef = db.collection(university)
//                tasksRef.getDocuments { (snapshot, error) in
//                    if let error = error {
//                        print("Error fetching university tasks: \(error.localizedDescription)")
//                        return
//                    }
//
//                    var newTaskID: String
//                    repeat {
//                        newTaskID = UUID().uuidString
//                    } while snapshot?.documents.contains(where: { $0.documentID == newTaskID }) == true
//
//                    let taskData: [String: Any] = [
//                        "title": taskName,
//                        "description": taskDescription,
//                        "location": ["latitude": location.latitude, "longitude": location.longitude],
//                        "price": price,
//                        "time": selectedTimeOption == "ASAP" ? "ASAP" : formattedDate(scheduledDate),
//                        "completed": false,
//                        "people": [],
//                        "createdAt": FieldValue.serverTimestamp()
//                    ]
//
//                    // Add task to university collection
//                    tasksRef.document(newTaskID).setData(taskData) { error in
//                        if let error = error {
//                            print("Error creating task: \(error.localizedDescription)")
//                            return
//                        }
//
//                        // Add task to user's orders map
//                        userRef.updateData(["orders.\(newTaskID)": taskData]) { error in
//                            if let error = error {
//                                print("Error updating user orders: \(error.localizedDescription)")
//                            } else {
//                                print("Task successfully created and linked to user")
//                                
//                                // Go back to HomeView after successful task creation
//                                presentationMode.wrappedValue.dismiss()
//                            }
//                        }
//                    }
//                }
//            
//        }
//    }
//    
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd/yyyy HH:mm"
//        return formatter.string(from: date)
//    }



}

