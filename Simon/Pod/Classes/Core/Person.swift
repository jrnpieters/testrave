//
//  Person.swift
//  Pods
//
//  Created by Simon Rice on 04/12/2015.
//
//

import Foundation
import Unbox

public struct Person {
    public let personID: Int

    public let name: String
    public let email: String?
    public let phonePrefix: String?
    public let phone: String?
}

extension Person: Unboxable {
    public init(unboxer: Unboxer) {
        self.personID = unboxer.unbox("id")
        self.name = unboxer.unbox("name")
        self.email = unboxer.unbox("email")
        self.phone = unboxer.unbox("phone")
        self.phonePrefix = unboxer.unbox("phone_prefix")
    }
}

extension Person: Pageable {
    public static let pagingKey: String = "people"
}
