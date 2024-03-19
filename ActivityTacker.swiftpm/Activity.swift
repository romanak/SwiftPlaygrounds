import Foundation

struct Activity: Identifiable, Hashable, Codable {
    var title: String
    var description: String
    
    var id = UUID()
    var count = 0
    
    mutating func increment(by amount: Int) {
        count += amount
    }
}

@Observable
class Activities {
    var items = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items") {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: savedItems) {
                items = decoded
                return
            }
        }
        
        items = []
    }
    
    func add(_ activity: Activity) {
        items.append(activity)
    }
    
    func getIndex(for activity: Activity) -> Int? {
        let foundIndex = items.firstIndex { element in
            element.id == activity.id
        }
        
        if let index = foundIndex {
            return index
        }
        
        return nil
    }
    
    func increment(for activity: Activity, by amount: Int) {
        guard let index = getIndex(for: activity) else { return }
        
        items[index].increment(by: amount)
    }
}
