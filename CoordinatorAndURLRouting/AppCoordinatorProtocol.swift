//
//  AppCoordinatorProtocol.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

protocol AppCoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }
    func push(_ screen:  Screen)
    func presentSheet(_ sheet: Sheet)
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenOver()
}

enum Screen: Identifiable, Hashable {
    case home
    case listHabit
    case detailHabit(named: Habit)

    var id: Self { return self }
}

enum Sheet: Identifiable, Hashable {
    case detailTask(named: Task)

    var id: Self { return self }
}

enum FullScreenCover: Identifiable, Hashable {
    case addHabit(onSaveButtonTap: ((Habit) -> Void))

    var id: Self { return self }
}

extension FullScreenCover {

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        switch self {
        case .addHabit:
            hasher.combine("addHabit")
        }
    }

    // MARK: - Equatable

    static func == (lhs: FullScreenCover, rhs: FullScreenCover) -> Bool {
        switch (lhs, rhs) {
        case (.addHabit, .addHabit):
            return true
        }
    }
}
