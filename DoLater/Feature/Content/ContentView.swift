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
                Text("Authenticated.")

            case .unauthenticated:
                SignInView<Environment>()
            }
        }
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
