//
//  MockNetwork.swift
//  ExampleTests
//
//  Created by Chu Thin on 07/09/2023.
//

import Foundation
import Example
class MockNetwork : Network {
    func getRepo(url: String, result: @escaping ([Example.Repo]) -> Void) {
        result([])
    }
}
