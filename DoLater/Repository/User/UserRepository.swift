//
//  UserRepository.swift
//  DoLater
//
//  Created by Kanta Oikawa on 12/10/24.
//

protocol UserRepositoryProtocol: Actor {
    func getUsers() async throws -> [Components.Schemas.User]

    func createUser() async throws -> Components.Schemas.User

    func getUser(id: Components.Parameters.id) async throws -> Components.Schemas.User

    func updateUser(_ user: Components.Schemas.UpdateUserInput, id: Components.Parameters.id)
        async throws -> Components.Schemas.User

    func deleteUser(id: Components.Parameters.id) async throws
}

final actor UserRepositoryImpl: UserRepositoryProtocol {
    init() {}

    func getUsers() async throws -> [Components.Schemas.User] {
        do {
            let client = try await Client.build()
            let response = try await client.getUsers()
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .internalServerError(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.internalServerError, error.message)
                }
                throw RepositoryError.server(.internalServerError, nil)

            case .undocumented(let statusCode, let payload):
                throw RepositoryError.server(.init(rawValue: statusCode), payload)
            }
        } catch let error as RepositoryError {
            Logger.standard.error("RepositoryError: \(error.localizedDescription)")
            throw error
        } catch {
            Logger.standard.error("RepositoryError: \(error)")
            throw error
        }
    }

    func createUser() async throws -> Components.Schemas.User {
        do {
            let client = try await Client.build()
            let response = try await client.createUser()
            switch response {
            case .created(let okResponse):
                if case let .json(user) = okResponse.body {
                    return user
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .internalServerError(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.internalServerError, error.message)
                }
                throw RepositoryError.server(.internalServerError, nil)

            case .undocumented(let statusCode, let payload):
                throw RepositoryError.server(.init(rawValue: statusCode), payload)
            }
        } catch let error as RepositoryError {
            Logger.standard.error("RepositoryError: \(error.localizedDescription)")
            throw error
        } catch {
            Logger.standard.error("RepositoryError: \(error)")
            throw error
        }
    }

    func getUser(id: Components.Parameters.id) async throws -> Components.Schemas.User {
        do {
            let client = try await Client.build()
            let response = try await client.getUser(path: .init(uid: id))
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .notFound(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.notFound, error.message)
                }
                throw RepositoryError.server(.notFound, nil)

            case .internalServerError(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.internalServerError, error.message)
                }
                throw RepositoryError.server(.internalServerError, nil)

            case .undocumented(let statusCode, let payload):
                throw RepositoryError.server(.init(rawValue: statusCode), payload)
            }
        } catch let error as RepositoryError {
            Logger.standard.error("RepositoryError: \(error.localizedDescription)")
            throw error
        } catch {
            Logger.standard.error("RepositoryError: \(error)")
            throw error
        }
    }

    func updateUser(_ user: Components.Schemas.UpdateUserInput, id: Components.Parameters.id)
        async throws -> Components.Schemas.User
    {
        do {
            let client = try await Client.build()
            let response = try await client.updateUser(
                path: .init(uid: id),
                body: .json(user)
            )
            switch response {
            case .ok(let okResponse):
                if case let .json(users) = okResponse.body {
                    return users
                }
                throw RepositoryError.invalidResponseBody(okResponse.body)

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .notFound(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.notFound, error.message)
                }
                throw RepositoryError.server(.notFound, nil)

            case .internalServerError(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.internalServerError, error.message)
                }
                throw RepositoryError.server(.internalServerError, nil)

            case .undocumented(let statusCode, let payload):
                throw RepositoryError.server(.init(rawValue: statusCode), payload)
            }
        } catch let error as RepositoryError {
            Logger.standard.error("RepositoryError: \(error.localizedDescription)")
            throw error
        } catch {
            Logger.standard.error("RepositoryError: \(error)")
            throw error
        }
    }

    func deleteUser(id: Components.Parameters.id) async throws {
        do {
            let client = try await Client.build()
            let response = try await client.deleteUser(path: .init(uid: id))
            switch response {
            case .noContent:
                return

            case .unauthorized(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.unauthorized, error.message)
                }
                throw RepositoryError.server(.unauthorized, nil)

            case .notFound(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.notFound, error.message)
                }
                throw RepositoryError.server(.notFound, nil)

            case .internalServerError(let errorResponse):
                if case let .json(error) = errorResponse.body {
                    throw RepositoryError.server(.internalServerError, error.message)
                }
                throw RepositoryError.server(.internalServerError, nil)

            case .undocumented(let statusCode, let payload):
                throw RepositoryError.server(.init(rawValue: statusCode), payload)
            }
        } catch let error as RepositoryError {
            Logger.standard.error("RepositoryError: \(error.localizedDescription)")
            throw error
        } catch {
            Logger.standard.error("RepositoryError: \(error)")
            throw error
        }
    }
}
