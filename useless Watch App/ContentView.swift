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
        "Haha got you to look!"
    ]
    
    
    @State private var quote = "Hey there!"
    
    var body: some View {
        NavigationView {
            // Displaying entirety of app (vertically)
            VStack {
                // Displaying logo and setting (horizontally)
                HStack {
                    // Displaying my logo "useless"
                    Image("useless")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.leading, 20) // Adjust as needed
                    
                    // Add Spacer to push the logo to the left
                    Spacer(minLength: 40)
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer(minLength: 30)
                
                // Displaying quote
                Text(quote)
                    .font(.custom("Cochin", size: 15))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer(minLength: 30)
                
                // Displaying Button
                Button(action: {
                    self.randomlySelectQuote()
                }) {
                    Text("Generate")
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundColor(.black)
                .bold()
            }
            .padding()
        }
    }


func randomlySelectQuote() {
    // Use a random index to select a string from the backlog
    if let randomString = stringBacklog.randomElement() {
        self.quote = randomString
    }
}
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
