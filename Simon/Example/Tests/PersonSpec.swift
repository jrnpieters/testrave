//
//  PersonSpec.swift
//  BookingBug
//
//  Created by Simon Rice on 29/12/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Mockingjay
import Nimble
import Quick
import Result
import RxSwift

@testable import BookingBug

class PersonSpec: QuickSpec {
    let response: [String: AnyObject] = [
        "total_entries": 2,
        "_embedded": [
            "people": [
                [
                    "id": 74,
                    "name": "John Smith",
                    "type": "person",
                    "_links": [
                        "self": [
                            "href": "https://www.bookingbug.com/api/v1/21/people/74"
                        ],
                        "items": [
                            "href": "https://www.bookingbug.com/api/v1/21/items?person_id=74"
                        ]
                    ]
                ],
                [
                    "id": 75,
                    "name": "Simon Rice",
                    "email": "srice@bookingbug.com",
                    "phone": "071234567890",
                    "phone_prefix": "+44",
                    "type": "person",
                    "_links": [
                        "self": [
                            "href": "https://www.bookingbug.com/api/v1/21/people/75"
                        ],
                        "items": [
                            "href": "https://www.bookingbug.com/api/v1/21/items?person_id=75"
                        ]
                    ]
                ]
            ]
        ],
        "_links": [
            "self": [
                "href": "https://www.bookingbug.com/api/v1/21/people"
            ]
        ]
    ]
    
    var people: [Person] = []
    
    override func spec() {
        let personHref = "https://www.bookingbug.com/api/v1/21/people"
        let personLink = Link<PagedList<Person>>(href: personHref)
        stub(http(.GET, uri: personHref), builder: json(self.response))
        
        describe("a person list fetched via the API") {
            BookingBug.setup("abc", appKey: "def")
            var people: PagedList<Person> = []

            let _ = personLink.get()
                .observeOn(MainScheduler.instance)
                .subscribe { event in
                    switch event {

                    case .Next(let fetchedPeople): people = fetchedPeople
                    case .Error(let error): fail("Person list fetch failed: \(error)")
                    default: break
                    }
                }
            
            it("should have 2 items") {
                expect(people.totalEntries).to(equal(2))
                expect(people.count).to(equal(2))
            }
            
            context("with the first person") {
                it("should not be nil") {
                    expect(people.first).toNot(beNil())
                }
                
                it("should be set up correctly") {
                    let person: Person = people.first!
                    expect(person.personID).to(equal(74))
                    expect(person.name).to(equal("John Smith"))
                    expect(person.email).to(beNil())
                    expect(person.phone).to(beNil())
                    expect(person.phonePrefix).to(beNil())
                }
            }
            
            context("with the first person") {                
                it("should not be nil") {
                    expect(people[1]).toNot(beNil())
                }
                
                it("should be set up correctly") {
                    let person: Person = people[1]
                    expect(person.personID).to(equal(75))
                    expect(person.name).to(equal("Simon Rice"))
                    expect(person.email).to(equal("srice@bookingbug.com"))
                    expect(person.phone).to(equal("071234567890"))
                    expect(person.phonePrefix).to(equal("+44"))
                }
            }
        }
    }
}
