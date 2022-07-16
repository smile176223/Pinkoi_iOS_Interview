//
//  CoreDataService.swift
//  iOS-Interview
//
//  Created by Harry Li on 2022/6/30.
//

import Foundation

// Question 2
protocol AllDataType { }

// Question 2
enum DataType: AllDataType {
    case user(User)
    case product(Product)
    case userTable(CoreDataStorer.UserTable)
    case productTable(CoreDataStorer.ProductTable)
}

protocol CoreDataService {
    func store(_ table: CoreDataTable)
    func fetchAll<T: CoreDataTable>(_ table: T.Type, completion: @escaping ([T]) -> Void)
    
    // Question 2
    func store(_ data: AllDataType)
    func fetchAll<T: AllDataType>(_ table: T.Type, completion: @escaping ([T]) -> Void)
}
