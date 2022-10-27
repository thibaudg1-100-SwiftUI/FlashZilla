//
//  LongPress.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

struct LongPress: View {
    var body: some View {
        Text("Hello, World!")
        // For handling long presses you can use
            .onLongPressGesture {
                print("Long pressed!")
            }
        
        // you can specify a minimum duration for the press, so your action closure only triggers after a specific number of seconds have passed:
        Text("Hello, World!")
            .onLongPressGesture(minimumDuration: 2) {
                print("Long pressed 2 seconds!")
            }
        
        /*
         You can even add a second closure that triggers whenever the state of the gesture has changed. This will be given a single Boolean parameter as input, and it will work like this:

             As soon as you press down the change closure will be called with its parameter set to true.
             If you release before the gesture has been recognized (so, if you release after 1 second when using a 2-second recognizer), the change closure will be called with its parameter set to false.
             If you hold down for the full length of the recognizer, then the change closure will be called with its parameter set to false (because the gesture is no longer in flight), and your completion closure will be called too.

         */
        
        Text("Hello, World!")
            .onLongPressGesture(minimumDuration: 1) {
                // will only be called when the full gesture has completed (1 second long press)
                print("Long pressed!")
            } onPressingChanged: { inProgress in
                // will be called whenever there is press starting or finishing:
                print("In progress: \(inProgress)!")
            }
    }
}

struct LongPress_Previews: PreviewProvider {
    static var previews: some View {
        LongPress()
    }
}
