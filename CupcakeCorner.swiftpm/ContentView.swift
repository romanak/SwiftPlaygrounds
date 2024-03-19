import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.product.type) {
                        ForEach(Product.types.indices, id: \.self) {
                            Text(Product.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.product.quantity)", value: $order.product.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.product.specialRequestEnabled)
                    
                    if order.product.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.product.extraFrosting)
                        
                        Toggle("Add extra sprinkles", isOn: $order.product.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink("Delivery details") {
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}
