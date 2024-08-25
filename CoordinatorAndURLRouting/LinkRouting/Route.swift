//
//  Route.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

@MainActor
struct Route<Content: View>: AnyRouteProtocol {

    // MARK: - Properties

    let path: String
    let builder: (Parameters) -> Content
    let children: [AnyRouteProtocol]
    let isModal: Bool

    // MARK: - Initialization

    init(
        path: String,
        @ViewBuilder builder: @escaping (Parameters) -> Content,
        children: [AnyRouteProtocol] = [],
        isModal: Bool = false
    ) {
        self.path = path
        self.builder = builder
        self.children = children
        self.isModal = isModal
    }

    // MARK: - Public API

    func build(slug: Parameters) -> AnyView {
        AnyView(builder(slug))
    }
}

@MainActor
struct TabRoute<Content: View, Label: View>: AnyTabRouteProtocol {

    // MARK: - Properties

    public var path: String
    public let isModal = false
    public var children: [any AnyRouteProtocol]
    let builder: (Parameters) -> Content
    let labelBuilder: () -> Label

    // MARK: - Initialization

    init(
        path: String,
        @ViewBuilder builder: @escaping (Parameters) -> Content,
        @ViewBuilder labelBuilder: @escaping () -> Label,
        children: [any AnyRouteProtocol]
    ) {
        self.path = path
        self.children = children
        self.builder = builder
        self.labelBuilder = labelBuilder
    }

    // MARK: - Public API

    func build(slug: Parameters) -> AnyView {
        AnyView(builder(slug))
    }

    func buildLabel() -> AnyView {
        AnyView(labelBuilder())
    }
}
