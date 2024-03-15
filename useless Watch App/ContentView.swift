//
//  ContentView.swift
//  useless Watch App
//
//  Created by Denis Tatar on 2024-02-05.
//

import SwiftUI
import CoreMotion
import UserNotifications

struct ContentView: View {
    let stringBacklog = [
        "One day, or day one. You decide.",
        "Smile more!",
        "Haha got you to look!",
        "This is a super long text and quote to do a test test test test test",
    ]
    
    
    @State private var quote = "Hey there!"
    
    // Motion manager for detecting shakes
    let motionManager = CMMotionManager()
    
    var body: some View {
        NavigationView {
                // Displaying entirety of app (vertically)
            VStack {
//                    Spacer()
                    // Displaying logo and setting (horizontally)
                    HStack {
                        // Displaying my logo "useless"
                        Image("useless")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .baselineOffset(5) // Vertically align the logo with the gear icon
                            .padding(.leading, 20) // Adjust as needed

                        Spacer() // Fill remaining space

                        // Adding settings gear
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
//                    .padding(.top, 10)
                    .fixedSize(horizontal: false, vertical: true) // Add this line to keep the size fixed
                
                
                    // For some reason this is only moving the logo up??? Figure it out later!
                    //                Spacer(minLength: 30)
                    Spacer()
                    
                    // Displaying quote
                    Text(quote)
                        .font(.custom("Cochin", size: dynamicFontSize()))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true) // Allow multi-line text
                    
                    //                Spacer(minLength: 55)
                    Spacer()
                    
                    // Replace this button with shake feature
                    // Displaying Button
                    Button(action: {
//                        self.randomlySelectQuote()
                        self.generateQuoteFromAPI()
                    }) {
                        Text("Generate")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundColor(.black)
                    .bold()
                    .frame(alignment: .bottom) // Align to the bottom of the screen
                // Spacer to push the button to the bottom of the screen
                            Spacer()
                    // Replace this button with shake feature
                    
                    // Shake to generate feature
                    //                Text("shake to generate")
                    //                    .font(.custom("Cochin", size: 9))
                    //                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("shakeDetected"))) { _ in
                    //                        self.randomlySelectQuote()
                    //                    }
                    
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
    
    // Function to calculate dynamic font size based on quote length
    func dynamicFontSize() -> CGFloat {
        // Adjust as needed
        let maxLength = 25
        let scaleFactor: CGFloat = 0.8
        let adjustedSize = CGFloat(maxLength) * scaleFactor
        // Minimum font size
        return max(12, adjustedSize)
    }
    
    func generateQuoteFromAPI() {
        // Assigning our API key
        // API key is old, REPLACE this one from your personal account
        let apiKey = "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"
        
        // Checking if API key actually exists
        if apiKey.isEmpty {
            print("API key is missing!")
            return
        }
        
        // OpenAI API endpoint
//        let apiUrl = URL(string: "https://api.openai.com/v1/chat/completions")!
        let apiUrl = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        // Prompt for Chat GPT
        let prompt = "Generate a quote that's either really funny or motivating. Make it no longer than 30 tokens in length..."
        
        // Making our request
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        // Encoding request
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
        } catch {
            print("Error encoding request body: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // Catching error in quote if one exists
                    print("Error fetching quote: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
            
            // Print the raw JSON response for debugging
//            print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                
            do {
                    if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let choices = responseJSON["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        DispatchQueue.main.async {
                            // Updating our quote with ChatGPT's quote.
//                            print("WE GET HERE!")
//                            print("Generated Quote: \(text)")
//                            print(responseJSON)
                            self.scheduleNotification()
//                            self.quote = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    // Error printing
                    } else {
                        // REMOVE THIS IN THE FUTURE ONCE YOU GET OPENAI API KEY BACK AND RUNNING!
                        self.scheduleNotification()
                        print("Error extracting quote from API response.")
                    }
                // Error printing
                } catch {
                    print("Error parsing API response: \(error.localizedDescription)")
                }
            }.resume()
    }
    
    // --- NOTIFICATIONS FOR USELESS ---
    // Where I left off: all of these three functions work, however, I think I need payload
    // Follow this link to create one and integrate it in this app:
    // https://developer.apple.com/tutorials/swiftui/creating-a-watchos-app#Create-a-custom-notification-interface
    
    func scheduleNotification() {
        // Request notification authorization if not already granted
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                // Proceed to schedule notification
                DispatchQueue.main.async {
                    self.internalScheduleNotification()
                }
            } else {
                // Request authorization first
                self.requestNotificationAuthorization()
            }
        }
    }
    
    // Requesting permission to have notifications fly in
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification authorization granted!")
            } else {
                print("Notification authorization denied!")
            }
        }
    }
    
    private func internalScheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "New Notification"
        content.body = "This is a test notification"
        
        // Configure the trigger for the notification (e.g., time-based trigger)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        // Create the request for the notification
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully. Here's your message")
                print(content.title)
                print(content.body)
            }
        }
    }
    // --- NOTIFICATIONS FOR USELESS ---
    
    // --- Sensing Motion ---
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
    
    // --- Sensing Motion ---
    
    // Creating notifications with prompts
    // https://www.youtube.com/watch?v=dxe86OWc2mI&ab_channel=MartinLasek
//    func checkForPermission() {
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.getNotificationSettings { settings in
//            switch settings.authorizationStatus {
//                // If the notificatio isn't determined, check if it's allowed, and send it off
//                case .notDetermined:
//                    notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
//                        if didAllow {
//                        self.dispatchNotification()
//                        }
//                    }
//                // If denied, then we can't do anything
//                case .denied:
//                    return
//                // If user opted in, then fire off notification
//                case .authorized:
//                    self.dispatchNotification()
//                default:
//                    return
//            }
//        }
//    }
//
//    func dispatchNotification() {
//        let identifier = "morning-notification"
//        let title = "Quote for you!"
//        let body = "Don't be lazy little butt!"
//        let hour = 17
//        let minute = 20
//        let isDaily = true
//        
//        let notificationCenter = UNUserNotificationCenter.current()
//        
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        
//        let calendar = Calendar.current
//        var dateComponents = DateComponents (calendar: calendar, timeZone: TimeZone.current)
//        dateComponents.hour = hour
//        dateComponents.minute = minute
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
//        notificationCenter.add(request)
//    }
    
    // Function to request permission for notifications
//    func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
//            if granted {
//                print("Notifications permission granted")
//                // Register for remote notifications if permission is granted
//                WKExtension.shared().registerForRemoteNotifications()
//            } else {
//                print("Notifications permission denied: \(error?.localizedDescription ?? "")")
//            }
//        }
//    }
    
}

struct SettingsView: View {
    @State private var notificationsEnabled = false
    
    var body: some View {
    Text("Settings").bold().frame(maxWidth: .infinity, alignment: .center)
        Spacer(minLength: 10)
        Form {
            Section() {
                // Add logic to notifications being enabled!
                Toggle(isOn: $notificationsEnabled) {
                    Text("Notifications")
                    Text("Get notified every 3 hours")
                        .font(.custom("Cochin", size: 7))
                        .bold()
                        .tint(.gray)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
