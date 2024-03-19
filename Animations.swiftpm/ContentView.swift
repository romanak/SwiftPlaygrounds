import SwiftUI

struct CorenerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CorenerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CorenerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    @State private var showBox = false
    @State private var isShowingRed = false
    @State private var dragText = CGSize.zero
    @State private var textEnabled = false
    @State private var dragBox = CGSize.zero
    @State private var toggleEnabled = false
    @State private var rotationDegrees = 0.0
    @State private var scaleAmount = 0.5
    @State private var opacityCircle = 1.0
    
    let letters = Array("Hello SwiftUI")
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 100, height: 100)
                
                if showBox {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .transition(.pivot)
                }
            }
            .onTapGesture {
                withAnimation {
                    showBox.toggle()
                }
            }
            
            VStack {
                Button("Tap Me") {
                    withAnimation {
                        isShowingRed.toggle()
                    }
                }
                if isShowingRed {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
            }
            
            
            HStack(spacing: 0) {
                ForEach(0..<letters.count, id: \.self) { num in
                    Text(String(letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(textEnabled ? .blue : .red)
                        .offset(dragText)
                        .animation(.linear.delay(Double(num) / 20), value: dragText)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { dragText = $0.translation }
                    .onEnded { _ in
                        dragText = .zero
                        textEnabled.toggle()
                    }
            )
            
            
            LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 150, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(dragBox)
                .gesture(
                    DragGesture()
                        .onChanged { dragBox = $0.translation }
                        .onEnded { _ in
                            withAnimation(.default) {
                                dragBox = .zero }
                        }
                )
            
            Button("Toggle Me") {
                toggleEnabled.toggle()
            }
            .frame(width: 100, height: 100)
            .background(toggleEnabled ? .blue : .red)
            .foregroundStyle(.white)
            .animation(.default, value: toggleEnabled)
            .clipShape(RoundedRectangle(cornerRadius: toggleEnabled ? 20 : 0))
            .animation(.easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true),
                       value: toggleEnabled
            )
            
            Button("Rotate Me") {
                withAnimation {
                    rotationDegrees += 360.0
                }
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 0, y: 1, z: 0))
            
            HStack {
                Stepper("Scale amount", value: $scaleAmount.animation(
                    .easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
                ), in: 1...3)
                Button("Scale Me") {
                    withAnimation {
                        scaleAmount += 0.5
                    }
                }
                .padding(40)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(scaleAmount)
            }
            
            Button("Pulsating") {
            }
            .padding(30)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(opacityCircle)
                    .opacity(2 - opacityCircle)
                    .animation(
                        .easeOut(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: opacityCircle
                    )
            )
            .onAppear {
                opacityCircle = 2
            }
            
        }
    }
}
