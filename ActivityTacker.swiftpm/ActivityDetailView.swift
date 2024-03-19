import SwiftUI

struct ActivityDetailView: View {
    var activity: Activity
    var activities: Activities
    
    var updatedActivity: Activity {
        if let index = activities.getIndex(for: activity) {
            return activities.items[index]
        } else {
            return activity
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(updatedActivity.title)
                    .font(.title)
                Text(updatedActivity.description)
                    .font(.headline)
            }
            Text(String(updatedActivity.count))
                .font(.largeTitle)
                .padding()
            Button("Add Hour") {
                activities.increment(for: activity, by: 1)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    let programming = Activity(title: "Programming", description: "Programming SwiftUI")
    let activities = Activities()
    activities.add(programming)
    return ActivityDetailView(activity: programming, activities: activities)
}
