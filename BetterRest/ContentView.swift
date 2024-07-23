//
//  ContentView.swift
//  BetterRest
//
//  Created by Frank Grullon on 22/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var coffeAmount = 1
    @State private var SleepAmount = 8.0
    @State private var wakeUp = Date.now
    var body: some View {
        NavigationStack{
            VStack{
                
            Text("What time do yo want to wake up")
                .font(.headline)
            
            DatePicker("Time to wake up", selection: $wakeUp, displayedComponents: .hourAndMinute)
                .labelsHidden()
            
            Text("Desired amount of sleep")
                .font(.headline)
            
            Stepper("\(SleepAmount.formatted()) hours", value: $SleepAmount, in: 4...12, step: 0.25)
            
            Text("Daily coffe intake")
                .font(.headline)
            
            Stepper("\(coffeAmount)", value: $coffeAmount, in: 1...20)
        }
            .navigationTitle("BetterRest")
            .toolbar{
                Button("Calculate", action: calculateBedTime)
            }
        }
        .padding()
    }
    
    func calculateBedTime() {
        
    }
}

#Preview {
    ContentView()
}
