//
//  TaskDetailView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI

struct TaskDetailView: View {
    private let task: DLTask
    private let onMarkAsDoneAction: () -> Void
    private let onMarkAsToDoAction: () -> Void
    @State private var title: String

    init(
        task: DLTask,
        onMarkAsDone onMarkAsDoneAction: @escaping () -> Void,
        onMarkAsToDo onMarkAsToDoAction: @escaping () -> Void
    ) {
        self.task = task
        self.onMarkAsDoneAction = onMarkAsDoneAction
        self.onMarkAsToDoAction = onMarkAsToDoAction
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.Semantic.Background.primary, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.DL.body1)
                        .foregroundStyle(Color.Semantic.Text.primary)
                        .lineLimit(1)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if task.isCompleted || task.isArchived {
                        Button("未完了にする") {
                            onMarkAsToDoAction()
                        }
                    } else {
                        Button("完了にする") {
                            onMarkAsDoneAction()
                        }
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(task: .mock1) {
        } onMarkAsToDo: {
        }
    }
}
