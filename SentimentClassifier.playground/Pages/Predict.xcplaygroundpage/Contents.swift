import CoreML

class ModelInput: MLFeatureProvider {
    var text: String
    
    var featureNames: Set<String> {
        get {
            ["text"]
        }
    }
    
    init(text: String) {
        self.text = text
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "text" {
            return MLFeatureValue(string: text)
        }
        
        return nil
    }
}

class ModelOutput : MLFeatureProvider {
    private let provider : MLFeatureProvider
    /// Text label as string value
    var label: String {
        return self.provider.featureValue(for: "label")!.stringValue
    }
    
    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }
    
    init(label: String) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["label" : MLFeatureValue(string: label)])
    }
    
    init(features: MLFeatureProvider) {
        self.provider = features
    }
}

class SentimentClassifier {
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
        var url = doc.appendingPathComponent("SentimentClassifier.mlmodel")
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

func predictSentiment(text: String) -> String? {
    var sentimentLabel: String? = nil
    do {
        let sentimentClassifier = try SentimentClassifier()
        let input = ModelInput(text: text)
        let sentimentPrediction = try sentimentClassifier.prediction(input: input)
        sentimentLabel = sentimentPrediction.label
    } catch {
        print(error.localizedDescription)
    }
    return sentimentLabel
}

if let sentimentPrediction = predictSentiment(text: "very good") {
    print(sentimentPrediction)
} else {
    print("Prediction failed.")
}

