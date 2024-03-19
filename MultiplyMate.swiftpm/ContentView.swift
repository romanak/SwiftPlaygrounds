import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

extension Color {
    static var random: Color {
        return Color(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1)
        )
    }
}

struct GameSettingsView: View {
    @Binding var numbers: Int
    @Binding var questions: Int
    @Binding var isPresented: Bool
    var questionChoices = [5, 10, 20]
    
    var body: some View {
        VStack {
            HStack {
                Text("Numbers upper limit")
                Spacer()
                Image(systemName: "\(numbers).circle")
                Spacer()
                Stepper("Select numbers upper limit", value: $numbers, in: 2...12)
                    .labelsHidden()
            }
            
            HStack {
                Text("Number of questions")
                Spacer()
                Picker("Select number of questions", selection: $questions) {
                    
                    ForEach(questionChoices, id: \.self) {
                        Text("\($0)")
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
            }
            
            Button("Start Game") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct ContentView: View {
    @State private var showSettings = true
    @State private var score = 0
    @State private var upperLimit = 10
    @State private var maxQuestions = 5
    @State private var questionCount = 0
    @State private var number1 = 0
    @State private var number2 = 0
    @State private var correctAnswer = 0
    @State private var answerChoices = Set<Int>()
    @State private var showAlert = false
    
    
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Text("MultiplyMate")
                    .titleStyle()
                Spacer()
                Text("Your score: \(score)")
                    .titleStyle()
                Spacer()
                HStack{
                    Text("\(number1)")
                        .titleStyle()
                        .frame(width: 100, height: 100)
                        .background(Color.random)
                    Text("X")
                        .titleStyle()
                        .padding(20)
                    Text("\(number2)")
                        .titleStyle()
                        .frame(width: 100, height: 100)
                        .background(Color.random)
                    Text("=")
                        .titleStyle()
                        .padding(20)
                }
                .onAppear {
                    askQuestion()
                }
                
                HStack{
                    ForEach(Array(answerChoices).shuffled(), id: \.self) { choice in
                        Button {
                            checkAnswer(choice)
                            if questionCount >= maxQuestions {
                                showAlert = true
                            } else {
                                askQuestion()
                            }
                        } label: {
                            
                            Text("\(choice)")
                                .titleStyle()
                                .frame(width: 100, height: 100)
                                .background(Color.random)
                        }
                    }
                    
                }
                
                Spacer()
                Button("Go to Settings") {
                    showSettings = true
                }
            }
            .sheet(isPresented: $showSettings) {
                restartGame()
            } content: {
                GameSettingsView(numbers: $upperLimit, questions: $maxQuestions, isPresented: $showSettings)
            }
            .alert("Game over", isPresented: $showAlert) {
                Button("Restart Game") {
                    showSettings = true
                }
            } message: {
                Text("Your score is \(score)")
            }
        }
    }
    
    func getRandomNumber() -> Int {
        Int.random(in: 0...upperLimit)
    }
    
    func askQuestion() {
        number1 = getRandomNumber()
        number2 = getRandomNumber()
        correctAnswer = number1 * number2
        answerChoices = Set<Int>()
        answerChoices.insert(correctAnswer)
        while(answerChoices.count < 3) {
            answerChoices.insert(getRandomNumber() * getRandomNumber())
        }
        questionCount += 1
    }
    
    func checkAnswer(_ answer: Int) {
        if answer == correctAnswer {
            score += 1
        }
        
    }
    
    func restartGame(){
        score = 0
        questionCount = 0
        askQuestion()
    }
}
