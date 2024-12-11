//
//  DebugView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

import SwiftUI

struct DebugView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: DebugPresenter<Environment> = .init()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Server Environment", selection: $presenter.state.serverEnvironment) {
                        ForEach(ServerEnvironment.allCases) { item in
                            Text(item.rawValue.capitalized)
                                .tag(item)
                        }
                    }
                    .onChange(of: presenter.state.serverEnvironment) { _, _ in
                        presenter.dispatch(.onServerEnvironmentChanged)
                    }
                    LabeledContent(
                        "URL",
                        value: presenter.state.serverEnvironment.apiServerURL.absoluteString
                    )
                    .contextMenu {
                        Button("Copy", systemImage: "document.on.document") {
                            UIPasteboard.general.url =
                                presenter.state.serverEnvironment.apiServerURL
                        }
                    }
                }

                Section {
                    Text(presenter.state.appCheckToken)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .contextMenu {
                            Button("Copy", systemImage: "document.on.document") {
                                UIPasteboard.general.string = presenter.state.appCheckToken
                            }
                        }
                } header: {
                    Text("Firebase AppCheck Token")
                }

                Section {
                    Text(presenter.state.fcmToken)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .contextMenu {
                            Button("Copy", systemImage: "document.on.document") {
                                UIPasteboard.general.string = presenter.state.fcmToken
                            }
                        }
                } header: {
                    Text("FCM Registration Token")
                }

                Section {
                    Text(presenter.state.idToken)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .contextMenu {
                            Button("Copy", systemImage: "document.on.document") {
                                UIPasteboard.general.string = presenter.state.idToken
                            }
                        }
                } header: {
                    Text("ID Token")
                }

                Section {
                    Button("Sign Out", role: .destructive) {
                        presenter.dispatch(.onSignOutButtonTapped)
                    }
                }
            }
            .navigationTitle("Debug")
            .disabled(presenter.state.isLoading)
        }
        .task {
            await presenter.dispatch(.onAppear)
        }
        .errorAlert(dataStatus: presenter.state.getServerEnvironmentStatus)
        .errorAlert(dataStatus: presenter.state.setServerEnvironmentStatus)
        .errorAlert(dataStatus: presenter.state.getAppCheckTokenStatus)
        .errorAlert(dataStatus: presenter.state.getFCMTokenStatus)
        .errorAlert(dataStatus: presenter.state.getIDTokenStatus)
    }
}

#Preview {
    DebugView<MockEnvironment>()
}