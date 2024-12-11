//
//  TaskLabelView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TaskLabelView: View {
    private let title: String
    private let imageURL: URL?

    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }

    var body: some View {
        HStack(spacing: 4) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    globe

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)

                case .failure(let error):
                    globe

                @unknown default:
                    globe
                }
            }

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

    private var globe: some View {
        Image(systemName: "globe")
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
    }
}

#Preview {
    TaskLabelView(
        title: DLTask.mock1.title,
        imageURL: DLTask.mock1.faviconURL
    )
}
