import CoreML
import SwiftUI

// Note that we need to compile the model for use with Swift Playgrounds
// Look at `class var urlOfModelInThisBundle` of IMDB and SleepCalculator
// which are automtically generated in Xcode on Mac

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 0
    @State private var text = ""
    @State private var sentimentLabel = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Select time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    //                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    Picker("Select number of cups", selection: $coffeeAmount) {
                        ForEach(0..<11) {
                            Text("^[\($0) cup](inflect: true)")
                                .tag($0)
                        }
                    }
                }
                
                Section("Your ideal bedtime is") {
                    Text(calculateBedTime())
                        .font(.largeTitle.weight(.semibold))
                }
                
                Section("Enter text for sentiment analysis") {
                    TextField("Type your text here", text: $text)
                }
                
                Section("Sentiment Prediction") {
                    Text(sentimentLabel)
                        .font(.largeTitle.weight(.semibold))
                }
                
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Predict", action: predictSentiment)
            }
        }
        
    }
    
    func predictSentiment() {
        // Just for fun
        do {
            let config = MLModelConfiguration()
            let sentimentClassifier = try SentimentClassifier(configuration: config)
            let sentimentPrediction = try sentimentClassifier.prediction(input: SentimentClassifierInput(text: text))
            sentimentLabel = sentimentPrediction.label
        } catch {
            sentimentLabel = "Sorry, there was a problem with sentiment classifier."
        }
    }
    
    func calculateBedTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // when to wake up: # seconds from midnight
            // estimated sleep: # hours of desired sleep
            // coffee amount: # cups of coffee user drinks per day
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 3600
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
}
