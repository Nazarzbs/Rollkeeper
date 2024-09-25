//
//  DiceView.swift
//  Rollkeeper
//
//  Created by Nazar on 13/9/24.
//

import SwiftUI
import CoreHaptics

struct DiceView: View {
    let size: Double
    @Binding var roll: Bool
    @Binding var result: Int
    @Binding var disableDice: Bool
    
    @State private var engine: CHHapticEngine?
    
    @State private var horizontalPattern: [Int]
    @State private var verticalPattern: [Int]
    
    @State var dice: [DiceSide]
    
    @State private var rollCount = 5
    
    var body: some View {
        ZStack {
            ForEach(dice, id: \.number) {
                DiceSideView(side: $0, size: size)
                
            }
        }
        .frame(width: size, height: size)
        .onChange(of: roll) {
            if roll {
                print("Roll")
                rotateRandom()
                //                disableDice = true
            }
        }
        .onAppear(perform: prepareHaptics)
        //        .onTapGesture {
        //            if !disableDice {
        //                roll = true
        //                disableDice = true
        //            }
        //        }
    }
    
    init(size: Double, roll: Binding<Bool>, result: Binding<Int>, disableDice: Binding<Bool>) {
        self.size = size
        self._roll = roll
        self._result = result
        self._disableDice = disableDice
        
        var horPattern = [6, 5, 1, 2]
        var verPattern = [6, 4, 1, 3]
        
        for _ in 0...Int.random(in: 0...3) {
            horPattern.move(fromOffsets: .init(integer: 0), toOffset: 4)
            verPattern.remove(atOffsets: .init([0, 2]))
            verPattern.insert(horPattern[0], at: 0)
            verPattern.insert(horPattern[2], at: 2)
        }
        
        var allSides = [DiceSide]()
        
        // Create the dice sides
        (1...6).forEach { number in
            let side = DiceSide(number: number, degrees: -90, offset: size, anchor: .leading, rotateHorizontally: true)
            allSides.append(side)
        }
        if let facingSideIndex = allSides.firstIndex(where: { $0.number == horPattern[0] }) {
            allSides[facingSideIndex].degrees = 0
            allSides[facingSideIndex].offset = 0
            
        }
        
        _horizontalPattern = State(wrappedValue: horPattern)
        _verticalPattern = State(wrappedValue: verPattern)
        _dice = State(wrappedValue: allSides)
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(size: 150, roll: .constant(false), result: .constant(1), disableDice: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}

// MARK: - FUNCTIONS

extension DiceView {
    private func rotateRandom() {
        if Bool.random() {
            self.rotateHorizontally()
        } else {
            self.rotateVertically()
        }
    }
    
    private func rotateDice(_ facingSideIndex: Int, _ nextSideIndex: Int) {
        // Trigger haptic and start the animation
        rollHaptic()
        withAnimation(.linear(duration: 0.3)) {
            self.dice[facingSideIndex].degrees += 90
            self.dice[facingSideIndex].offset -= self.size
            
            self.dice[nextSideIndex].degrees += 90
            self.dice[nextSideIndex].offset -= self.size
        }
        
        // Wait for animation to complete
        if self.rollCount > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.rollCount -= 1
                self.rotateRandom() // Continue rotating dice
            }
        } else {
            self.result = self.dice[nextSideIndex].number
            self.rollCount = 5 // Reset for next full roll series
            //                disableDice = false
            
            self.roll = false
            print("Stoped Rolling")
            
        }
    }
    
    // MARK: - HORIZONTAL ROLLING METHODS
    
    private func moveHorizontalPattern() {
        horizontalPattern.move(fromOffsets: .init(integer: 0), toOffset: 4)
        verticalPattern.remove(atOffsets: .init([0, 2]))
        verticalPattern.insert(horizontalPattern[0], at: 0)
        verticalPattern.insert(horizontalPattern[2], at: 2)
    }
    
    private func setNextSideBeforeMovingHorizontally(_ facingSideIndex: Int, _ nextSideIndex: Int) {
        dice[nextSideIndex].rotateHorizontally = true
        dice[nextSideIndex].anchor = .leading
        dice[nextSideIndex].degrees = -90
        dice[nextSideIndex].offset = size
        
        rotateDice(facingSideIndex, nextSideIndex)
    }
    
    func rotateHorizontally() {
        if let facingSideIndex = dice.firstIndex(where: { $0.degrees == 0 }) {
            // Reorder patterns
            moveHorizontalPattern()
            
            if let currentHorizontalIndex = horizontalPattern.firstIndex(where: { $0 == dice[facingSideIndex].number }) {
                
                // Prepare facing side before animation
                dice[facingSideIndex].rotateHorizontally = true
                dice[facingSideIndex].anchor = .trailing
                
                // Prepare next side before animation
                // Look for next index in horizontal pattern
                if currentHorizontalIndex < 3 {
                    if let nextSideIndex = dice.firstIndex(where: { $0.number == horizontalPattern[currentHorizontalIndex + 1] }) {
                        setNextSideBeforeMovingHorizontally(facingSideIndex, nextSideIndex)
                    }
                } else {
                    // next index is 0
                    if let nextSideIndex = dice.firstIndex(where: { $0.number == horizontalPattern[0] }) {
                        setNextSideBeforeMovingHorizontally(facingSideIndex, nextSideIndex)
                    }
                }
            }
        }
    }
    // MARK: - VERTICAL ROLLING METHODS
    
    private func moveVerticalPattern() {
        verticalPattern.move(fromOffsets: .init(integer: 0), toOffset: 4)
        horizontalPattern.remove(atOffsets: .init([0, 2]))
        horizontalPattern.insert(verticalPattern[0], at: 0)
        horizontalPattern.insert(verticalPattern[2], at: 2)
    }
    
    private func setNextSideBeforeMovingVertically(_ facingSideIndex: Int, _ nextSideIndex: Int) {
        dice[nextSideIndex].rotateHorizontally = false
        dice[nextSideIndex].anchor = .top
        dice[nextSideIndex].degrees = -90
        dice[nextSideIndex].offset = size
        
        rotateDice(facingSideIndex, nextSideIndex)
    }
    
    func rotateVertically() {
        if let facingSideIndex = dice.firstIndex(where: { $0.degrees == 0 }) {
            // Reorder patterns
            moveVerticalPattern()
            
            if let currentVerticalIndex = verticalPattern.firstIndex(where: { $0 == dice[facingSideIndex].number }) {
                
                // Prepare facing side before animation
                dice[facingSideIndex].rotateHorizontally = false
                dice[facingSideIndex].anchor = .bottom
                
                // Prepare next side before animation
                // Look for next index in vertical pattern
                if currentVerticalIndex < 3 {
                    if let nextSideIndex = dice.firstIndex(where: { $0.number == verticalPattern[currentVerticalIndex + 1] }) {
                        setNextSideBeforeMovingVertically(facingSideIndex, nextSideIndex)
                    }
                } else {
                    // next index is 0
                    if let nextSideIndex = dice.firstIndex(where: { $0.number == verticalPattern[0] }) {
                        setNextSideBeforeMovingVertically(facingSideIndex, nextSideIndex)
                    }
                }
            }
        }
    }
    // MARK: - HAPTICS METHODS
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine \(error.localizedDescription)")
        }
    }
    
    private func rollHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, through: 0.2, by: 0.2) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i * 2.5) + 0.1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i * 2.5) + 0.1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
}
