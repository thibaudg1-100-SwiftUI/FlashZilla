//
//  GesturePriority.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

struct GesturePriority: View {
    var body: some View {
        // In this situation SwiftUI will always give the child’s gesture priority, which means when you tap the text view above you’ll see “Text tapped”. However, if you want to change that you can use the highPriorityGesture() modifier to force the parent’s gesture to trigger instead, like this:
            VStack {
                Text("Hello, World!")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            .highPriorityGesture(
                TapGesture()
                    .onEnded { _ in
                        print("VStack tapped")
                    }
            )
        }
}

struct GesturePriority_Previews: PreviewProvider {
    static var previews: some View {
        GesturePriority()
    }
}
