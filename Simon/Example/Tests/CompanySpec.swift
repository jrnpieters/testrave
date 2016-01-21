//
//  CompanySpec.swift
//  BookingBug
//
//  Created by Simon Rice on 24/12/2015.
//  Copyright © 2015 BookingBug. All rights reserved.
//

import Mockingjay
import Nimble
import Quick
import Result
import RxSwift
import Unbox

@testable import BookingBug

class CompanySpec: QuickSpec {
    let response: [String: AnyObject] = [
        "id": 21,
        "name": "Tom's Tennis",
        "description": "",
        "numeric_widget_id": 12345,
        "currency_code": "GBP",
        "timezone": "Europe/London",
        "multi_status": ["here", "not_here"],
        "_embedded": [
            "settings": [
                "payment_tax": 0.1
            ]
        ],
        "_links": [
            "self": [
                "href": "https://www.bookingbug.com/api/v1/company/21"
            ],
            "services": [
                "href": "https://www.bookingbug.com/api/v1/21/services"
            ],
            "categories": [
                "href": "https://www.bookingbug.com/api/v1/21/categories"
            ],
            "address": [
                "href": "https://www.bookingbug.com/api/v1/21/addresses/34"
            ],
            "named_categories": [
                "href": "https://www.bookingbug.com/api/v1/21/named_categories"
            ],
            "resources": [
                "href": "https://www.bookingbug.com/api/v1/21/resources"
            ],
            "people": [
                "href": "https://www.bookingbug.com/api/v1/21/people"
            ],
            "client_details": [
                "href": "https://www.bookingbug.com/api/v1/21/client_details"
            ],
            "checkout": [
                "href": "https://www.bookingbug.com/api/v1/21/basket/checkout{?member_id,take_from_wallet}"
            ],
            "total": [
                "href": "https://www.bookingbug.com/api/v1/21/purchase_totals/{total_id}",
                "templated": true
            ],
            "login": [
                "href": "https://www.bookingbug.com/api/v1/login/21"
            ],
            "client": [
                "href": "https://www.bookingbug.com/api/v1/21/client"
            ],
            "booking_text": [
                "href": "https://www.bookingbug.com/api/v1/21/booking_text"
            ],
            "basket": [
                "href": "https://www.bookingbug.com/api/v1/21/basket"
            ]
        ]
    ]
    
    override func spec() {
        stub(http(.GET, uri: "https://www.bookingbug.com/api/v1/company/21"), builder: json(self.response))
        stub(http(.GET, uri: "https://www.bookingbug.com/api/v1/company/ukw12345"), builder: json(self.response))
        stub(http(.GET, uri: "https://www.bookingbug.com/api/v1/company/udskadswfdsewkjge"), builder: json(["Not Found": 404], status: 404, headers: nil))
        BookingBug.setup("abc", appKey: "def")
        
        context("with the standard SDK") {
            describe("a company fetched by ID via the API") {
                var company: Company!
                
                BookingBug.sharedBug.getCompany(21) { (result: Result<Company, BookingBugError>) -> Void in
                    switch result {
                    case let .Success(fetchedCompany): company = fetchedCompany
                    case let .Failure(error): fail("Company fetch failed: \(error)")
                    }
                }
                
                it("should not be nil") {
                    expect(company).toEventuallyNot(beNil())
                }
                
                it("should be set up correctly") {
                    expect(company.companyID).toEventually(equal(21))
                    expect(company.numericWidgetID).toEventually(equal(12345))
                    expect(company.name).toEventually(equal("Tom's Tennis"))
                    expect(company.timezone.secondsFromGMT).toEventually(equal(0))
                    expect(company.currencyCode).toEventually(equal("GBP"))
                    expect(company.paymentTax).toEventually(equal(0.1))
                    
                    expect(company.multiStatus).toEventually(contain("here"))
                    expect(company.multiStatus).toEventually(contain("not_here"))
                    
                    expect(company.selfLink.href).toEventually(equal("https://www.bookingbug.com/api/v1/company/21"))
                    expect(company.peopleLink.href).toEventually(equal("https://www.bookingbug.com/api/v1/21/people"))
                }
            }
            
            describe("a company fetched by widget ID via the API") {
                var company: Company!
                
                BookingBug.sharedBug.getCompany("ukw12345") { (result: Result<Company, BookingBugError>) -> Void in
                    switch result {
                    case let .Success(fetchedCompany): company = fetchedCompany
                    case let .Failure(error): fail("Company fetch failed: \(error)")
                    }
                }
                
                it("should not be nil") {
                    expect(company).toEventuallyNot(beNil())
                }
                
                it("should be set up correctly") {
                    expect(company.companyID).toEventually(equal(21))
                    expect(company.numericWidgetID).toEventually(equal(12345))
                    expect(company.name).toEventually(equal("Tom's Tennis"))
                    expect(company.timezone.secondsFromGMT).toEventually(equal(0))
                    expect(company.currencyCode).toEventually(equal("GBP"))
                    expect(company.paymentTax).toEventually(equal(0.1))
                    
                    expect(company.multiStatus).toEventually(contain("here"))
                    expect(company.multiStatus).toEventually(contain("not_here"))
                    
                    expect(company.selfLink.href).toEventually(equal("https://www.bookingbug.com/api/v1/company/21"))
                    expect(company.peopleLink.href).toEventually(equal("https://www.bookingbug.com/api/v1/21/people"))
                }
            }
            
            describe("a company that doesn't exist on the API") {
                var error: BookingBugError! = nil
                
                BookingBug.sharedBug.getCompany("udskadswfdsewkjge") { (result: Result<Company, BookingBugError>) -> Void in
                    switch result {
                    case .Success(_): fail("Company fetch succeeded!")
                    case let .Failure(fetchedError): error = fetchedError
                    }
                }
                
                it("should have a non-nil error") {
                    expect(error).toEventuallyNot(beNil())
                }
                
                it("should have a not found error") {
                    waitUntil { done in
                        NSThread.sleepForTimeInterval(0.5)
                        done()
                    }
                    
                    switch(error!) {
                    case .NetworkError(_): fail("Network Error")
                    case .ParameterError(_): fail("Parameter Error")
                    case .UnknownError(_): fail("Unknown Error")
                    case let .ResponseError(statusCode, _):
                        expect(statusCode).toNot(beNil())
                        expect(statusCode).to(equal(404))
                    }
                }
            }
        }
        
        context("with the RxSwift SDK") {
            
            describe("a company fetched by ID via the API") {
                var company: Company!
                
                let _ = BookingBug.sharedBug.getCompany(21)
                    .observeOn(MainScheduler.instance)
                    .subscribe { event in
                    switch event {

                        case .Next(let fetchedCompany): company = fetchedCompany
                        case .Error(let error): fail("Company fetch failed: \(error)")
                        default: break

                        }
                    }
                
                it("should not be nil") {
                    expect(company).toNot(beNil())
                }
                
                it("should be set up correctly") {
                    // Expectations shortened for brevity
                    
                    expect(company.companyID).to(equal(21))
                    expect(company.name).to(equal("Tom's Tennis"))
                }
            }
            
            describe("a company fetched by widget ID via the API") {
                var company: Company!
                
                let _ = BookingBug.sharedBug.getCompany("ukw12345")
                    .observeOn(MainScheduler.instance)
                    .subscribe { event in
                        switch event {

                        case .Next(let fetchedCompany): company = fetchedCompany
                        case .Error(let error): fail("Company fetch failed: \(error)")
                        default: break

                        }
                    }
                
                it("should not be nil") {
                    expect(company).toNot(beNil())
                }
                
                it("should be set up correctly") {
                    // Expectations shortened for brevity
                    
                    expect(company.companyID).to(equal(21))
                    expect(company.name).to(equal("Tom's Tennis"))
                }
            }
            
            describe("a company that doesn't exist on the API") {
                var error: BookingBugError! = nil
                
                let _ = BookingBug.sharedBug.getCompany("udskadswfdsewkjge")
                    .observeOn(MainScheduler.instance)
                    .subscribe { event in
                        switch event {

                        case .Next(_): fail("Company fetch succeeded!")
                        case .Error(let fetchedError):
                            if let fetchedBBError = fetchedError as? BookingBugError {
                                error = fetchedBBError
                            } else {
                                fail("Unknown Error")
                            }
                        default: break

                        }
                    }
                
                it("should have a non-nil error") {
                    expect(error).toNot(beNil())
                }
                
                it("should have a not found error") {
                    switch(error!) {

                    case .NetworkError(_): fail("Network Error")
                    case .ParameterError(_): fail("Parameter Error")
                    case .UnknownError(_): fail("Unknown Error")
                    case let .ResponseError(statusCode, _):
                        expect(statusCode).toNot(beNil())
                        expect(statusCode).to(equal(404))
                    }

                }
            }
        }
    }
}
