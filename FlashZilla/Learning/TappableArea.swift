//
//  TappableArea.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

/*
 SwiftUI has an advanced hit testing algorithm that uses both the frame of a view and often also its contents. For example, if you add a tap gesture to a text view then all parts of the text view are tappable – you can’t tap through the text if you happen to press exactly where a space is. On the other hand, if you attach the same gesture to a circle then SwiftUI will ignore the transparent parts of the circle.

 To demonstrate this, here’s a circle overlapping a rectangle using a ZStack, both with onTapGesture() modifiers:
 */
struct TappableArea: View {
    var body: some View {
        // If you try that out, you’ll find that tapping inside the circle prints “Circle tapped”, but on the rectangle behind the circle prints “Rectangle tapped” – even though the circle actually has the same frame as the rectangle.
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Red circle tapped!")
                }
            
            // SwiftUI lets us control user interactivity in two useful ways, the first of which is the allowsHitTesting() modifier. When this is attached to a view with its parameter set to false, the view isn’t even considered tappable. That doesn’t mean it’s inert, though, just that it doesn’t catch any taps – things behind the view will get tapped instead.
            Circle()
                .fill(.green)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    print("Green circle tapped!")
                }
                .allowsHitTesting(false)
        }
    }
}

struct TappableArea_Previews: PreviewProvider {
    static var previews: some View {
        TappableArea()
    }
}
