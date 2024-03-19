import SwiftUI

struct AddActivityView: View {
    var activities: Activities
    @State private var title = ""
    @State private var description = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationTitle("Add Activity")
            .toolbar {
                Button("Save") {
                    let activity = Activity(title: title, description: description)
                    activities.add(activity)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddActivityView(activities: Activities())
}
