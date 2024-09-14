//
//  DiceSideView.swift
//  Rollkeeper
//
//  Created by Nazar on 13/9/24.
//

import SwiftUI

struct DiceSideView: View {
    let side: DiceSide
    let size: Double
    
    var body: some View {
        ZStack {
            ZStack {
                if side.number == 1 || side.number == 3 || side.number == 5 {
                    dot(alignment: .center)
                }
                if side.number != 1 {
                    dot(alignment: .topLeading)
                    dot(alignment: .bottomTrailing)
                }
                if side.number >= 4 {
                    dot(alignment: .topTrailing)
                    dot(alignment: .bottomLeading)
                }
                if side.number == 6 {
                    dot(alignment: .leading)
                    dot(alignment: .trailing)
                }
            }
            .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
            .padding(side.number == 5 ? size * 0.213 : side.number == 2 ? size * 0.2467 : size * 0.233)
            .padding(.vertical, side.number == 6 ? -size * 0.04 : 0)
            .background {
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [Color.gray.opacity(1), Color.black.opacity(0.5)]), center: .bottomLeading, startRadius: size * 0.333, endRadius: size)
                    )
                    .padding(size * 0.033)
                    .shadow(color: .black.opacity(0.8), radius: 10, x: 5, y: 5)
            }
        }
        .background(
            RadialGradient(gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.black.opacity(0.7)]), center: .topTrailing, startRadius: size * 0.333, endRadius: size)
        )
        .overlay {
            Rectangle()
                .strokeBorder(Color.black, lineWidth: 1)
        }
        .rotation3DEffect(
            .degrees(side.degrees),
            axis: (
                x: side.rotateHorizontally ? 0 : 1,
                y: side.rotateHorizontally ? -1 : 0,
                z: 0
            ),
            anchor: side.anchor, perspective: 0.1
        )
        .offset(
            x: side.rotateHorizontally ? side.offset : 0,
            y: side.rotateHorizontally ? 0 : side.offset
        )
        .shadow(color: .black.opacity(0.6), radius: 15, x: 10, y: 10)
    }
    
    private func dot(alignment: Alignment) -> some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.4)]), startPoint: .bottomLeading, endPoint: .topTrailing))
            .frame(
                width: side.number == 1 ? size * 0.18 : size * 0.167,
                height: side.number == 1 ? size * 0.18 : size * 0.167
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        
    }
}

struct DiceSideView_Previews: PreviewProvider {
    static var previews: some View {
        DiceSideView(side: DiceSide.example, size: 150)
            .frame(width: 150, height: 150)
            .previewLayout(.sizeThatFits)
    }
}


