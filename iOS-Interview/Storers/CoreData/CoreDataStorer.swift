//
//  CoreDataStorer.swift
//  iOS-Interview
//
//  Created by Harry Li on 2022/6/30.
//

import Foundation

final class CoreDataStorer {
    
    private let coreDateService: CoreDataService
    
    init(coreDateService: CoreDataService) {
        self.coreDateService = coreDateService
    }
}

extension CoreDataStorer {
    enum CoreDataStorerError: Error {
        case notFound
    }
}

extension CoreDataStorer {
    // TODO:
    // Step 1. Convert User to UserTable
    // Step 2. Save UserTable to CoreDataService (with .store(UserTable))
    func save(user: User) -> UserTable {
        let userTable = UserTable(id: user.id,
                                  field_name: user.name,
                                  field_email: user.email,
                                  field_is_designer: user.isDesigner,
                                  created_at: Date())
        coreDateService.store(userTable)
        return userTable
    }
    
    // TODO:
    // Step 1. Fetch user with specifically User.id
    // Step 1-1. if User.id is not exists in coreDateService than completion with notFound Failure
    // Step 1-2. if User.id is exists in coreDateService than convert it to User and completion with User Success
    func fetch(user: User, completion: @escaping (Result<User, CoreDataStorerError>) -> Void) {
        coreDateService.fetchAll(UserTable.self) { coreDataTables in
            for coreDataTable in coreDataTables {
                if coreDataTable.id == user.id {
                    let user = User(id: coreDataTable.id,
                                    name: coreDataTable.field_name,
                                    email: coreDataTable.field_email,
                                    isDesigner: coreDataTable.field_is_designer)
                    completion(.success(user))
                    break
                }
            }
            completion(.failure(CoreDataStorerError.notFound))
        }
    }
}
