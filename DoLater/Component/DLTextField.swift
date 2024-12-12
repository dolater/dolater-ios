//
//  DLTextField.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI

struct DLTextField: View {
    private let label: String
    @Binding private var text: String

    init(_ label: String, text: Binding<String>) {
        self.label = label
        _text = text
    }

    var body: some View {
        TextField(label, text: $text)
            .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    @Previewable @State var text = ""

    DLTextField("Text Field", text: $text)
}
