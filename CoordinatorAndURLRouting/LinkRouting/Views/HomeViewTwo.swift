//
//  HomeViewTwo.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

struct HomeViewTwo: View {

    // MARK: - Properties

    @Environment(Navigator.self) var navigator

    // MARK: - View

    var body: some View {
        VStack {
            List {
                Button("open \"/favorites\"") {
                    navigator.go(to: "/favorites")
                }
                RouteLink(
                    label: {
                        Text("open \"/details\"")
                    },
                    route: "/details"
                )
                Button("say \"/hi\" modally") {
                    navigator.go(to: "/hi")
                }
                ParameterizedView()
            }
        }
    }
}

#Preview {
    Router.singleRooted(content: HomeView.init)
}
