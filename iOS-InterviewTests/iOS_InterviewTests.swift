//
//  iOS_InterviewTests.swift
//  iOS-InterviewTests
//
//  Created by Harry Li on 2022/6/30.
//

import XCTest
@testable import iOS_Interview

class MockCoreDataService: CoreDataService {
    func store(_ data: AllDataType) { }
    
    func fetchAll<T>(_ table: T.Type, completion: @escaping ([T]) -> Void) where T : AllDataType { }
    
    func store(_ table: CoreDataTable) { }
    func fetchAll<T: CoreDataTable>(_ table: T.Type, completion: @escaping ([T]) -> Void) { }
}

class iOS_InterviewTests: XCTestCase {
    
    var sut: CoreDataStorer!
    
    let mockCoreDataService = MockCoreDataService()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CoreDataStorer(coreDateService: mockCoreDataService)
        
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testSave() throws {
        let user = User(id: "1",
                        name: "test1",
                        email: "test1@gmail.com",
                        isDesigner: true)
        
        let convertUserTable = sut.save(user: user)
        
        XCTAssertEqual(convertUserTable.id, "1")
        XCTAssertEqual(convertUserTable.field_name, "test1")
        XCTAssertEqual(convertUserTable.field_email, "test1@gmail.com")
        XCTAssertEqual(convertUserTable.field_is_designer, true)
        
    }
    
    func testFetch() throws {
        let user = User(id: "1",
                        name: "test1",
                        email: "test1@gmail.com",
                        isDesigner: true)

        sut.fetch(user: user) { result in
    
            switch result {
            case .success(let testUser):
                XCTAssertEqual(testUser.id, user.id)
                XCTAssertEqual(testUser.name, user.name)
                XCTAssertEqual(testUser.email, user.email)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
    }
    
    func testPerformanceExample() throws {
        self.measure {
            
        }
    }
}
