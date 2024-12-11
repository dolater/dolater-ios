//
//  TrashView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

struct TrashView: View {
    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: 64, height: 64)
            .overlay {
                Text("Trash")
                    .foregroundStyle(.white)
            }
    }

    static var uiView: UIView {
        UIHostingController(rootView: TrashView()).view
    }
}

#Preview {
    TrashView()
}
