//
//  GenericGesture.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

/*
 For more advanced gestures you should use the gesture() modifier with one of the gesture structs: DragGesture, LongPressGesture, MagnificationGesture, RotationGesture, and TapGesture. These all have special modifiers, usually onEnded() and often onChanged() too, and you can use them to take action when the gestures are in-flight (for onChanged()) or completed (for onEnded()).
 */

/*
 As an example, we could attach a magnification gesture to a view so that pinching in and out scales the view up and down. This can be done by creating two @State properties to store the scale amount, using that inside a scaleEffect() modifier, then setting those values in the gesture, like this:
 */
struct GenericGesture: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    var body: some View {
        Text("Hello, World!")
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { amount in
                        currentAmount = amount - 1
                    }
                    .onEnded { amount in
                        finalAmount += currentAmount
                        currentAmount = 0
                    }
            )
    }
}

struct GenericGesture_Previews: PreviewProvider {
    static var previews: some View {
        GenericGesture()
    }
}
