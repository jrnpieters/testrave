//
//  Company.swift
//  Pods
//
//  Created by Simon Rice on 04/12/2015.
//
//

import Foundation
import RxSwift

public extension Company {
    func getPeople(bug: BookingBug = BookingBug.sharedBug) -> Observable<PagedList<Person>> {
        return self.peopleLink.get(bug: bug)
    }
}
