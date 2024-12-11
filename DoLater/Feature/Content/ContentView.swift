//
//  ContentView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import SwiftUI

struct ContentView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: ContentPresenter<Environment> = .init()

    var body: some View {
        Group {
            switch presenter.state.authStatus {
            case .unchecked:
                ProgressView()

            case .authenticated:
                VStack(spacing: 0) {
                    Group {
                        switch presenter.state.selection {
                        case .home:
                            HomeView<Environment>()
                        case .account:
                            AccountView<Environment>()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    TabBarView(selection: $presenter.state.selection) {
                        withAnimation {
                            presenter.dispatch(.onPlusButtonTapped)
                        }
                    }
                }

            case .unauthenticated:
                SignInView<Environment>()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Semantic.Background.primary.color)
#if DEBUG
        .sheet(isPresented: $presenter.state.isDebugScreenPresented) {
            DebugView<Environment>()
        }
        .onReceive(
            NotificationCenter.default.publisher(for: .deviceDidShakeNotification)
        ) { _ in
            presenter.state.isDebugScreenPresented = true
        }
#endif
    }
}

#Preview {
    ContentView<MockEnvironment>()
}

#if DEBUG
extension NSNotification.Name {
    static let deviceDidShakeNotification = NSNotification.Name(
        "DeviceDidShakeNotification"
    )
}

extension UIWindow {
    open override func motionEnded(
        _ motion: UIEvent.EventSubtype,
        with event: UIEvent?
    ) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(
            name: .deviceDidShakeNotification,
            object: event
        )
    }
}
#endif
