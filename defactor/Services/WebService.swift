//
//  WebService.swift
//  defactor
//
//  Created by Rockford Wei on 2022-03-04.
//

import Combine
import Foundation
 
fileprivate func sqrt(_ x:UInt) -> UInt { return UInt(sqrt(Double(x))) }
 
fileprivate func factorize(n: UInt) -> [UInt] {
    return (1...sqrt(n) + 1).filter { n % $0 == 0 }
}

/*
 fileprivate func primeFactorize(n: UInt) -> [UInt] {
     var num = n
     var factors: Set<UInt> = []
     for i in 2...UInt(sqrt(Double(num)) + 1) {
         while(num % i == 0) {
             num /= i
             factors.insert(i)
         }
     }
     if num != 1 {
         factors.insert(num)
     }
     return factors.sorted()
 }

 */


class LocalURLProtocol: URLProtocol {
    enum Exception: Error {
        case invalidParameters
        case internalError
    }
    static func parseRequest(_ request: URLRequest) -> UInt? {
        guard let url = request.url?.absoluteString,
              let param = url.split(separator: Character("/")).last,
              let uint = UInt(param) else {
            return nil
        }
        return uint
    }
    override class func canInit(with request: URLRequest) -> Bool {
        guard let _ = LocalURLProtocol.parseRequest(request) else { return false }
        return true
    }
    override func stopLoading() {
        print("loading stopped")
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        DispatchQueue.global(qos: .default).async {
            guard let url = self.request.url,
                  let target = LocalURLProtocol.parseRequest(self.request) else {
                self.client?.urlProtocol(self, didFailWithError: Exception.invalidParameters)
                return
            }
            let payload = ListModel()
            payload.key = target
            payload.items = factorize(n: target).map { DetailModel.build(x: $0 )}
            
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: ["MIME": "application/json"]),
                  let data = try? JSONEncoder().encode(payload) else {
                      self.client?.urlProtocol(self, didFailWithError: Exception.internalError)
                      return
            }
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowedInMemoryOnly)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
}

struct Constants {
    static func makeURL(value: UInt) -> String {
        return "https://math.nut/\(value)"
    }
}
class WebService {
    private let session: URLSession
    private var sessionResult: AnyCancellable?
    init() {
        let conf = URLSessionConfiguration.ephemeral
        conf.protocolClasses = [LocalURLProtocol.self]
        session = URLSession(configuration: conf)
    }
    func query(value: UInt, completion: @escaping (ListModel) -> ()) {
        guard let url = URL(string: Constants.makeURL(value: value)) else {
            return
        }
        self.sessionResult = session.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap { $0.data }
            .decode(type: ListModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in
                print("query completed")
            }, receiveValue: { response in
                completion(response)
            })
    }
    static let shared = WebService()
}
