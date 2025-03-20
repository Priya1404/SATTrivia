//
//  GifView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 19/03/25.
//

import SwiftUI

struct GifView: View {
    let gifName: String
    
    var body: some View {
        Image(systemName: gifName == "winner" ? "star.fill" : "cloud.rain.fill")
            .font(.system(size: 60))
            .foregroundColor(gifName == "winner" ? .yellow : .gray)
    }
} 
