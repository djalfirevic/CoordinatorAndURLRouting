//
//  Task.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import Foundation

struct Task: Identifiable, Hashable, Equatable {

    // MARK: - Properties
    
    let id = UUID()
    let title: String
    let description: String
}
