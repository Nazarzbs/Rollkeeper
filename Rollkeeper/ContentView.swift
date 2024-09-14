//
//  ContentView.swift
//  Rollkeeper
//
//  Created by Nazar on 13/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    
    @State private var disableButton = false
    
    @State private var roll1 = false
    @State private var result1 = 0
    @State private var roll2 = false
    @State private var result2 = 0
    @State private var roll3 = false
    @State private var result3 = 0
    @State private var roll4 = false
    @State private var result4 = 0
    @State private var total = 0
    
    @State private var diceValue = 1
    @State var isAnimating = false
    
    @State private var isRolling = false
    @State private var results: [Int] = []
    
    var body: some View {
        ZStack {
            // Cool green gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.498, green: 0.863, blue: 0.690, alpha: 1)),  // Light green
                    Color(#colorLiteral(red: 0.106, green: 0.678, blue: 0.506, alpha: 1))   // Darker cool green
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()  // Make sure the background covers the entire view
            
            VStack {
                Spacer()
                
                Button {
                    
                    withAnimation() {
                        buttonTapped()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.95),   // Central glossy highlight
                                        Color(#colorLiteral(red: 0.9, green: 0.9, blue: 0.95, alpha: 1)),   // Soft outer pearly color
                                        Color(#colorLiteral(red: 0.75, green: 0.75, blue: 0.85, alpha: 1))  // Slight darker edge
                                    ]),
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 120
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                            .frame(width: 180, height: 80)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)  // Soft shadow for depth
                            .shadow(color: Color.white.opacity(0.5), radius: 10, x: -5, y: -5)  // Light highlight shadow for more 3D effect
                        
                        Text("ROLL")
                            .foregroundColor(.gray.opacity(0.8))
                            .font(.system(size: 24))
                            .bold()
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)  // Slight shadow for text to stand out
                    }
                }
                .disabled(disableButton)
                
                Spacer()
                
                dice
            }
            .onChange(of: result1) {
                total = result1 + result2 + result3 + result4
                if total != 0 {
                    vm.addDataToUser(total)
                    disableButton = false
                }
            }
            .padding(.bottom)
        }
    }
    
    func rollDice() {
        isRolling = true
        var flickerValues: [Int] = []
        
        // Flick through random dice values before settling on the final one
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if flickerValues.count > 10 {
                timer.invalidate()
                isRolling = false
                let finalValue = Int.random(in: 1...6)
                diceValue = finalValue
                results.append(finalValue)  // Store the result
            } else {
                diceValue = Int.random(in: 1...6)
                flickerValues.append(diceValue)
                isAnimating = false
            }
        }
    }
    
    func createDiceFaceTexture(number: Int) -> UIImage {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // Fill the background with black
            UIColor.black.setFill()
            cgContext.fill(CGRect(origin: .zero, size: size))
            
            // Set up the shadow for the dots
            cgContext.setShadow(offset: CGSize(width: 2, height: 2), blur: 5, color: UIColor.gray.cgColor)
            
            // Set up the dot color and size
            UIColor.white.setFill()  // White dots
            UIColor.white.setStroke()  // White stroke around dots (optional)
            let dotSize = CGSize(width: 40, height: 40)
            
            // Define the positions for the dots using CGPoint
            let positions: [[CGPoint]] = [
                [],  // 0 (unused)
                [CGPoint(x: 100, y: 100)],  // 1
                [CGPoint(x: 50, y: 50), CGPoint(x: 150, y: 150)],  // 2
                [CGPoint(x: 50, y: 50), CGPoint(x: 100, y: 100), CGPoint(x: 150, y: 150)],  // 3
                [CGPoint(x: 50, y: 50), CGPoint(x: 150, y: 50), CGPoint(x: 50, y: 150), CGPoint(x: 150, y: 150)],  // 4
                [CGPoint(x: 50, y: 50), CGPoint(x: 150, y: 50), CGPoint(x: 50, y: 150), CGPoint(x: 150, y: 150), CGPoint(x: 100, y: 100)],  // 5
                [CGPoint(x: 50, y: 50), CGPoint(x: 150, y: 50), CGPoint(x: 50, y: 150), CGPoint(x: 150, y: 150), CGPoint(x: 50, y: 100), CGPoint(x: 150, y: 100)]  // 6
            ]
            
            // Draw the dots with shadow and stroke
            for position in positions[number] {
                let rect = CGRect(
                    origin: CGPoint(
                        x: position.x - dotSize.width / 2,
                        y: position.y - dotSize.height / 2
                    ),
                    size: dotSize
                )
                
                // Draw the filled dot
                cgContext.fillEllipse(in: rect)
                
                // Add stroke around the dot (optional)
                cgContext.setLineWidth(3)  // Adjust stroke width
                cgContext.strokeEllipse(in: rect)
            }
        }
    }
    
    private var dice: some View {
        VStack(spacing: 50) {
            HStack {
                DiceView(
                    size: vm.numberOfDiceSelected == 1 ? 140 : 120,
                    roll: $roll1,
                    result: $result1
                )
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Dice 1")
                .accessibilityValue(result1 > 0 ? "\(result1)" : "")
                if vm.numberOfDiceSelected > 1 {
                    DiceView(size: 120, roll: $roll2, result: $result2)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Dice 2")
                        .accessibilityValue(result2 > 0 ? "\(result2)" : "")
                }
            }
            HStack {
                if vm.numberOfDiceSelected > 2 {
                    DiceView(size: 120, roll: $roll3, result: $result3)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Dice 3")
                        .accessibilityValue(result3 > 0 ? "\(result3)" : "")
                }
                if vm.numberOfDiceSelected > 3 {
                    DiceView(size: 120, roll: $roll4, result: $result4)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Dice 4")
                        .accessibilityValue(result4 > 0 ? "\(result4)" : "")
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 40)
    }
}

extension ContentView {
    private func buttonTapped() {
        roll1 = true
        roll2 = vm.numberOfDiceSelected > 1 ? true : false
        roll3 = vm.numberOfDiceSelected > 2 ? true : false
        roll4 = vm.numberOfDiceSelected > 3 ? true : false
        result1 = 0
        result2 = 0
        result3 = 0
        result4 = 0
        total = 0
        disableButton = true
    }
}

#Preview {
    ContentView()
}

