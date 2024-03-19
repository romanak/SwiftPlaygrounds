import CreateML
import Foundation
import TabularData

func trainModel() -> MLTextClassifier {
    let datasetFile = URL(#fileLiteral(resourceName: "IMDBDataset.csv"))
    
    // Load CSV dataset into a dataframe
    let data = try! DataFrame(contentsOfCSVFile: datasetFile,
                              columns: ["review", "sentiment"],
                              rows: 0..<3000)
    print(data.description)
    
    // Split the dataframe into train and test subsets
    let (trainData, testData) = data.stratifiedSplit(on: "sentiment",
                                                     by: 0.8,
                                                     randomSeed: 0)
    print("Training data shape: \(trainData.shape)")
    print("Testing data shape: \(testData.shape)")
    
    // Parameters for the model
    let params = MLTextClassifier.ModelParameters(validation: .split(strategy: .automatic),
                                                  algorithm: .maxEnt(revision: 1),
                                                  language: .english)
    
    // Train the classifier
    let sentimentClassifier = try! MLTextClassifier(trainingData: trainData,
                                                    textColumn: "review",
                                                    labelColumn: "sentiment",
                                                    parameters: params)
    
    // Training and validation errors
    print("Training accuracy: \(1.0 - sentimentClassifier.trainingMetrics.classificationError)")
    print("Validation accuracy: \(1.0 - sentimentClassifier.validationMetrics.classificationError)")
    
    // Test the model on the testing subset
    let evaluationMetrics = sentimentClassifier.evaluation(on: testData, textColumn: "review", labelColumn: "sentiment")
    print("Testing accuracy: \(1.0 - evaluationMetrics.classificationError)")
    
    return sentimentClassifier    
}

func saveModel(model: MLTextClassifier, name: String) {
    let doc = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
    let url = doc.appendingPathComponent(name)
    let metadata = MLModelMetadata(author: "Roman Akchurin", shortDescription: "A model trained to predict sentiment in movie reviews.", version: "1.0")

    do {
        try model.write(to: url, metadata: metadata)
        print("Model successfully saved to \(url)")
    } catch {
        print(error.localizedDescription)
    }
}

let model = trainModel()
saveModel(model: model, name: "SentimentClassifier.mlmodel")

 
