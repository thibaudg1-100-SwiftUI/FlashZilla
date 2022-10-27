//
//  AccessibilityTransparency.swift
//  FlashZilla
//
//  Created by RqwerKnot on 08/04/2022.
//

import SwiftUI

struct AccessibilityTransparency: View {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    var body: some View {
        Text("Hello, World!")
            .padding()
            .background(reduceTransparency ? .black : .black.opacity(0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct AccessibilityTransparency_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityTransparency()
    }
}
