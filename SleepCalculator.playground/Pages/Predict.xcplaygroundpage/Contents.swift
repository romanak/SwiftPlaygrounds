import CoreML

class ModelInput : MLFeatureProvider {
    var wake: Double
    var estimatedSleep: Double
    var coffee: Double
    
    var featureNames: Set<String> {
        get {
            return ["wake", "estimatedSleep", "coffee"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "wake") {
            return MLFeatureValue(double: wake)
        }
        if (featureName == "estimatedSleep") {
            return MLFeatureValue(double: estimatedSleep)
        }
        if (featureName == "coffee") {
            return MLFeatureValue(double: coffee)
        }
        return nil
    }
    
    init(wake: Double, estimatedSleep: Double, coffee: Double) {
        self.wake = wake
        self.estimatedSleep = estimatedSleep
        self.coffee = coffee
    }
    
}

class ModelOutput : MLFeatureProvider {
    
    /// Source provided by CoreML
    private let provider : MLFeatureProvider
    
    /// actualSleep as double value
    var actualSleep: Double {
        return self.provider.featureValue(for: "actualSleep")!.doubleValue
    }
    
    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }
    
    init(actualSleep: Double) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["actualSleep" : MLFeatureValue(double: actualSleep)])
    }
    
    init(features: MLFeatureProvider) {
        self.provider = features
    }
}

class SleepCalculator {
    let model: MLModel
    
    init(model: MLModel) {
        self.model = model
    }
    
    convenience init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
            try self.init(contentsOf: type(of:self).urlOfModel, configuration: configuration)
        }
    
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
            try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
        }
    
    class var urlOfModel: URL {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
        var url = doc.appendingPathComponent("SleepCalculator.mlmodel")
        return try! MLModel.compileModel(at: url)
    }
    
    func prediction(input: ModelInput) throws -> ModelOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }
    
    func prediction(input: ModelInput, options: MLPredictionOptions) throws -> ModelOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return ModelOutput(features: outFeatures)
    }
}

func predictSleep(wake: Double, estimatedSleep: Double, coffee: Double) -> Double? {
    // when to wake up: # seconds from midnight
    // estimated sleep: # hours of desired sleep
    // coffee amount: # cups of coffee user drinks per day
    var actualSleep: Double? = nil
    
    do {
        let sleepCalculator = try SleepCalculator()
        let input = ModelInput(wake: wake, estimatedSleep: estimatedSleep, coffee: coffee)
        let sleepPrediction = try sleepCalculator.prediction(input: input)
        actualSleep = sleepPrediction.actualSleep
    } catch {
        print(error.localizedDescription)
    }
    return actualSleep
}

var components = DateComponents()
components.hour = 7
components.minute = 0

let wakeUp = Calendar.current.date(from: components) ?? Date.now

let sleepAmount = 8.0 // hours of desired sleep
let coffee = 1.0 // cups of coffee drank that day

let hour = (components.hour ?? 0) * 3600
let minute = (components.minute ?? 0) * 60

if let sleepPrediction = predictSleep(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: coffee) {
    let sleepTime = wakeUp - sleepPrediction
    print(sleepTime.formatted(date: .omitted, time: .shortened))
} else {
    print("Prediction failed.")
}
