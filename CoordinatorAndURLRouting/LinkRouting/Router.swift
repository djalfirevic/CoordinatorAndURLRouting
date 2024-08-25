//
//  Router.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

@MainActor
struct Router: View {

    // MARK: - Properties

    @State private var navigator: Navigator

    // MARK: - Initialization

    init(routes: [AnyRouteProtocol], root: String = "/") {
        self.navigator = try! Navigator(routes: routes, root: root)
    }

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    // MARK: - View

    var body: some View {
        NavigationStack(path: $navigator.path) {
            if let box = navigator.root {
                box.route.build(box.parameters)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationDestination(for: RouteBox.self, destination: { box in
                        box.route.build(box.parameters)
                    })
            } else {
                AnyView(Text("404: Page Not Found"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .environment(navigator)
        .sheet(
            item: $navigator.modalPath,
            content: {
                Router(navigator: navigator.modalNavigator()).id($0)
            }
        )
        .onOpenURL { url in
            navigator.go(to: url.host().map { "/" + $0 + url.path() } ?? "/")
        }
    }

    // MARK: - Public API

    static func tabbed(tabs: [AnyTabRouteProtocol]) -> some View {
        TabRouter(routes: tabs)
    }
}

extension String: Identifiable {
    public var id: Self { self }
}
