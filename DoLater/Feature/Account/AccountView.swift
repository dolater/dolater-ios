//
//  AccountView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct AccountView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: AccountPresenter<Environment>
    @Binding private var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        presenter = .init(path: path.wrappedValue)
        _path = path
    }

    var body: some View {
        NavigationStack(path: $presenter.state.path) {
            DLButton(.text("Sign Out")) {
                presenter.dispatch(.onSignOutButtonTapped)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.Semantic.Background.primary)
        }
        .sync($path, $presenter.state.path)
    }
}

#Preview {
    @Previewable @State var path: NavigationPath = .init()

    AccountView<MockEnvironment>(path: $path)
}
