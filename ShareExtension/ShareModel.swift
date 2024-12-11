//
//  ShareModel.swift
//  ShareExtension
//
//  Created by Kanta Oikawa on 12/12/24.
//

import SwiftUI
import UniformTypeIdentifiers

@Observable
final class ShareModel: @unchecked Sendable {
    var extensionContext: NSExtensionContext?
    var url: URL?

    func configure(context: NSExtensionContext?) {
        Logger.standard.debug("Configuring")

        extensionContext = context

        guard
            let item = context?.inputItems.first as? NSExtensionItem,
            let itemProvider = item.attachments?.first,
            itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier)
        else {
            let error = ShareError.failedToGetURL
            Logger.standard.error("\(error.localizedDescription)")
            extensionContext?.cancelRequest(withError: error)
            return
        }

        Task {
            do {
                let data = try await itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier)
                self.url = data as? URL
            } catch {
                Logger.standard.error("\(error.localizedDescription)")
                extensionContext?.cancelRequest(withError: error)
            }
        }

        Logger.standard.debug("Configured")
    }

    func onSave() {
        Logger.standard.debug("Save Button Tapped")
        extensionContext?.completeRequest(returningItems: nil)
    }

    func onCancel() {
        Logger.standard.debug("Cancel Button Tapped")
        extensionContext?.cancelRequest(withError: ShareError.cancel)
    }

    enum ShareError: LocalizedError {
        case cancel
        case failedToGetURL

        var errorDescription: String? {
            switch self {
            case .cancel:
                "Cancelled"
            case .failedToGetURL:
                "Failed to get URL"
            }
        }
    }
}

extension NSExtensionContext: @retroactive @unchecked Sendable {}
