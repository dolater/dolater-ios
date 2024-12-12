//
//  HomeView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct HomeView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: HomePresenter<Environment>
    @Binding private var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        presenter = .init(path: path.wrappedValue)
        _path = path
    }

    var body: some View {
        TrashMountainView()
            .sync($path, $presenter.state.path)
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()

    HomeView<MockEnvironment>(path: $path)
}
