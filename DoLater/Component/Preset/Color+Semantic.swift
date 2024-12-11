//
//  Color+Semantic.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/11/24.
//

import SwiftUI

extension Color {
    enum Semantic {
        enum Background {
            case primary
            case secondary
            case tertiary

            var color: Color {
                switch self {
                case .primary: .init(.Primitive.gray2)
                case .secondary: .init(.Primitive.white)
                case .tertiary: .init(.Primitive.black)
                }
            }
        }

        enum Shadow {
            case primary

            var color: Color {
                switch self {
                case .primary: .init(.Primitive.gray3)
                }
            }
        }

        enum Text {
            case primary
            case secondary
            case inversePrimary

            var color: Color {
                switch self {
                case .primary: .init(.Primitive.black)
                case .secondary: .init(.Primitive.gray)
                case .inversePrimary: .init(.Primitive.white)
                }
            }
        }
    }
}
