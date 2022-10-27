//
//  TappableShape.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

struct TappableShape: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle tapped!")
                }
            
            // The other useful way of controlling user interactivity is with the contentShape() modifier, which lets us specify the tappable shape for something. By default the tappable shape for a circle is a circle of the same size, but you can specify a different shape instead like this:
            Circle()
                .fill(.red)
                .frame(width: 300, height: 300)
                .contentShape(Rectangle())
                .onTapGesture {
                    print("Circle tapped!")
                }
        }
    }
}

struct TappableShape_Previews: PreviewProvider {
    static var previews: some View {
        TappableShape()
    }
}
