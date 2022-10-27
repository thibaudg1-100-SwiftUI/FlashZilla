//
//  ParallelGesture.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

struct ParallelGesture: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onTapGesture {
                    print("Text tapped")
                }
        }
        // Alternatively, you can use the simultaneousGesture() modifier to tell SwiftUI you want both the parent and child gestures to trigger at the same time, like this:
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    print("VStack tapped")
                }
        )
    }
}

struct ParallelGesture_Previews: PreviewProvider {
    static var previews: some View {
        ParallelGesture()
    }
}
