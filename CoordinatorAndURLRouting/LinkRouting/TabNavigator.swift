//
//  TabNavigator.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

@MainActor
@Observable
final class TabNavigator: Navigator {

    // MARK: - Properties

    var navigators: [Navigator] = []

    // MARK: - Initialization

    internal init(tabs: [AnyRouteProtocol], rootPath: String = "/") throws {
        try super.init(routes: tabs, root: rootPath)
        self.navigators = tabs.map { [unowned self] in
            try! Navigator(routes: [$0], root: $0.path, parent: self)
        }
    }

    // MARK: - Navigator

    override func go(to path: String, caller: Navigator? = nil) {
        let nav = navigators.first { nav in
            nav.map.map(\.path).contains(path)
        }

        guard let nav else {
            let current = navigators.first(where: { nav in nav.rootPath == rootPath })
            current?.path.append(RouteBox(parameters: [:], route: Crumb(pathComponent: "not-found", isModal: false, build: { _ in
                AnyView(Text("404: Page Not Found"))
            })))
            return
        }

        rootPath = nav.rootPath
        nav.go(to: path)
    }
}
