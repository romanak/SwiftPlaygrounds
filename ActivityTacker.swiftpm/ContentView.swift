import SwiftUI

struct ContentView: View {
    @State private var activities = Activities()
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities.items) { activity in 
                    NavigationLink(value: activity) {
                        HStack {
                            Text(activity.title)
                            Spacer()
                            Text(String(activity.count))
                        }
                    }
                }
                .onDelete { offsets in
                    activities.items.remove(atOffsets: offsets)
                }
            }
            .navigationTitle("Activity Tracker")
            .navigationDestination(for: Activity.self) { activity in
                ActivityDetailView(activity: activity, activities: activities)
            }
            .toolbar { 
                Button("Add Activity", systemImage: "plus") { 
                    showAddSheet = true
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddActivityView(activities: activities)
            }
        }
    }
}
