//
//  TrashView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TrashView: View {
    private let task: DLTask
    private let size: CGFloat

    init(task: DLTask, size: CGFloat) {
        self.task = task
        self.size = size
    }

    var body: some View {
        task.status.image
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .overlay {
                TaskLabelView(title: task.title, imageURL: task.faviconURL)
                    .frame(width: size * 1.2)
            }
    }
}

#Preview {
    TrashView(task: .mock1, size: 50)
    TrashView(task: .mock2, size: 100)
    TrashView(task: .mock3, size: 172)
}
