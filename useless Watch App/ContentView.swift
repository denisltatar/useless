//
//  ContentView.swift
//  useless Watch App
//
//  Created by Denis Tatar on 2024-02-05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
//            Image("useless")
//                .imageScale(.small).onTapGesture {
//                    print("tapped!")
//                }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            // Creating a simple string variable to be replace upon a button being tapped
            Text("Hello, Jamiepoo!").font(.custom("Cochin", fixedSize: 10))
            Button (action: {
                // Execute action
            }, label: { Text("Generate")})

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
