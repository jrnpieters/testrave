//
//  Link.swift
//  Pods
//
//  Created by Simon Rice on 04/12/2015.
//
//

import Foundation
import Result
import Unbox

public struct Link<T where T: Unboxable> {
    public let href: String
    public let title: String?

    internal let name: String?
    internal let isTemplated: Bool
    internal let deprecation: String?
    internal let type: String?
    internal let hrefLanguage: String?

    // Internal constructor added to ease testing
    init(href: String, title: String? = nil, isTemplated: Bool = false) {
        self.href = href
        self.title = title
        self.isTemplated = isTemplated

        self.name = nil
        self.deprecation = nil
        self.type = nil
        self.hrefLanguage = nil
    }
}

public extension Link {
    typealias LinkResult = Result<T, BookingBugError>

    func get(parameters: [String: AnyObject] = [:], bug: BookingBug = BookingBug.sharedBug,
        result: (LinkResult) -> Void) {

        bug.performRequest(self.href, parameters: parameters, method: .GET, result: result)

    }

    func post(parameters: [String: AnyObject] = [:], bug: BookingBug = BookingBug.sharedBug,
        result: (LinkResult) -> Void) {

        bug.performRequest(self.href, parameters: parameters, method: .POST, result: result)

    }

    func put(parameters: [String: AnyObject] = [:], bug: BookingBug = BookingBug.sharedBug,
        result: (LinkResult) -> Void) {

        bug.performRequest(self.href, parameters: parameters, method: .PUT, result: result)

    }

    func delete(parameters: [String: AnyObject] = [:], bug: BookingBug = BookingBug.sharedBug,
        result: (LinkResult) -> Void) {

        bug.performRequest(self.href, parameters: parameters, method: .DELETE, result: result)

    }
}

extension Link: Unboxable {
    public init(unboxer: Unboxer) {
        self.href = unboxer.unbox("href")
        self.title = unboxer.unbox("title")

        self.name = unboxer.unbox("name")
        self.type = unboxer.unbox("type")
        self.deprecation = unboxer.unbox("deprecation")
        self.isTemplated = unboxer.unbox("templated") ?? false
        self.hrefLanguage = unboxer.unbox("hreflang")
    }
}
