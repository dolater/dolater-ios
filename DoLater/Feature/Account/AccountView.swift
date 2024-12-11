//
//  AccountView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct AccountView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: AccountPresenter<Environment> = .init()

    var body: some View {
        DLButtonView(.text("Sign Out")) {
            presenter.dispatch(.onSignOutButtonTapped)
        }
    }
}

#Preview {
    AccountView<MockEnvironment>()
}
