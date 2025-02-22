import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Home View!")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: AccountView()) {
                    Text("Go to Account")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }

                NavigationLink(destination: CreateView()) {
                    Text("Create Task")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }

                NavigationLink(destination: MyOrdersView()) {
                    Text("My Orders")
                        .frame(width: 200, height: 50)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }

                NavigationLink(destination: TasksView()) {
                    Text("Find Tasks")
                        .frame(width: 200, height: 50)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .navigationTitle("Home")
        }
    }
}
