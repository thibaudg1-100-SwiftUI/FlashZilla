//
//  AccessibilityColor.swift
//  FlashZilla
//
//  Created by RqwerKnot on 08/04/2022.
//

import SwiftUI

/*
 SwiftUI gives us a number of environment properties that describe the user’s custom accessibility settings, and it’s worth taking the time to read and respect those settings.

 Back in project 15 we looked at accessibility labels and hints, traits, groups, and more, but these settings are different because they are provided through the environment. This means SwiftUI automatically monitors them for changes and will reinvoke our body property whenever one of them changes.

 For example, one of the accessibility options is “Differentiate without color”, which is helpful for the 1 in 12 men who have color blindness. When this setting is enabled, apps should try to make their UI clearer using shapes, icons, and textures rather than colors. 
 */
struct AccessibilityColor: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var body: some View {
        HStack {
            if differentiateWithoutColor {
                Image(systemName: "checkmark.circle")
            }
            
            Text("Success")
        }
        .padding()
        .background(differentiateWithoutColor ? .black : .green)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
}
//You can test that in the simulator by going to the Settings app and choosing Accessibility > Display & Text Size > Differentiate Without Color.

// Or use Xcode 'Environment Overrides' in the Debug Area (Double Switch icon)

struct AccessibilityColor_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityColor()
    }
}
