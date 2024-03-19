import SwiftUI

struct Move: View {
    struct Option {
        let name: String
        let symbol: String
    }
    
    let moves = [
        Option(name: "Rock", symbol: "mountain.2"),
        Option(name: "Paper", symbol: "doc"),
        Option(name: "Scissors", symbol: "scissors")
    ]
    
    let index: Int
    
    var body: some View {
        VStack {
            Image(systemName: moves[index].symbol)
                .font(.system(size: 30))
                .padding(5)
            Text(moves[index].name)
        }
        .frame(width: 90, height: 90)
    }
}

struct ContentView: View {
    @State private var turnCount = 0
    @State private var score = 0
    @State private var appChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var showScore = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("My move:")
            Move(index: appChoice)
            
            Spacer()
            
            Text("To \(shouldWin ? "WIN" : "LOSE"), you choose:")
            HStack {
                ForEach(0..<3) { choice in
                    Button {
                        moveTapped(choice)
                    } label: {
                        Move(index: choice)
                    }
                    .buttonStyle(.bordered)
                    .padding(5)
                }
            }
            
            Spacer()
            Text("Your score: \(score) out of \(turnCount)")
            
        }
        .alert("Game Over!", isPresented: $showScore) {
            Button("Restart the Game", action: restart)
        } message: {
            Text("Your score is \(score).")
        }
    }
    
    func moveTapped(_ userChoice: Int) {
        turnCount += 1
        let i = shouldWin ? 1 : -1
        if (appChoice + i) % 3 == userChoice {
            score += 1
        }
        if turnCount == 10 {
            showScore = true
        } else {
            appChoice = Int.random(in: 0...2)
            shouldWin = Bool.random()
        }
    }
    
    func restart() {
        score = 0
        turnCount = 0
        appChoice = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}
