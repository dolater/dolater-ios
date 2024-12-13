//
//  TaskDetailView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI

struct TaskDetailView: View {
    private let task: DLTask
    @State private var title: String

    init(task: DLTask) {
        self.task = task
        title = task.url.host() ?? ""
    }

    var body: some View {
        WebView(url: task.url)
            .task {
                do {
                    title = try await HTTPMetadata.getPageTitle(for: task.url)
                } catch {
                    title = task.url.host() ?? ""
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.Semantic.Background.primary, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了にする") {}
                }
            }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(task: .mock1)
    }
}
