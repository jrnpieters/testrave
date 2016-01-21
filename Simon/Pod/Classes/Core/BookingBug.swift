//
//  BookingBug.swift
//  Pods
//
//  Created by Simon Rice on 04/12/2015.
//
//

import Foundation
import Result
import Unbox
import URITemplate

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public enum BookingBugError: ErrorType {
    case ParameterError(error: ErrorType)
    case NetworkError(error: NSError)
    case ResponseError(HTTPStatusCode: Int?, unboxError: UnboxError)
    case UnknownError(error: ErrorType?)
}

public struct BookingBug {
    let appID: String
    let appKey: String
    let subdomain: String
    var authToken: String?

    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
}

// Shared Bug setup - needed for making requests via any object's extension
public extension BookingBug {
    static var sharedBug: BookingBug!

    static func setup(appID: String, appKey: String,
        subdomain: String = "www", authToken: String? = nil) {

        self.sharedBug = BookingBug(appID: appID, appKey: appKey,
            subdomain: subdomain, authToken: authToken)
    }
}

// Internal code that deals with the common bits of making requests
extension BookingBug {

    private func getTask<T where T: Unboxable>(request: NSURLRequest,
        result: (Result<T, BookingBugError>) -> Void) -> NSURLSessionDataTask {

            self.sessionConfiguration.HTTPAdditionalHeaders = [
                "App-Id": self.appID,
                "App-Key": self.appKey,
                "Auth-Token": self.authToken ?? ""
            ]

            let session = NSURLSession(configuration: self.sessionConfiguration)
            return session.dataTaskWithRequest(request) { (data, response, error) -> Void in

                if let error = error {
                    result(.Failure(BookingBugError.NetworkError(error: error)))
                } else if let data = data {
                    var statusCode: Int?
                    if let httpResponse = response as? NSHTTPURLResponse {
                        statusCode = httpResponse.statusCode
                    }

                    do {
                        let item: T = try UnboxOrThrow(data)
                        result(.Success(item))
                    } catch let unboxError as UnboxError {
                        result(.Failure(BookingBugError.ResponseError(HTTPStatusCode: statusCode,
                            unboxError: unboxError)))
                    } catch let differentError {
                        result(.Failure(BookingBugError.UnknownError(error: differentError)))
                    }
                } else {
                    result(.Failure(BookingBugError.UnknownError(error: nil)))
                }
            }
    }

    func performRequest<T where T: Unboxable>(pathTemplate: String,
        parameters: [String: AnyObject] = [:],  method: HTTPMethod = .GET,
        result: (Result<T, BookingBugError>) -> Void) {

            do {
                let rootSegment: String
                if pathTemplate.hasPrefix("http://localhost")
                    || pathTemplate.hasPrefix("https://") {
                    rootSegment = ""
                } else if self.subdomain.hasPrefix("http://localhost")
                    || self.subdomain.hasPrefix("https://") {
                    rootSegment = self.subdomain
                } else {
                    rootSegment = "https://\(self.subdomain).bookingbug.com/"
                }

                let path: String = URITemplate(template: pathTemplate).expand(parameters)
                let url = NSURL(string: "\(rootSegment)\(path)")
                let request = NSMutableURLRequest(URL: url!)
                request.HTTPMethod = method.rawValue
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters,
                    options: [])

                let task: NSURLSessionDataTask = self.getTask(request,
                    result: result)

                task.resume()
            } catch let error {
                // Parameter error
                result(.Failure(BookingBugError.ParameterError(error: error)))
            }
    }
}

// Initial fetching
public extension BookingBug {
    public func getCompany(widgetID: String, result: (Result<Company, BookingBugError>) -> Void) {
        let path = "api/v1/company/{company_id}"
        let parameters = ["company_id": widgetID]
        self.performRequest(path, parameters: parameters, result: result)
    }

    public func getCompany(companyID: Int, result: (Result<Company, BookingBugError>) -> Void) {
        let path = "api/v1/company/{company_id}"
        let parameters = ["company_id": companyID]
        self.performRequest(path, parameters: parameters, result: result)
    }
}
