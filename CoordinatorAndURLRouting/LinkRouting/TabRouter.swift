//
//  TabRouter.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

@MainActor
struct TabRouter: View {

    // MARK: - Properties

    @State private var navigator: TabNavigator
    let routes: [AnyTabRouteProtocol]

    // MARK: - Initialization

    init(routes: [AnyTabRouteProtocol]) {
        self.navigator = try! TabNavigator(tabs: routes, rootPath: "/")
        self.routes = routes
    }

    // MARK: - View

    var body: some View {
        TabView(selection: $navigator.rootPath) {
            ForEach(navigator.navigators, id: \.rootPath) { nav in
                Router(navigator: nav)
                    .tabItem {
                        routes.first { route in
                            route.path == nav.rootPath
                        }?.buildLabel()
                    }
                    .tag(nav.root?.route.pathComponent)
            }
        }
        .environment(navigator)
    }
}
