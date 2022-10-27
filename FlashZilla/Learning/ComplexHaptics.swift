//
//  ComplexHaptics.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI
import CoreHaptics

/*
 For more advanced haptics, Apple provides us with a whole framework called Core Haptics. This thing feels like a real labor of love by the Apple team behind it, and I think it was one of the real hidden gems introduced in iOS 13 – certainly I pounced on it as soon as I saw the release notes!
 
 Core Haptics lets us create hugely customizable haptics by combining taps, continuous vibrations, parameter curves, and more. I don’t want to go into too much depth here because it’s a bit off topic, but I do at least want to give you an example so you can try it for yourself.
 */

struct ComplexHaptics: View {
    // Next, we need to create an instance of CHHapticEngine as a property – this is the actual object that’s responsible for creating vibrations, so we need to create it up front before we want haptic effects.
    @State private var engine: CHHapticEngine?
    // yes CHHapticEngine is a reference-type (class) but it's not an ObservableObject
    // and we need to keep the instance alive accross SwiftUI reinvokation of the View
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear(perform: prepareHaptics)
            .onTapGesture(perform: complexSuccess)
    }
    
    // We’re going to create that as soon as our main view appears. When creating the engine you can attach handlers to help resume activity if it gets stopped, such as when the app moves to the background, but here we’re going to keep it simple: if the current device supports haptics we’ll start the engine, and print an error if it fails.
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    // Now for the fun part: we can configure parameters that control how strong the haptic should be (.hapticIntensity) and how “sharp” it is (.hapticSharpness), then put those into a haptic event with a relative time offset. “Sharpness” is an odd term, but it will make more sense once you’ve tried it out – a sharpness value of 0 really does feel dull compared to a value of 1. As for the relative time, this lets us create lots of haptic events in a single sequence.
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        /*
         Alternatively try several taps of increasing then decreasing intensity and sharpness:
         for i in stride(from: 0, to: 1, by: 0.1) {
             let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
             let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
             let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
             events.append(event)
         }

         for i in stride(from: 0, to: 1, by: 0.1) {
             let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
             let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
             let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
             events.append(event)
         }
         */
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

struct ComplexHaptics_Previews: PreviewProvider {
    static var previews: some View {
        ComplexHaptics()
    }
}
