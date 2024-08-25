//
//  NamedView.swift
//  CoordinatorAndURLRouting
//
//  Created by Djuro on 8/25/24.
//

import SwiftUI

struct NamedView: View {

    // MARK: - Properties

    let text: String

    // MARK: - View

    var body: some View {
        Text(text)
    }
}

#Preview {
    NamedView(text: "Hello World")
}
