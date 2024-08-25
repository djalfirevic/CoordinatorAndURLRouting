//
//  ParameterizedView.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

struct ParameterizedView: View {

    // MARK: - Properties

    @Environment(Navigator.self) var navigator
    @State private var text: String = ""

    // MARK: - View

    var body: some View {
        HStack {
            Button("open \"/details/") {
                navigator.go(to: "/details/\(text)")
            }

            TextField("dynamic route", text: $text)
        }
    }
}

#Preview {
    Router.singleRooted(content: ParameterizedView.init)
}
