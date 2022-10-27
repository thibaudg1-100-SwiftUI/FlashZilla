//
//  ContentView.swift
//  FlashZilla
//
//  Created by RqwerKnot on 07/04/2022.
//

import SwiftUI

// The only complex part of our next code is how we position the cards inside the card stack so they have slight overlapping. I’ve said it before, but the best way to write SwiftUI code is to carve off any messy calculations so they are handled as methods or modifiers.
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    // Swift’s arrays have a helpful initializer, init(repeating:count:), which takes one value and repeats it a number of times to create the array.
    //@State private var cards = [Card](repeating: Card.example, count: 10) // or Array<Card>(...) or even Array(repeating: aTypeInstance, count:)
    @State private var cards = Array<Card>()
    
    @State private var savedCards = Array<Card>() // an array of Cards for the EditCardsView2
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    // a timer for each card:
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // make sure the timer stopped counting down as soon that the app is no more active:
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State private var showingEditScreen = false
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedCards")
    
    var body: some View {
        ZStack {
            Image(decorative: "background") // to prevent VoiceOver to read out the image name
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
//                    ForEach(0..<cards.count, id: \.self) { index in
//                        CardView(card: cards[index]){ _ in // CardView initially didn't take any param in
//                            withAnimation {
//                                removeCard(at: index)
//                            }
//                        }
//                        .stacked(at: index, in: cards.count)
//                        // to prevent users to drag cards that are not at the top of the deck:
//                        // it's also useful to prevent SwiftUI being confused as we don't use a Identifiable data set in the ForEach
//                        .allowsHitTesting(index == cards.count - 1)
//                        // to prevent VoiceOver reading out other question than the top one
//                        .accessibilityHidden(index < cards.count - 1)
//                    }
                    
                    // challenge: move a wrongly answered card to the bottom of the deck for another try, while timer has not expired:
                    // we need to keep track of the card index for '.stacked' to work
                    // but we also need to identify uniquely each card for the ForEach to work properly when we recreate a card at the bottom of the deck
                    // We use zip rather than .enumerated() because enumerated provides offset (not index) and hence only work properly on zero-based Collection, while zip will work on any Collection
                    // for 'zip': '\.0' means 'cards.indices' (sequence1), \.1 means 'cards' (sequence 2)
                    // for 'enumerated()': '\.offset' means the offset attributed to '\.element' which is one element of self (Collection)
                    ForEach(Array(zip(cards.indices, cards)), id: \.1.id) { (index, item) in
                        CardView(card: cards[index]) { success in
                            withAnimation {
                                processCard(at: index, for: success)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                        
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                                withAnimation {
                                    processCard(at: cards.count - 1, for: false)
                                }
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel("Wrong")
                            .accessibilityHint("Mark your answer as being incorrect.")

                            Spacer()

                            Button {
                                withAnimation {
                                    processCard(at: cards.count - 1, for: true)
                                }
                            } label: {
                                Image(systemName: "checkmark.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel("Correct")
                            .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        // Whenever that timer fires, we want to subtract 1 from timeRemaining so that it counts down. We could try and do some date mathematics here by storing a start date and showing the difference between that and the current date, but there really is no need as you’ll see!
        .onReceive(timer) { time in
            guard isActive else { return } // if apps isn't active, stop counting down
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if !cards.isEmpty {
                    // only continue counting down if deck is not empty:
                    isActive = true
                }
            } else { // stop counting down when app is not active:
                isActive = false
            }
        }
        // original sheet:
        //.sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCardsView.init)
        // That means “when you want to read the content for the sheet, call the EditCardsView initializer and it will send you back the view to use.” This approach only works because EditCardsView has an initializer that accepts no parameters. If you need to pass in specific values you need to use the closure-based approach instead.
        .onAppear(perform: resetCards)
        // edited .sheet for project challenge
        .sheet(isPresented: $showingEditScreen, onDismiss: updateCards) {
            EditCardsView2(cards: $savedCards)
        }
    }
    
    func processCard(at index: Int, for success: Bool) {
        if success {
            removeCard(at: index)
            
        } else {
            guard index >= 0 else { return } // to prevent trying to remove a card from an empty deck when using the accessibility buttons
            
            // we must create a new card which is a copy of the current card to remove, but with a different id (UUID) otherwise ForEach will get confused and won't work:
            let newCard = Card(prompt: cards[index].prompt, answer: cards[index].answer)
            
            // we must remove the card at the index before inserting the new one, otherwise the 'index' constant will not represent the right position (for removing operation) in the array anymore
            removeCard(at: index)
            
            // finally insert the card back at the bottom of the deck:
            cards.insert(newCard, at: 0)
        }
        
        // stop counting down if all cards have been answered (deck is empty):
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return } // to prevent trying to remove a card from an empty deck when using the accessibility buttons
        
        cards.remove(at: index)
        
        // stop counting down if all cards have been answered (deck is empty):
//        if cards.isEmpty {
//            isActive = false
//        }
        // moved to: 'processCard' for project challenge, otherwise it would stop the game while there is still card to be answered
    }
    
    func resetCards() {
        //cards = Array(repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        
        loadData()
    }
    
    func loadData() {
        // original USerDefaults storing:
//        if let data = UserDefaults.standard.data(forKey: "Cards") {
//            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//                cards = decoded
//                savedCards = decoded // for project challenge
//                //print(cards)
//            }
//        }
        
        // DocumentsDirectory for project challenge:
        do {
            let data = try Data(contentsOf: savePath)
            cards = try JSONDecoder().decode([Card].self, from: data)
            savedCards = cards
        } catch {
            print("Couldn't retrieve SavedCards.")
        }
    }
    
    func updateCards() {
        self.cards = savedCards
        saveData()
        resetCards()
    }
    
    func saveData() {
        
        if let data = try? JSONEncoder().encode(cards) {
            // original USerDefaults storing:
            UserDefaults.standard.set(data, forKey: "Cards")
            
            // DocumentsDirectory for project challenge:
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
        // I let both implementations so that when jumping from one way to another, data is sync (this is only good for learning/playing around)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
