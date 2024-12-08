//
//  PresenterProtocol.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/8/24.
//

@MainActor
protocol PresenterProtocol: Sendable {
    associatedtype State

    associatedtype Action

    var state: State { get set }

    func dispatch(_ action: Action)

    func dispatch(_ action: Action) async
}
