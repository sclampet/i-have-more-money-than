//
//  NetworkManagerTests.swift
//  I Have More Money ThanTests
//
//  Created by Scott Clampet on 9/7/19.
//  Copyright © 2019 Scott Clampet. All rights reserved.
//

import XCTest
@testable import I_Have_More_Money_Than

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    let mockURLSession = MockURLSession()
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
        networkManager.session = mockURLSession
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
     }
    
    func testExpectedURLHost() {
        networkManager.getAccounts(from: BaseURL.allAccounts) { (response) in
            return
        }
        
        XCTAssertEqual(mockURLSession.cachedUrl?.host, "glacial-bayou-77287.herokuapp.com")
    }
    
    func testExpectedURLPath() {
        networkManager.getAccounts(from: BaseURL.allAccounts) { (response) in
            return
        }
        
        XCTAssertEqual(mockURLSession.cachedUrl?.path, "/listAccounts")
    }
    

}

class MockURLSession: URLSession {
    
    var cachedUrl: URL?
    var accounts: [Account]?
    
    override func dataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.cachedUrl = url
        return URLSessionDataTask()
    }
}
