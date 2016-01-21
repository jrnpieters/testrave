//
//  BookingBug.swift
//  Pods
//
//  Created by Simon Rice on 04/12/2015.
//
//

import Foundation
import RxSwift

// Initial fetching
public extension BookingBug {
    public func getCompany(companyID: Int) -> Observable<Company> {
        return Observable.create { observer in
            self.getCompany(companyID) { result in
                switch result {
                case .Success(let company):
                    observer.on(.Next(company))
                    observer.on(.Completed)
                case .Failure(let error):
                    observer.on(.Error(error))
                }
            }

            return AnonymousDisposable {}
        }
    }

    public func getCompany(widgetID: String) -> Observable<Company> {
        return Observable.create { observer in
            self.getCompany(widgetID) { result in
                switch result {
                case .Success(let company):
                    observer.on(.Next(company))
                    observer.on(.Completed)
                case .Failure(let error):
                    observer.on(.Error(error))
                }
            }

            return AnonymousDisposable {}
        }
    }
}
