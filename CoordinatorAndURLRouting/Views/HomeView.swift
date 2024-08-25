//
//  HomeView.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(systemName: "house")
                .foregroundStyle(.tint)
                .imageScale(.large)
            
            Text("Home")
            
            Spacer()
            
            Button("Go to Habit List") {
                appCoordinator.push(.listHabit)
            }
        }
        .navigationTitle("Home")
        
    }
}

#Preview {
    HomeView()
}
