//
//  AddTaskView.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/13/24.
//

import SwiftUI

struct AddTaskView: View {
    @Binding private var text: String
    @Binding private var isTextFieldFocused: Bool
    private let errorText: String?
    private let onDismissAction: () -> Void
    private let onConfirmAction: () -> Void

    init(
        text: Binding<String>,
        isTextFieldFocused: Binding<Bool>,
        errorText: String?,
        onDismiss onDismissAction: @escaping () -> Void,
        onConfirm onConfirmAction: @escaping () -> Void
    ) {
        _text = text
        _isTextFieldFocused = isTextFieldFocused
        self.errorText = errorText
        self.onDismissAction = onDismissAction
        self.onConfirmAction = onConfirmAction
    }

    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                onDismissAction()
            }
            .overlay {
                DLDialog(
                    title: "あとまわしリンクを追加",
                    button: DLButton(.text("追加する"), isFullWidth: true) {
                        onConfirmAction()
                    }
                ) {
                    VStack(alignment: .leading, spacing: 4) {
                        DLTextField(
                            "https://",
                            text: $text,
                            isFocused: $isTextFieldFocused
                        )
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        if let errorText {
                            Text(errorText)
                                .font(.DL.note1)
                                .foregroundStyle(Color.Semantic.Text.alert)
                        }
                    }
                }
                .padding(24)
            }
            .overlay(alignment: .topTrailing) {
                DLButton(.icon("xmark"), style: .secondary) {
                    onDismissAction()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var isTextFieldFocused: Bool = false

    AddTaskView(text: $text, isTextFieldFocused: $isTextFieldFocused,errorText: nil) {
    } onConfirm: {
    }
}
