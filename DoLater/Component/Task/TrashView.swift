//
//  TrashView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TrashView: View {
    private let task: DLTask

    init(task: DLTask) {
        self.task = task
    }

    var body: some View {
        task.trashImage
            .resizable()
            .scaledToFit()
            .frame(width: task.size, height: task.size)
            .overlay {
                TaskLabelView(url: task.url)
                    .frame(width: task.size * 1.2)
            }
    }
}

#Preview {
    TrashView(task: .mock1)
    TrashView(task: .mock2)
    TrashView(task: .mock3)
}
