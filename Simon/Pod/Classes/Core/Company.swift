//
//  Company.swift
//  Pods
//
//  Created by Simon Rice on 04/12/2015.
//
//

import Foundation
import Result
import Unbox

public struct Company {
    public let companyID: Int
    public let numericWidgetID: Int

    public let name: String
    public let currencyCode: String

    public let timezone: NSTimeZone
    public let multiStatus: [String]
    private let settings: [String: AnyObject]

    public let peopleLink: Link<PagedList<Person>>
    public let selfLink: Link<Company>
}

public extension Company {
    var paymentTax: Float {
        return (self.settings["payment_tax"] as? Float) ?? 0.0
    }
}

// Link handling
public extension Company {
    func getPeople(bug: BookingBug = BookingBug.sharedBug,
        result: (Result<PagedList<Person>, BookingBugError>) -> Void) {

            self.peopleLink.get(bug: bug, result: result)
    }
}

extension NSTimeZone: UnboxableByTransform {
    public typealias UnboxRawValueType = String

    public static func transformUnboxedValue(unboxedValue: String) -> Self? {
        return self.init(name: unboxedValue)
    }

    public static func unboxFallbackValue() -> Self {
        return self.init(forSecondsFromGMT: 0)
    }
}

extension Company: Unboxable {
    public init(unboxer: Unboxer) {
        self.companyID = unboxer.unbox("id")
        self.numericWidgetID = unboxer.unbox("numeric_widget_id")
        self.name = unboxer.unbox("name")
        self.currencyCode = unboxer.unbox("currency_code")
        self.timezone = unboxer.unbox("timezone")
        self.multiStatus = unboxer.unbox("multi_status") ?? []
        self.settings = unboxer.unbox("_embedded.settings")

        self.peopleLink = unboxer.unbox("_links.people")
        self.selfLink = unboxer.unbox("_links.self")
    }
}
