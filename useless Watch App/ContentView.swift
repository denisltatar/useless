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

//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
            
//            Button {
//                // Execute action
//            } label: {
//                Image(systemName: "square.and.arrow.up")
//            }
            var quote = "Hello Jamie!"
            Text(quote).font(.custom("Cochin", fixedSize: 10))
            
            // Creating a simple string variable to be replace upon a button being tapped
            Button (action: {
                // Execute action
                .onChange(of: quote, perform: { quote in
//                    quote = "Hello dawg!")
                    // https://chat.openai.com/share/d0847da2-5ba6-4caa-a0b1-fc5857b8ec41
//                    print(quote)
                })
            }, label: { Text("Generate")}).buttonStyle(.borderedProminent).tint(.white).foregroundColor(.black).bold()

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
