//
//  FavoritesView.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

struct FavoritesView: View {

    // MARK: - Properties

    @Environment(Navigator.self) var navigator

    // MARK: - View

    var body: some View {
        VStack(spacing: 16) {
            Button("open \"/details\"") {
                navigator.go(to: "/details")
            }
            Button("say \"/hi\"") {
                navigator.go(to: "/hi")
            }
            Button("open unknown page") {
                navigator.go(to: "/url/that/does/not/exist")
            }
        }
    }
}

#Preview {
    Router.singleRooted(content: FavoritesView.init)
}
