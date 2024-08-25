//
//  RouteBox.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

struct RouteBox: Hashable {

    // MARK: - Properties

    let route: Crumb
    let parameters: Parameters

    // MARK: - Initialization

    init(parameters: Parameters, route: Crumb) {
        self.route = route
        self.parameters = parameters
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(route.pathComponent)
    }

    // MARK: - Equatable

    static func == (lhs: RouteBox, rhs: RouteBox) -> Bool {
        lhs.route.pathComponent == rhs.route.pathComponent
    }
}

// MARK: - Decodable

extension RouteBox: Codable {
    enum CodingKeys: String, CodingKey {
        case path
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(route.pathComponent, forKey: .path)
    }

    init(from decoder: any Decoder) throws {
        fatalError("Not implemented")
    }
}
