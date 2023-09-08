//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Chu Thin on 19/07/2023.
//

import XCTest
@testable import Example

final class ExampleTests: XCTestCase {
    let state = GithubState.data(GithubData())
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQuery() throws {
        var newState = GihubReducer<GithubState>.reduce(state: state, action: .query("apple"))
        XCTAssertTrue( newState.query == "https://api.github.com/search/repositories?q=apple&page=1&per_page=20" )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .loadMore)
        XCTAssertTrue( newState.query == "https://api.github.com/search/repositories?q=apple&page=1&per_page=20" )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .loadMore)
        XCTAssertTrue( newState.query == "https://api.github.com/search/repositories?q=apple&page=1&per_page=20" )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .repos([]))
        XCTAssertTrue( newState.query == nil )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .loadMore)
        XCTAssertTrue( newState.query == "https://api.github.com/search/repositories?q=apple&page=2&per_page=20" )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .goDetail(Repo(name: "", description: "", html_url: "")))
        XCTAssertTrue( newState.query == nil )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .more(Repo(name: "", description: "", html_url: "")))
        XCTAssertTrue( newState.query == nil )
    }

    func testLoading() throws {
        var newState = GihubReducer<GithubState>.reduce(state: state, action: .query("apple"))
        XCTAssertTrue( newState.isLoading == true )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .loadMore)
        XCTAssertTrue( newState.isLoading == true )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .repos([]))
        XCTAssertTrue( newState.isLoading == false )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .goDetail(Repo(name: "", description: "", html_url: "")))
        XCTAssertTrue( newState.isLoading == false )
        newState  = GihubReducer<GithubState>.reduce(state: newState, action: .more(Repo(name: "", description: "", html_url: "")))
        XCTAssertTrue( newState.isLoading == false )
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
