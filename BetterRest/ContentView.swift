//
//  ContentView.swift
//  BetterRest
//
//  Created by Frank Grullon on 22/7/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var coffeAmount = 1
    @State private var SleepAmount = 8.0
    @State private var wakeUp = defaultWakeUpTime
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    static var defaultWakeUpTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
    }
        
    var body: some View {
        NavigationStack{
            Form{
                
                Section("What time do yo want to wake up"){
                
                    
                    DatePicker("Time to wake up", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .bold()

                Section("Desired amount of sleep"){
                    Stepper("\(SleepAmount.formatted()) hours", value: $SleepAmount, in: 4...12, step: 0.25)
                }
                .bold()
                Section("Daily coffe intake") {
                    Stepper(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cups", value: $coffeAmount, in: 1...20)
                }
                .bold()
        }
            .navigationTitle("BetterRest")
            .toolbar{
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showAlert){
                Button("Ok") {}
            } message: {
                Text(alertMessage)
            }
        }
        .padding()
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: SleepAmount, coffee: Double(coffeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error!"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        showAlert = true
    }
}

#Preview {
    ContentView()
}
