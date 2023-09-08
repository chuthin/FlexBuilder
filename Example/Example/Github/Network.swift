//
//  Network.swift
//  BuilderUI
//
//  Created by Chu Thin on 19/07/2023.
//

import Foundation
import RxSwift
public protocol Network {
    func getRepo(url: String, result:@escaping ([Repo]) -> Void)
}

extension Network {
    func getRepo(url:String) -> Single<[Repo]> {
        return Single<[Repo]>.create{ single in
            getRepo(url: url, result: {
                single(.success($0))
            })
            return Disposables.create()
        }
    }
}

struct NetworkEnvironment: Network {
    func getRepo(url: String, result:@escaping ([Repo]) -> Void) {
        print(url)
        if let urlRequest = URL(string: url) {
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let json = String(decoding: data, as: UTF8.self)
                    print(json)
                    let decoder = JSONDecoder()
                    if let repos = try? decoder.decode(RepoResponse.self, from: data) {
                        print(repos)
                        DispatchQueue.main.async {
                            result(repos.items ?? [])
                        }
                    } else {
                        result([])
                    }
                }
            }
            task.resume()
        }
    }
}
