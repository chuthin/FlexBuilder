//
//  Network.swift
//  BuilderUI
//
//  Created by Chu Thin on 19/07/2023.
//

import Foundation
import RxSwift
protocol Network {
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
        if let urlRequest = URL(string: url) {
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    if let repos = try? decoder.decode(RepoResponse.self, from: data) {
                        if let items = repos.items {
                            DispatchQueue.main.async {
                                result(items)
                            }

                        }
                    }
                }
            }
            task.resume()
        }
    }
}
