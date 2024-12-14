//
//  ThrowView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/15/24.
//

import SpriteKit
import SwiftUI

struct ThrowView<Environment: EnvironmentProtocol>: View {
    @State private var presenter: ThrowPresenter<Environment>

    init(tasks: [DLTask]) {
        self.presenter = .init(tasks: tasks)
    }

    var body: some View {
        SpriteView(
            scene: presenter.state.scene,
            options: [.allowsTransparency]
        )
        .background(Color.Semantic.Background.primary)
        .overlay {
        }
        .overlay {
            BinView(isFull: true)
                .frame(width: 320)
        }
    }
}

#Preview {
    ThrowView<MockEnvironment>(tasks: DLTask.mocks)
}
