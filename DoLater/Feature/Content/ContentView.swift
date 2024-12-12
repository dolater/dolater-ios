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
                            HomeView<Environment>(path: $presenter.state.homeNavigationPath)

                        case .account:
                            AccountView<Environment>(path: $presenter.state.accountNavigationPath)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    TabBarView(selection: $presenter.state.selection) {
                        withAnimation {
                            presenter.dispatch(.onPlusButtonTapped)
                        }
                    }
                    .onChange(of: presenter.state.selection) { _, _ in
                        presenter.dispatch(.onSelectedTabChanged)
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .overlay {
                    if presenter.state.isAddTaskDialogPresented {
                        DLDialog(
                            title: "あとまわしリンクを追加",
                            button: DLButton(.text("追加する"), isFullWidth: true) {
                                presenter.dispatch(.onAddTaskButtonTapped)
                            }
                        ) {
                            VStack(alignment: .leading, spacing: 4) {
                                DLTextField(
                                    "https://",
                                    text: $presenter.state.addingURLString,
                                    isFocused: .constant(true)
                                )
                                .keyboardType(.URL)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                if let errorText = presenter.state.addingURLAlert {
                                    Text(errorText)
                                        .font(.DL.note1)
                                        .foregroundStyle(Color.Semantic.Text.alert)
                                }
                            }
                        }
                        .padding(24)
                    }
                }

            case .unauthenticated:
                SignInView<Environment>()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Semantic.Background.primary)
        .onOpenURL { url in
            presenter.dispatch(.onOpenURL(url))
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
