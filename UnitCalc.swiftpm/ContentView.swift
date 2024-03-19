import SwiftUI

struct ContentView: View {
    @State private var sourceUnit = "m"
    @State private var outputUnit = "ft"
    @State private var sourceValue = 10.0
    @FocusState private var inputFieldIsFocused: Bool
    
    var outputLength: Double {
        var sourceMeasurement: Measurement<UnitLength>
        
        switch sourceUnit {
        case "m":
            sourceMeasurement = Measurement(value: sourceValue, unit: UnitLength.meters)
        case "km":
            sourceMeasurement = Measurement(value: sourceValue, unit: UnitLength.kilometers)
        case "ft":
            sourceMeasurement = Measurement(value: sourceValue, unit: UnitLength.feet)
        case "yd":
            sourceMeasurement = Measurement(value: sourceValue, unit: UnitLength.yards)
        case "mi":
            sourceMeasurement = Measurement(value: sourceValue, unit: UnitLength.miles)
        default:
            sourceMeasurement = Measurement(value: sourceValue, unit: UnitLength.meters)
        }
        
        switch outputUnit {
        case "m":
            return sourceMeasurement.converted(to: .meters).value
        case "km":
            return sourceMeasurement.converted(to: .kilometers).value
        case "ft":
            return sourceMeasurement.converted(to: .feet).value
        case "yd":
            return sourceMeasurement.converted(to: .yards).value
        case "mi":
            return sourceMeasurement.converted(to: .miles).value
        default:
            return sourceMeasurement.converted(to: .meters).value
        }
    }
    
    let lengthUnits = ["m", "km", "ft", "yd", "mi"]
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Value", value: $sourceValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputFieldIsFocused)
                }
                
                Section("Source Units") {
                    Picker("", selection: $sourceUnit) {
                        ForEach(lengthUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Output Units") {
                    Picker("", selection: $outputUnit) {
                        ForEach(lengthUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Text(outputLength, format: .number)
                }
            }
            .navigationTitle("UnitCalc")
            .toolbar {
                if inputFieldIsFocused {
                    Button("Done") {
                        inputFieldIsFocused = false
                    }
                }
            }
        }
    }
}
