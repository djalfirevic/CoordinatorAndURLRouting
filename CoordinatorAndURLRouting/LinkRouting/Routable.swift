//
//  Routable.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

@MainActor
protocol AnyRouteProtocol {
    var path: String { get }
    var children: [AnyRouteProtocol] { get }
    var isModal: Bool { get }
    func build(slug: Parameters) -> AnyView
}

protocol AnyTabRouteProtocol: AnyRouteProtocol {
    func buildLabel() -> AnyView
}
