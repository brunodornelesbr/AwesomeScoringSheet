//
//  GamePickerView.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 18/02/25.
//

import SwiftUI

struct GamePickerView: View {
    var body: some View {
        Form {
            Text("Game Picker")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("New game") {}
            }
        }
    }
}

#Preview {
    NavigationStack {
        GamePickerView()
    }
}
