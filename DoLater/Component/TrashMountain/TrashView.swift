//
//  TrashView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TrashView: View {
    private let status: TrashStatus
    private let size: CGFloat

    init(status: TrashStatus, size: CGFloat) {
        self.status = status
        self.size = size
    }

    var body: some View {
        status.image
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

#Preview {
    TrashView(status: .opened, size: 120)
    TrashView(status: .half, size: 120)
    TrashView(status: .closed, size: 120)
}
