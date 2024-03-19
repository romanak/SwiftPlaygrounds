import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
            .padding()
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionCount = 1
    @State private var showingFinalResult = false
    @State private var rotationDegrees = [0.0, 0.0, 0.0]
    @State private var answer: Int?
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3) { number in
                        Button {
                            // flag was tapped
                            withAnimation {
                                rotationDegrees[number] += 360
                                answer = number
                                flagTapped(number)
                            }
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(.degrees(rotationDegrees[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity(getOpacity(for: number))
                        .scaleEffect(getScale(for: number))
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                if questionCount >= 8 {
                    scoreTitle = "Game Over!"
                    showingFinalResult = true
                } else {
                    askQuestion()
                }
            }
        } message: {
            Text("Your score is \(userScore)")
        }
        .alert(scoreTitle, isPresented: $showingFinalResult) {
            Button("Restart the Game", action: restartGame)
        } message: {
            Text("Your score is \(userScore)")
        }
    }
    
    func getScale(for index: Int) -> Double {
        guard let answerTapped = answer else { return 1.0 }
        return index == answerTapped ? 1.0 : 0.5
    }
    
    func getOpacity(for index: Int) -> Double {
        guard let answerTapped = answer else { return 1.0 }
        return index == answerTapped ? 1.0 : 0.25
    }
    
    struct FlagImage: View {
        let country: String
        var body: some View {
            Image(country)
            
                .resizable()
            .aspectRatio(2.0 / 1.0, contentMode: .fit)
                .containerRelativeFrame(.vertical) { height, axis in
                    height * 0.2
                }
                
//                .containerRelativeFrame(.horizontal) { width, axis in
//                    width * 0.6
//                }
            
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])."
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        
        withAnimation {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            questionCount += 1
            answer = nil
        }
    }
    
    func restartGame() {
        questionCount = 0
        userScore = 0
        askQuestion()
    }
    
}
