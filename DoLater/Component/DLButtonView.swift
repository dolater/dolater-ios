//
//  DLButtonView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct DLButtonView: View {
    enum ButtonType {
        case icon(_ systemName: String)
        case text(_ label: String)
    }

    private let type: ButtonType
    private let action: () -> Void

    init(
        _ type: ButtonType,
        action: @escaping () -> Void
    ) {
        self.type = type
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
                        .background(Color.Semantic.Background.tertiary.color)
                        .clipShape(Circle())

                case .text(let label):
                    Text(label)
                        .font(.DL.button)
                        .padding(.horizontal, 18)
                        .frame(height: 44)
                        .background(Color.Semantic.Background.tertiary.color)
                        .clipShape(Capsule())
                }
            }
            .foregroundStyle(Color.Semantic.Text.inversePrimary.color)
            .shadow()
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        DLButtonView(.icon("plus")) {}

        DLButtonView(.text("追加する")) {}
    }
}
