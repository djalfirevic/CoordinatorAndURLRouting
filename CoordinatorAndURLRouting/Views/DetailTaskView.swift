//
//  DetailTaskView.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

struct DetailTaskView: View {
    @EnvironmentObject private var appCoordinator: AppCoordinatorImpl
    
    let task: Task
    
    var body: some View {
        NavigationStack {
            List {
                Text(task.title)
                    .font(.headline)
                
                Text(task.description)
                    .foregroundStyle(.secondary)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        appCoordinator.dismissSheet()
                    }
                }
            }
        }
    }
}

#Preview {
    DetailTaskView(task: Habit.habitsDummy[0].tasks[0])
}
