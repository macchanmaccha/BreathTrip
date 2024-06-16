//
//  ExplanationView.swift
//  MeditationJourney
//
//  Created by apple on 2023/09/17.
//

import SwiftUI

struct ExplanationView: View {
    var body: some View {
        ZStack {
            Image(.settingsBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            // 背景枠
            Rectangle()
                .fill(Color(.keyWhite))
                .cornerRadius(8)
                .opacity(0.6)
                .frame(width: 400, height: 400)
        } // ZStackここまで
        
    } // bodyここまで
} // ExplanationViewここまで

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView()
    }
}
