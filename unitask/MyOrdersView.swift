import SwiftUI
import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit
import FirebaseAuth

struct MyOrdersView: View {
    // MARK: - Placeholder Tasks
    @State var taskholder = pullOrder(taskName: "First Task Placeholder", taskDescription: "Placeolder", taskAmount: 5, taskTime: nil, taskLocation: nil)
    @State var task1: pullOrder?
    @State var task2: pullOrder?
    @State var task3: pullOrder?
    
    // MARK: - Data structure
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
    
    // MARK: - View ordered tasks
    var body: some View {
        Text("My Orders")
            .font(.largeTitle)
            .padding()
            .bold()
        
        VStack{
            //change to task !=nil later
            if task1 == nil{
                Text(taskholder.taskName + ": " + taskholder.taskDescription)
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            if task2 == nil {
                Text("Second Task: ")
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            if task3 == nil{
                Text("Third Task: ")
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .padding()
        
    }
    


}

