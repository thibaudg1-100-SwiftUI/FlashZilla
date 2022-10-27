//
//  SimpleHaptics.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

/*
 UIKit has a very simple implementation of haptics, but that doesn’t mean you should rule it out: it can be simple because it focuses on built-in haptics such as “success” or “failure”, which means users can come to learn how certain things feel. That is, if you use the success haptic then some users – particularly those who rely on haptics more heavily, such as blind users – will be able to know the result of an operation without any further output from your app.
 */

struct SimpleHaptics: View {
    var body: some View {
        Text("Hello, World!")
            .onTapGesture(perform: simpleSuccess)
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        // Try replacing .success with .error or .warning and see if you can tell the difference – .success and .warning are similar but different, I think.
    }
}

struct SimpleHaptics_Previews: PreviewProvider {
    static var previews: some View {
        SimpleHaptics()
    }
}
