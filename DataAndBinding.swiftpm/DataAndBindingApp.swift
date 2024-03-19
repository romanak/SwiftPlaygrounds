import SwiftData
import SwiftUI

@main
struct DataAndBindingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Student.self)
    }
}
