//
//  TaskLabelView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TaskLabelView: View {
    private let url: URL?
    @State private var title: String
    @State private var imageURL: URL?
    @State private var isTitleLoading: Bool = false

    init(url: URL) {
        self.url = url
        self.title = ""
        self.imageURL = nil
    }

    init(title: String, imageURL: URL?) {
        self.url = nil
        self.title = title
        self.imageURL = imageURL
    }

    var body: some View {
        HStack(spacing: 4) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    Circle()
                        .fill(Color.Semantic.Text.secondary)
                        .frame(width: 16, height: 16)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)

                case .failure:
                    globe

                @unknown default:
                    globe
                }
            }

            if isTitleLoading {
                VStack(spacing: 2) {
                    Rectangle()
                        .fill(Color.Semantic.Text.secondary)
                        .padding(1)
                    Rectangle()
                        .fill(Color.Semantic.Text.secondary)
                        .padding(1)
                }
                .frame(maxWidth: .infinity, maxHeight: 26)
            } else {
                Text(title)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.DL.note1)
                    .lineSpacing(2)
                    .frame(height: 26, alignment: .leading)
            }
        }
        .foregroundStyle(Color.Semantic.Text.primary)
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(Color.Semantic.Background.secondary)
        .clipShape(Capsule())
        .shadow()
        .task {
            guard let url else {
                return
            }
            imageURL = url.favicon
            isTitleLoading = true
            defer { isTitleLoading = false }
            do {
                title = try await HTTPMetadata.getPageTitle(for: url)
            } catch {
                title = ""
            }
        }
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
        url: DLTask.mock1.url
    )
}
