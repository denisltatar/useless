//
//  ContentView.swift
//  useless Watch App
//
//  Created by Denis Tatar on 2024-02-05.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    let stringBacklog = [
        "One day, or day one. You decide.",
        "Smile more!",
        "Haha got you to look!"
    ]
    
    
    @State private var quote = "Hey there!"
    
    // Motion manager for detecting shakes
    let motionManager = CMMotionManager()
    
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
                    
                    // Adding settings gear
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // For some reason this is only moving the logo up??? Figure it out later!
                Spacer(minLength: 55)
                
                // Displaying quote
                Text(quote)
                    .font(.custom("Cochin", size: 15))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer(minLength: 55)
                
                // Replace this button with shake feature
                // Displaying Button
//                Button(action: {
//                    self.randomlySelectQuote()
//                }) {
//                    Text("Generate")
//                }
//                .buttonStyle(.borderedProminent)
//                .tint(.white)
//                .foregroundColor(.black)
//                .bold()
                // Replace this button with shake feature
                
                Text("shake to generate")
                    .font(.custom("Cochin", size: 9))
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("shakeDetected"))) { _ in
                        self.randomlySelectQuote()
                    }
                
            }
            .padding()
        }
        .onAppear {
            startMotionManager()
        }
        .onDisappear {
            stopMotionManager()
        }
    }
    
    func startMotionManager() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data = data, error == nil else { return }

                if abs(data.acceleration.x) + abs(data.acceleration.y) + abs(data.acceleration.z) > 3 {
                    NotificationCenter.default.post(name: Notification.Name("shakeDetected"), object: nil)
                }
            }
        }
    }
    
    func stopMotionManager() {
        motionManager.stopAccelerometerUpdates()
    }


    func randomlySelectQuote() {
        // Use a random index to select a string from the backlog
        if let randomString = stringBacklog.randomElement() {
            self.quote = randomString
        }
    }
}

struct SettingsView: View {
    @State private var notificationsEnabled = false
    
    var body: some View {
        Text("Settings")
        .bold()
        
        HStack {
            VStack (alignment: .leading) {
                Text("Notifications")
                    .font(.custom("Cochin", size: 14))
                    .bold()
                Text("Get notified every: 3 hours")
                    .font(.custom("Cochin", size: 7))
                    .bold()
                    .tint(.gray)
            }
            
            // Adding Toggle
            Toggle(isOn: $notificationsEnabled) {
                // Add action functionality to this later...
            }
        }
        
        Spacer(minLength: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
