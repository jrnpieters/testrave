//
//  Link.swift
//  Pods
//
//  Created by Simon Rice on 04/12/2015.
//
//

import Foundation
import Result
import RxSwift

public extension Link {
    private func rxTraverse(bug: BookingBug = BookingBug.sharedBug,
        parameters: [String: AnyObject] = [:], method: HTTPMethod) -> Observable<T> {

        return Observable.create { observer in
            bug.performRequest(self.href, parameters: parameters,
                method: method, result: { (result: Result<T, BookingBugError>) -> Void in

                switch result {
                case .Success(let item):
                    observer.on(.Next(item))
                    observer.on(.Completed)
                case .Failure(let error):
                    observer.on(.Error(error))
                }
            })

            return AnonymousDisposable {}
        }

    }

    func get(parameters: [String: AnyObject] = [:],
        bug: BookingBug = BookingBug.sharedBug) -> Observable<T> {

            return self.rxTraverse(bug, parameters: parameters, method: .GET)
    }

    func post(parameters: [String: AnyObject] = [:],
        bug: BookingBug = BookingBug.sharedBug) -> Observable<T> {

            return self.rxTraverse(bug, parameters: parameters, method: .POST)
    }

    func put(parameters: [String: AnyObject] = [:],
        bug: BookingBug = BookingBug.sharedBug) -> Observable<T> {

            return self.rxTraverse(bug, parameters: parameters, method: .PUT)
    }

    func delete(parameters: [String: AnyObject] = [:],
        bug: BookingBug = BookingBug.sharedBug) -> Observable<T> {

            return self.rxTraverse(bug, parameters: parameters, method: .DELETE)
    }
}
