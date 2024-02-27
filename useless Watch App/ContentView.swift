//
//  ContentView.swift
//  useless Watch App
//
//  Created by Denis Tatar on 2024-02-05.
//

import SwiftUI

struct ContentView: View {
    let stringBacklog = [
            "One day, or day one. You decide.",
            "Smile more!",
            "Haha got you to look",
        ]
    
    @State private var quote = "Hey there!"
    
    var body: some View {
        VStack {
            Text(quote).font(.custom("Cochin", size: 20))
                            .multilineTextAlignment(.center)
                            .padding()
            
            // Replacing text once tapped.
            Button (action: {
                self.randomlySelectQuote()
            }, label: { 
                Text("Generate")
                }).buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundColor(.black)
                .bold()
                .padding()
        }
//        .padding()
    }
    
    func randomlySelectQuote() {
        // Use a random index to select a string from the backlog
        if let randomString = stringBacklog.randomElement() {
            self.quote = randomString
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
