import Foundation

struct Address: Codable {
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        
        return true
    }
}

struct Product: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1 per cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.5 per cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
}

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _product = "product"
        case _address = "address"
    }
    
    var product = Product()
    
    var address = Address() {
        didSet {
            if let encoded = try? JSONEncoder().encode(address){
                UserDefaults.standard.set(encoded, forKey: "address")
            }
        }
    }
    
    init() {
        if let savedAddress = UserDefaults.standard.data(forKey: "address") {
            if let decoded = try? JSONDecoder().decode(Address.self, from: savedAddress) {
                address = decoded
                return
            }
        }
        
        address = Address()
    }
}
