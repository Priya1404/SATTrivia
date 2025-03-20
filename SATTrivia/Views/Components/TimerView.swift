//
//  TimerView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import SwiftUI

struct TimerView: View {
    let startTime: Date
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(String(format: "%.1f", currentTime.timeIntervalSince(startTime)))
            .font(.title)
            .fontWeight(.bold)
            .onReceive(timer) { input in
                currentTime = input
            }
    }
}
