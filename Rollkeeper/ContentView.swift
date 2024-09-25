//
//  ContentView.swift
//  Rollkeeper
//
//  Created by Nazar on 13/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var disableButton = false
    @State private var numberOfDiceSelected = 1
    
    @State private var roll1 = false
    @State private var result1 = 0
    @State private var roll2 = false
    @State private var result2 = 0
    @State private var roll3 = false
    @State private var result3 = 0
    @State private var roll4 = false
    @State private var result4 = 0
    @State private var roll5 = false
    @State private var result5 = 0
    @State private var roll6 = false
    @State private var result6 = 0
    @State private var total = 0
    
    @State var disableDice = false
    
    @State private var diceValue = 1
    @State var isAnimating = false
    
    @State private var results: [Int] = []
    
    var body: some View {
        NavigationStack {
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
                    
                    dice
                    
                    HStack {
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
                                    .frame(width: 120, height: 80)
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
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            
                            withAnimation() {
                                
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
                                    .frame(width: 120, height: 80)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)  // Soft shadow for depth
                                    .shadow(color: Color.white.opacity(0.5), radius: 10, x: -5, y: -5)  // Light highlight shadow for more 3D effect
                                
                                Text("Results")
                                    .foregroundColor(.gray.opacity(0.8))
                                    .font(.system(size: 24))
                                    .bold()
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)  // Slight shadow for text to stand out
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .onChange(of: result1) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        total = result1 + result2 + result3 + result4 + result5 + result6
                        
                        if total != 0 {
                            
                            disableButton = false
                            
                        }
                    }
                }
                .onChange(of: result2) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        total = result1 + result2 + result3 + result4 + result5 + result6
                        if total != 0 {
                            
                            disableButton = false
                        }
                    }
                }
                .onChange(of: result3) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        total = result1 + result2 + result3 + result4 + result5 + result6
                        if total != 0 {
                            
                            disableButton = false
                        }
                    }
                }
                .onChange(of: result4) { DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    total = result1 + result2 + result3 + result4 + result5 + result6
                    if total != 0 {
                        
                        disableButton = false
                    }
                }
                    
                }
                .onChange(of: result5) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        total = result1 + result2 + result3 + result4 + result5 + result6
                        if total != 0 {
                            
                            disableButton = false
                        }
                    }
                }
                .onChange(of: result6) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        total = result1 + result2 + result3 + result4 + result5 + result6
                        if total != 0 {
                            
                            disableButton = false
                        }
                    }
                }
                .padding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // Provide options for the number of dice
                        ForEach(1...6, id: \.self) { number in
                            Button(action: {
                                disableDice = true
                                withAnimation(.bouncy) {
                                    
                                    numberOfDiceSelected = number
                                    result1 = 0
                                    result2 = 0
                                    result3 = 0
                                    result4 = 0
                                    result5 = 0
                                    result6 = 0
                                }
                            }) {
                                HStack {
                                    Text("\(number) Dice")
                                    
                                    // Show a checkmark next to the currently selected number
                                    if numberOfDiceSelected == number {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text("\(numberOfDiceSelected) -")
                            Image(systemName: "dice")
                        }
                        .foregroundColor(.black)  // Set the color to black
                        .bold()
                    }
                }
            }
            .navigationTitle(total > 0 ? "Total: \(total)" : "Dice Roller")
        }
    }
    
    private var dice: some View {
        VStack(spacing: 50) {
            // First row for Dice 1 and Dice 2
            HStack {
                DiceView(
                    size: numberOfDiceSelected == 1 ? 140 : 120,
                    roll: $roll1,
                    result: $result1, disableDice: $disableDice
                )
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Dice 1")
                .accessibilityValue(result1 > 0 ? "\(result1)" : "")
                
                if numberOfDiceSelected > 1 {
                    DiceView(size: 120, roll: $roll2, result: $result2, disableDice: $disableDice)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Dice 2")
                        .accessibilityValue(result2 > 0 ? "\(result2)" : "")
                }
            }
            
            // Second row for Dice 3 and Dice 4
            HStack {
                if numberOfDiceSelected > 2 {
                    DiceView(size: 120, roll: $roll3, result: $result3, disableDice: $disableDice)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Dice 3")
                        .accessibilityValue(result3 > 0 ? "\(result3)" : "")
                }
                if numberOfDiceSelected > 3 {
                    DiceView(size: 120, roll: $roll4, result: $result4, disableDice: $disableDice)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Dice 4")
                        .accessibilityValue(result4 > 0 ? "\(result4)" : "")
                }
            }
            
            // Third row for Dice 5 and Dice 6
            HStack {
                if numberOfDiceSelected > 4 {
                    DiceView(size: 120, roll: $roll5, result: $result5, disableDice: $disableDice)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Dice 5")
                        .accessibilityValue(result5 > 0 ? "\(result5)" : "")
                }
                if numberOfDiceSelected > 5 {
                    DiceView(size: 120, roll: $roll6, result: $result6, disableDice: $disableDice)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Dice 6")
                        .accessibilityValue(result6 > 0 ? "\(result6)" : "")
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 40)
    }
}

extension ContentView {
    private func buttonTapped() {
        disableButton = true
        roll1 = true
        roll2 = numberOfDiceSelected > 1 ? true : false
        roll3 = numberOfDiceSelected > 2 ? true : false
        roll4 = numberOfDiceSelected > 3 ? true : false
        roll5 = numberOfDiceSelected > 4 ? true : false
        roll6 = numberOfDiceSelected > 5 ? true : false
        result1 = 0
        result2 = 0
        result3 = 0
        result4 = 0
        result5 = 0
        result6 = 0
    }
}

#Preview {
    ContentView()
}

