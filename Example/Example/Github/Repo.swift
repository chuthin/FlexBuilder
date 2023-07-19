//
//  Repo.swift
//  BuilderUI
//
//  Created by Chu Thin on 19/07/2023.
//

import Foundation
import FlexBuilder
extension Repo : Identifier {}

public struct Repo : Codable {
    public let name:String?
    public let description: String?
    public let html_url: String?
}

public struct RepoResponse : Codable {
    public let total:Int64?
    public let items:[Repo]?
}
