//
//  DetailHabitView.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

struct DetailHabitView: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    
    let habit: Habit
    
    var body: some View {
        VStack {
            List(habit.tasks) { task in
                Button {
                    appCoordinator.presentSheet(.detailTask(named: task))
                } label: {
                    Text(task.title)
                }
            }
        }
        .navigationTitle(habit.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Home") {
                    appCoordinator.popToRoot()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailHabitView(habit: .habitsDummy[0])
    }
}
