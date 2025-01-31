//
//  Navigator.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

enum NavigatorError: Error {
    case rootPathDoesNotPresentInRoutes
}

typealias Parameters = [String: String]

@MainActor
@Observable
class Navigator {

    // MARK: - Properties

    var path = NavigationPath()
    let map: [RoutePath]
    var modalPath: String?
    var rootPath: String

    private(set) var root: RouteBox?

    private let parentNavigator: Navigator?
    private var modalMap: [RoutePath]?
    private var modalRoot: String?
    private var initialParameters: Parameters

    // MARK: - Initialization

    init(
        routes: [AnyRouteProtocol],
        root: String = "/",
        parent: Navigator? = nil,
        initialParameters: Parameters = [:]
    ) throws {
        self.rootPath = root
        guard let root = routes.first(where: { $0.path == root }) else {
            throw NavigatorError.rootPathDoesNotPresentInRoutes
        }
        self.parentNavigator = parent
        self.root = RouteBox(
            parameters: initialParameters,
            route: Crumb(pathComponent: root.path, isModal: root.isModal, build: root.build)
        )
        self.map = _BuildMap(routes: routes)
        self.initialParameters = initialParameters
    }

    init(map: [RoutePath], rootPath: String, parent: Navigator? = nil, initialParameters: Parameters) {
        self.rootPath = rootPath
        self.parentNavigator = parent
        self.map = map
        self.initialParameters = initialParameters
    }

    // MARK: - Public API

    func modalNavigator() -> Navigator {
        let modalRoot = modalRoot ?? "/"
        let nav = Navigator(
            map: modalMap ?? [],
            rootPath: modalRoot,
            parent: self,
            initialParameters: initialParameters
        )
        nav.go(to: modalPath ?? "/")
        return nav
    }

    func go(to path: String) {
        go(to: path, caller: nil)
    }

    func go(to path: String, caller: Navigator? = nil) {
        let relativePath = (path.hasSuffix("/" + rootPath) ? rootPath : nil)
            ?? path.range(of: rootPath + "/").map { String(path[$0.lowerBound...]) }

        guard
            let routes = findRoute(
                map: map,
                path: relativePath ?? path,
                accumulatedParams: initialParameters
            )
        else {
            if let parent = parentNavigator {
                parent.go(to: path, caller: self)
            } else {
                // TODO: parameterize NotFound
                (caller ?? self).path.append(
                    RouteBox(parameters: [:], route: Crumb(
                        pathComponent: "not-found",
                        isModal: false,
                        build: { _ in AnyView(Text("404: Page Not Found")) }
                    )))
            }
            return
        }

        rootPath = routes.first?.1.pathComponent ?? self.rootPath
        root = routes.first.map { RouteBox(parameters: $0.0, route: $0.1) }

        let path = routes.dropFirst()
        if let modalIndex = path.firstIndex(where: { $0.1.isModal == true }) {
            let navPath = path.prefix(modalIndex-1)
            self.path = NavigationPath(navPath.map(RouteBox.init))

            let newCrumbs = [path[modalIndex]] + path.dropFirst(modalIndex)

            let prev = ([rootPath] + path.prefix(modalIndex).map(\.1.pathComponent))
                .joined(separator: "/")
                .replacingOccurrences(of: "//", with: "/")

            modalPath = newCrumbs.map { $0.0[String($0.1.pathComponent.dropFirst())] ?? $0.1.pathComponent }.joined(separator: "/")
            initialParameters = newCrumbs.first?.0 ?? initialParameters

            modalRoot = path[modalIndex].1.pathComponent

            modalMap = map.filter { $0.path.hasPrefix(prev) }.map { routePath in
                let newCrumbs = routePath.crumbs.drop { $0.pathComponent != modalRoot}
                return RoutePath(path: newCrumbs.map(\.pathComponent).joined(separator: "/"), crumbs: Array(newCrumbs))
            }
        } else {
            self.modalMap = nil
            self.modalPath = nil
            self.path = NavigationPath(path.map(RouteBox.init))
        }
    }
}

struct Crumb {

    // MARK: - Properties

    let pathComponent: String
    let isModal: Bool
    let build: (Parameters) -> AnyView
}

struct RoutePath {

    // MARK: - Properties

    let path: String
    let crumbs: [Crumb]
}

@MainActor
func _BuildMap(routes: [AnyRouteProtocol]) -> [RoutePath] {
    routes.map { _buildMap(route: $0) }.flatMap { $0 }
}

@MainActor
func _buildMap(route: AnyRouteProtocol) -> [RoutePath] {
    let currentCrumb = Crumb(pathComponent: route.path, isModal: route.isModal, build: route.build)

    return route.children.map {
        _buildMap(route: $0).map { child in
            RoutePath(
                path: (route.path + "/" + child.path).replacingOccurrences(of: "//", with: "/"),
                crumbs: [currentCrumb] + child.crumbs
            )
        }
    }.flatMap { $0 } + [RoutePath(path: route.path, crumbs: [currentCrumb])]
}

func findRoute(map: [RoutePath], path: String, accumulatedParams: Parameters) -> [(Parameters, Crumb)]? {
    map.map {
        extract(pattern: $0, path: path, accumulatedParams: accumulatedParams)
    }.first(where: { $0 != nil }) ?? nil
}

func extract(pattern: RoutePath, path: String, accumulatedParams: Parameters) -> [(Parameters, Crumb)]? {
    var pathComponents = path.splitIncludingRoot()
    let components = pattern.crumbs

    var result: [(Parameters, Crumb)] = []
    var params = accumulatedParams

    for component in components {
        for subComponent in component.pathComponent.splitIncludingRoot() {
            if pathComponents.isEmpty { return nil }
            if subComponent.hasPrefix(":") {
                let paramName = String(subComponent.dropFirst())
                let param = String(pathComponents[0])
                params[paramName] = param
                pathComponents = Array(pathComponents.dropFirst())
            } else if pathComponents[0] == subComponent {
                pathComponents = Array(pathComponents.dropFirst())
            } else {
                return nil
            }
        }
        result.append((params, component))
    }

    return pathComponents.isEmpty ? result : nil
}

private extension String {
    func splitIncludingRoot() -> [String] {
        if hasPrefix("/") {
            return ["/"] + split(separator: "/").map(String.init)
        }

        return split(separator: "/").map(String.init)
    }
}
