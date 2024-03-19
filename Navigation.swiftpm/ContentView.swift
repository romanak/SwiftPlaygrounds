import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
        
        path = NavigationPath()
    }
    
    func save() {
        guard let representation = path.codable else { return }
        
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}

struct DetailView: View {
    var number: Int
    @Binding var pathStore: PathStore
    
    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1..<1000))
            .navigationTitle("Number: \(number)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.blue)
            .toolbarColorScheme(.dark)
//            .toolbar(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Home") {
                        pathStore.path = NavigationPath()
                    }
                }
            }
    }
}

struct Student: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var age: Int
}

struct ContentView: View {
    var students = [Student(name: "Roman", age: 25), Student(name: "George", age: 23)]
    
    @State private var pathStore = PathStore()
    
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0, pathStore: $pathStore)
            List(students) { student in
                NavigationLink(student.name, value: student)    
            }
            List {
                ForEach(0..<2) { i in
                    NavigationLink("Select String: \(i)", value: String(i))    
                }
            }
            .navigationDestination(for: Int.self) { i in
                DetailView(number: i, pathStore: $pathStore)
            }
            .navigationDestination(for: Student.self) { student in
                Text("You selected \(student.name) with age \(student.age).")    
            }
            .navigationDestination(for: String.self) { selection in
                Text("You selected the string \(selection).")    
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Tap Me") {
                        // button action code
                    }
                    
                    Button("Or Tap Me") {
                        // button action code
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}
