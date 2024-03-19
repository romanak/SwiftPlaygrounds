import Foundation
import CreateML
import TabularData

func trainModel() -> MLLinearRegressor {
    let datasetFile = URL(#fileLiteral(resourceName: "BetterRest.csv"))
    
    // Load CSV dataset into a dataframe
    let data = try! DataFrame(contentsOfCSVFile: datasetFile)
    print(data.description)
    
    // Split the dataframe into train and test subsets
    let (trainDataSlice, testDataSlice) = data.randomSplit(by: 0.9, seed: 0)
    let trainData = DataFrame(trainDataSlice)
    let testData = DataFrame(testDataSlice)
    
    print("Training data shape: \(trainData.shape)")
    print("Testing data shape: \(testData.shape)")
    
    // Parameters for the model
    let params = MLLinearRegressor.ModelParameters(validation: .split(strategy: .automatic))
    
    // Train the regressor
    let sleepRegressor = try! MLLinearRegressor(trainingData: data,
                                                targetColumn: "actualSleep",
                                                parameters: params)
    
    // Training and validation metrics
    print("Training metrics: \(sleepRegressor.trainingMetrics.description)")
    print("Validation metrics: \(sleepRegressor.validationMetrics.description)")
    
    // Test the model on the testing subset
    let evaluationMetrics = sleepRegressor.evaluation(on: testData)
    print("Testing metrics: \(evaluationMetrics.description)")
    
    return sleepRegressor    
}

func saveModel(model: MLLinearRegressor, name: String) {
    let doc = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
    let url = doc.appendingPathComponent(name)
    let metadata = MLModelMetadata(author: "Roman Akchurin", shortDescription: "A model trained to estimate sleep", version: "1.0")

    do {
        try model.write(to: url, metadata: metadata)
        print("Model successfully saved to \(url)")
    } catch {
        print(error.localizedDescription)
    }
}

let model = trainModel()
saveModel(model: model, name: "SleepCalculator.mlmodel")

 
