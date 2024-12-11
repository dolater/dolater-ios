//
//  BinView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct BinView: View {
    private let isFull: Bool

    init(isFull: Bool) {
        self.isFull = isFull
    }

    var body: some View {
        (isFull ? Image.binFull : Image.binEmpty)
            .resizable()
            .scaledToFit()
            .frame(width: 172, height: 172)
    }
}

#Preview {
    BinView(isFull: false)
    BinView(isFull: true)
}
