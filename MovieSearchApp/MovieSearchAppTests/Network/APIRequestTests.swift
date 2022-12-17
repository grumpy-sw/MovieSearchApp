//
//  APIRequestTests.swift
//  MovieSearchAppTests
//
//  Created by 박세웅 on 2022/12/16.
//

import XCTest
import Quick
import Nimble
@testable import MovieSearchApp

class APIRequestTests: QuickSpec {
    
    var provider: APIProvider?
    var trending: Endpoint?
    var upcoming: Endpoint?
    var popular: Endpoint?
    var search: Endpoint?
    let decoder = JSONDecoder()
    
    override func spec() {
        describe("API Provider를 사용하여 일일 영화 트렌드 API를 호출한다.") {
            beforeEach {
                self.provider = APIProvider()
                self.trending = EndpointStorage.trendingAPI(.movie, .day).endpoint
                self.upcoming = EndpointStorage.upcomingAPI(.movie).endpoint
                self.popular = EndpointStorage.popularAPI(.movie).endpoint
                self.search = EndpointStorage.searchAPI(.movie, "아이언", 1).endpoint
            }
            context("Movie Trending API를 호출한다.") {
                it("결과를 성공적으로 Decode 해야 한다.") {
                    waitUntil(timeout: .seconds(2)) { [weak self] done in
                        self?.provider?.request(endpoint: (self?.trending)!) { result in
                            switch result {
                            case .success(let data):
                                let trending = try! self?.decoder.decode(MoviesResponse.self, from: data)
                                
                                expect(trending?.page).to(equal(1))
                                expect(trending?.totalPages).to(equal(1000))
                                expect(trending?.totalResults).to(equal(20000))
                                done()
                            case .failure(_):
                                break
                            }
                        }
                    }
                }
            }
            
            context("Movie Upcoming API를 호출한다.") {
                it("결과를 성공적으로 Decode 해야 한다.") {
                    waitUntil(timeout: .seconds(2)) { [weak self] done in
                        self?.provider?.request(endpoint: (self?.upcoming)!) { result in
                            switch result {
                            case .success(let data):
                                let upcoming = try! self?.decoder.decode(MoviesResponse.self, from: data)
                                
                                expect(upcoming?.page).to(equal(1))
                                expect(upcoming?.totalPages).to(equal(1))
                                expect(upcoming?.totalResults).to(equal(12))
                                done()
                            case .failure(_):
                                break
                            }
                        }
                    }
                }
            }
            
            context("Movie Popular API를 호출한다.") {
                it("결과를 성공적으로 Decode 해야 한다.") {
                    waitUntil(timeout: .seconds(2)) { [weak self] done in
                        self?.provider?.request(endpoint: (self?.popular)!) { result in
                            switch result {
                            case .success(let data):
                                let popular = try! self?.decoder.decode(MoviesResponse.self, from: data)
                                
                                expect(popular?.page).to(equal(1))
                                expect(popular?.totalPages).to(equal(822))
                                expect(popular?.totalResults).to(equal(16433))
                                done()
                            case .failure(_):
                                break
                            }
                        }
                    }
                }
            }
            
            context("Movie Search API를 호출한다.") {
                it("결과를 성공적으로 Decode 해야 한다.") {
                    waitUntil(timeout: .seconds(2)) { [weak self] done in
                        self?.provider?.request(endpoint: (self?.popular)!) { result in
                            switch result {
                            case .success(let data):
                                let movies = try! self?.decoder.decode(MoviesResponse.self, from: data)
                                
                                expect(movies?.page).to(equal(1))
                                expect(movies?.movies.count).to(equal(20))
                                done()
                            case .failure(_):
                                break
                            }
                        }
                    }
                }
            }
            
        }
    }
}
