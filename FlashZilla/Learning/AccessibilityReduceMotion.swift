//
//  AccessibilityReduceMotion.swift
//  FlashZilla
//
//  Created by RqwerKnot on 08/04/2022.
//

import SwiftUI

// Another common option is Reduce Motion, which again is available in the simulator under Accessibility > Motion > Reduce Motion. When this is enabled, apps should limit the amount of animation that causes movement on screen. For example, the iOS app switcher makes views fade in and out rather than scale up and down.

struct AccessibilityReduceMotion: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var scale = 1.0
    
    var body: some View {
        Text("Hello, World!")
            .scaleEffect(scale)
            .onTapGesture {
                if reduceMotion {
                    scale *= 1.5
                } else {
                    withAnimation {
                        scale *= 1.5
                    }
                }
            }
    }
}

// I don’t know about you, but I find that rather annoying to use. Fortunately we can add a little wrapper function around withAnimation() that uses UIKit’s UIAccessibility data directly, allowing us to bypass animation automatically:
func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    // Using 'UIAccessibility' from UIKit allows us not having to use the environment variable
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
} // 'Result' here does not refer to SwiftUI Result type, but is only the name of the generic used in the original function signature of WithAnimation()
// Result cound be anything the body implementation returns or nothing if the body doesn't return anything in its implementation
// Rethrows propagate the error one level up so you don't need to use a try block

//So, when Reduce Motion Enabled is true the closure code that’s passed in is executed immediately, otherwise it’s passed along using withAnimation(). The whole throws/rethrows thing is more advanced Swift, but it’s a direct copy of the function signature for withAnimation() so that the two can be used interchangeably:
struct AccessibilityReduceMotion_2: View {
    @State private var scale = 1.0

    var body: some View {
        Text("Hello, World!")
            .scaleEffect(scale)
            .onTapGesture {
                withOptionalAnimation {
                    scale *= 1.5
                }
            }
    }
}

struct AccessibilityReduceMotion_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityReduceMotion()
    }
}
