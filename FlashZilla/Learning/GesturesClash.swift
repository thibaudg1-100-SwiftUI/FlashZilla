//
//  GesturesClash.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

/*
 Where things start to get more interesting is when gestures clash – when you have two or more gestures that might be recognized at the same time, such as if you have one gesture attached to a view and the same gesture attached to its parent.
 */
struct GesturesClash: View {
    var body: some View {
            VStack {
                // In this situation SwiftUI will always give the child’s gesture priority, which means when you tap the text view above you’ll see “Text tapped”.
                Text("Hello, World!")
                    .onTapGesture {
                        print("Text tapped")
                    }

            }
            .onTapGesture {
                print("VStack tapped")
            }
        }
}

struct GesturesClash_Previews: PreviewProvider {
    static var previews: some View {
        GesturesClash()
    }
}
