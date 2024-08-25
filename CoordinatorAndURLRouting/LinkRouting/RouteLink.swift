//
//  RouteLink.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

@MainActor
struct RouteLink<Label: View>: View {

    // MARK: - Properties

    @Environment(Navigator.self) var nav
    let label: () -> Label
    let route: String

    // MARK: - Initialization

    init(@ViewBuilder label: @escaping () -> Label, route: String) {
        self.label = label
        self.route = route
    }

    // MARK: - View

    var body: some View {
        HStack {
            label()
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(Font.system(size: 13))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            nav.go(to: route)
        }
    }
}
