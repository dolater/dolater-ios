//
//  TaskLabelView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TaskLabelView: View {
    private let title: String
    private let image: Image

    init(title: String, image: Image?) {
        self.title = title
        if let image {
            self.image = image
        } else {
            self.image = Image(systemName: "questionmark.circle")
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)

            Text(title)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .font(.DL.note1)
        }
        .foregroundStyle(Color.Semantic.Text.primary)
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(Color.Semantic.Background.secondary)
        .clipShape(Capsule())
        .shadow()
    }
}

#Preview {
    TaskLabelView(
        title: "Apple Developer Documentation Human Interface Guidelines | Apple Developer Documentation",
        image: nil
    )
}
