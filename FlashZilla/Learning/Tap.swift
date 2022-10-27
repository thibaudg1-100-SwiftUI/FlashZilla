//
//  Tap.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

struct Tap: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture(count: 2) {
                print("Double Tap detected")
            }
    }
}

struct Tap_Previews: PreviewProvider {
    static var previews: some View {
        Tap()
    }
}
