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
        
        // Question 2
        case wrongDataType
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


// Question 2
extension CoreDataStorer {
    func saveAll(data: DataType) {
        switch data {
        case .userTable(let userTable):
            coreDateService.store(userTable)
            
        case .productTable(let productTable):
            coreDateService.store(productTable)
            
        default:
            break
            
        }
    }
    
    func fetchAll(data: DataType, completion: @escaping (Result<DataType, CoreDataStorerError>) -> Void) {
        coreDateService.fetchAll(DataType.self) { data in
            for datum in data {
                switch datum {
                case .userTable(let userTable):
                    let user = User(id: userTable.id,
                                    name: userTable.field_name,
                                    email: userTable.field_email,
                                    isDesigner: userTable.field_is_designer)
                    let dataUser = DataType.user(user)
                    completion(.success(dataUser))
                    
                case .productTable(let productTable):
                    let user = User(id: productTable.user.id,
                                    name: productTable.user.field_name,
                                    email: productTable.user.field_email,
                                    isDesigner: productTable.user.field_is_designer)
                    let product = Product(id: productTable.id,
                                          title: productTable.field_title,
                                          description: productTable.field_description,
                                          price: productTable.field_price,
                                          user: user)
                    let dataProduct = DataType.product(product)
                    completion(.success(dataProduct))
                    
                default:
                    completion(.failure(CoreDataStorerError.wrongDataType))
                    
                }
            }
            completion(.failure(CoreDataStorerError.notFound))
        }
    }
}
