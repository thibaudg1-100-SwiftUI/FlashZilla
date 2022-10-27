//
//  SpacerTap.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

struct SpacerTap: View {
    var body: some View {
        // Where the contentShape() modifier really becomes useful is when you tap actions attached to stacks with spacers, because by default SwiftUI won’t trigger actions when a stack spacer is tapped.
        HStack {
            VStack {
                Text("Hello")
                Spacer().frame(height: 100)
                Text("World")
            }
            .onTapGesture {
                print("VStack tapped!")
            }
            .background(.blue)
            
            VStack {
                Text("Hello")
                Spacer().frame(height: 100)
                Text("World")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                print("VStack tapped!")
            }
            .border(.green)
        }
    }
}

struct SpacerTap_Previews: PreviewProvider {
    static var previews: some View {
        SpacerTap()
    }
}
