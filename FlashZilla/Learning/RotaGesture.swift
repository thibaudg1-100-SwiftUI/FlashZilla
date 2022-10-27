//
//  RotaGesture.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

/*
 Exactly the same approach can be taken for rotating views using RotationGesture, except now we’re using the rotationEffect() modifier:
 */
struct RotaGesture: View {
    @State private var currentAmount = Angle.zero
    @State private var finalAmount = Angle.zero
    
    var body: some View {
        Text("Hello, World!")
            .rotationEffect(currentAmount + finalAmount)
            .gesture(
                RotationGesture()
                    .onChanged { angle in
                        currentAmount = angle
                    }
                    .onEnded { angle in
                        finalAmount += currentAmount
                        currentAmount = .zero
                    }
            )
    }
}

struct RotaGesture_Previews: PreviewProvider {
    static var previews: some View {
        RotaGesture()
    }
}
