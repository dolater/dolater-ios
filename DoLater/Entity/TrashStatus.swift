//
//  TrashStatus.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

enum TrashStatus {
    case opened
    case half
    case closed

    var image: Image {
        switch self {
        case .opened: .trashOpened
        case .half: .trashHalf
        case .closed: .trashClosed
        }
    }
}
