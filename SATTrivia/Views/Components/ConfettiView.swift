//
//  ConfettiView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 19/03/25.
//

import SwiftUI

struct ConfettiView: View {
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    struct Particle: Identifiable {
        let id = UUID()
        var position: CGPoint
        var color: Color
        var rotation: Double
        var scale: Double
        var velocity: CGPoint
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: 8, height: 8)
                    .position(particle.position)
                    .rotationEffect(.degrees(particle.rotation))
                    .scaleEffect(particle.scale)
            }
        }
        .onAppear {
            startConfetti()
        }
        .onReceive(timer) { _ in
            updateParticles()
        }
    }
    
    private func startConfetti() {
        for _ in 0..<50 {
            let particle = Particle(
                position: CGPoint(x: CGFloat.random(in: 0...400), y: -20),
                color: colors.randomElement() ?? .blue,
                rotation: Double.random(in: 0...360),
                scale: Double.random(in: 0.5...1.5),
                velocity: CGPoint(
                    x: CGFloat.random(in: -2...2),
                    y: CGFloat.random(in: 2...4)
                )
            )
            particles.append(particle)
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].position.x += particles[i].velocity.x
            particles[i].position.y += particles[i].velocity.y
            particles[i].rotation += Double.random(in: -10...10)
            particles[i].velocity.y += 0.1 // gravity
            
            // Reset particle if it goes off screen
            if particles[i].position.y > 800 {
                particles[i].position = CGPoint(x: CGFloat.random(in: 0...400), y: -20)
                particles[i].velocity = CGPoint(
                    x: CGFloat.random(in: -2...2),
                    y: CGFloat.random(in: 2...4)
                )
            }
        }
    }
} 
