//
//  PagedList.swift
//  Pods
//
//  Created by Simon Rice on 04/12/2015.
//
//

import Foundation
import Unbox

public protocol Pageable: Unboxable {
    static var pagingKey: String { get }
}

public struct PagedList<T where T: Pageable> {
    public let totalEntries: Int
    private let items: [T]
}

extension PagedList: Unboxable {
    public init(unboxer: Unboxer) {
        self.totalEntries = unboxer.unbox("total_entries")
        self.items = unboxer.unbox("_embedded.\(T.pagingKey)")
    }
}

extension PagedList: CollectionType {
    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return self.items.count
    }

    public subscript(index: Int) -> T {
        return self.items[index]
    }
}

extension PagedList: ArrayLiteralConvertible {
    public init(arrayLiteral elements: T...) {
        self.items = elements
        self.totalEntries = elements.count
    }
}
