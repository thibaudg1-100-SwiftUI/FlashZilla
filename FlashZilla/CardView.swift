//
//  CardView.swift
//  FlashZilla
//
//  Created by RqwerKnot on 08/04/2022.
//

import SwiftUI

extension RoundedRectangle {
    func customFill(for offset: CGSize) -> some View {
        switch offset.width {
        case ..<0:
            return self.fill(Color.red)
        case 0:
            return self.fill(Color.white)
        default:
            return self.fill(Color.green)
        }
    }
}

struct CardView: View {
    let card: Card
    // This works well, but to really finish this step we need to fill in the // remove the card comment so the card actually gets removed in the parent view. Now, we don’t want CardView to call up to ContentView and manipulate its data directly, because that causes spaghetti code. Instead, a better idea is to store a closure parameter inside CardView that can be filled with whatever code we want later on – it means we have the flexibility to get a callback in ContentView without explicitly tying the two views together
    var removal: ((Bool) -> Void)? = nil
    // As you can see, that’s a closure that accepts no parameters and sends nothing back, defaulting to nil so we don’t need to provide it unless it’s explicitly needed.
    // also it must be declared AFTER 'let card' so that Swift struct init auto synthetizer allows us to use a trailing closure syntax for 'removal' when calling 'CardView'
    // added a Bool parameter for project challenge
    
    @State private var isShowingAnswer = false
    
    @State private var offset = CGSize.zero
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    // the feedback generator must be created in each CardView so that when a drag gesture happens, we have time to prepare the Taptic Engine
    // @State so that it prevents SwiftUI to recreate an instance of a generator each time the View body is reinvoked
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                    
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .customFill(for: offset)
                )
                .shadow(radius: 10)
            // we can add a shadow to the RoundedRectangle so we get a gentle depth effect. This will help us right now by making our white card stand out from the white background, but when we start adding more cards it will look even better because the shadows will add up.
            
            VStack {
                if voiceOverEnabled {
                        Text(isShowingAnswer ? card.answer : card.prompt)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    } else {
                        Text(card.prompt)
                            .font(.largeTitle)
                            .foregroundColor(.black)

                        if isShowingAnswer {
                            Text(card.answer)
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                    }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        // Tip: A width of 450 is no accident: the smallest iPhones have a landscape width of 480 points, so this means our card will be fully visible on all devices.
        .rotationEffect(.degrees(Double(offset.width / 5))) // /5 so that the rotation stays small
        .offset(x: offset.width * 5, y: 0) // *5 so that the user need just a small drag to generate a larger translation of the card
        .opacity(2 - Double(abs(offset.width / 50))) // using abs() for absolute: reverse negative values to positive domain
        // the opacity will decrease only after card is dragged more than 50 points
        .accessibilityAddTraits(.isButton) // to tell VoiceOver this is actually a button
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
        .gesture(
            DragGesture()
            //Drag gestures have two useful modifiers of their own, letting us attach functions to be triggered when the gesture has changed (called every time they move their finger), and when the gesture has ended (called when they lift their finger).
            // Both of these functions are handed the current gesture state to evaluate
                .onChanged { gesture in
                    // In our case we’ll be reading the translation property to see where the user has dragged to:
                    offset = gesture.translation
                    
                    // we need to call prepare() on our haptic a little before triggering it. It is not enough to call prepare() immediately before activating it: doing so does not give the Taptic Engine enough time to warm up, so you won’t see any reduction in latency. Instead, you should call prepare() as soon as you know the haptic might be needed.
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 { // if dragged enough, act on it:
                        
                        if offset.width > 0 { // trigger a haptic notification
                            // this is the "success" haptic feedback; it's expected to be played a lot if the questions are of "normal" difficulty
                            // maybe deactivate it to prevent "haptic desensitization" or user annoyment:
                            //feedback.notificationOccurred(.success)
                        } else {
                            feedback.notificationOccurred(.error)
                        }
                        
                        removal?(offset.width > 0 ? true : false) // if a closure has been passed for 'removal': execute it, otherwise do nothing
                        
                    } else { // otherwise reposition the card on the stack
                            offset = .zero
                    }
                }
        )
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
