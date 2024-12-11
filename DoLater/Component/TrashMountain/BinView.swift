//
//  BinView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct BinView: View {
    private let isFull: Bool
    private let size: CGFloat

    init(isFull: Bool, size: CGFloat) {
        self.isFull = isFull
        self.size = size
    }

    var body: some View {
        (isFull ? Image.binFull : Image.binEmpty)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

#Preview {
    BinView(isFull: false, size: 120)
    BinView(isFull: true, size: 120)
}
