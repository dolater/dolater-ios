//
//  DLButton.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct DLButton: View {
    enum ButtonType {
        case icon(_ systemName: String)
        case text(_ label: String)
    }

    private let type: ButtonType
    private let isFullWidth: Bool
    private let action: () -> Void

    init(
        _ type: ButtonType,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.isFullWidth = isFullWidth
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Group {
                switch type {
                case .icon(let systemName):
                    Image(systemName: systemName)
                        .font(.DL.button)
                        .frame(width: 44, height: 44)
                        .background(Color.Semantic.Background.tertiary)
                        .clipShape(Circle())

                case .text(let label):
                    Text(label)
                        .font(.DL.button)
                        .padding(.horizontal, 18)
                        .frame(height: 44)
                        .background(Color.Semantic.Background.tertiary)
                        .clipShape(Capsule())
                }
            }
            .foregroundStyle(Color.Semantic.Text.inversePrimary)
            .shadow()
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        DLButton(.icon("plus")) {}

        DLButton(.text("追加する")) {}
    }
}
