//
//  HomeView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct HomeView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: HomePresenter<Environment> = .init()

    var body: some View {
        TrashMountainView()
    }
}

#Preview {
    HomeView<MockEnvironment>()
}
