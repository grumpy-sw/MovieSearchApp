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
    var detail: Endpoint?
    var foster: Endpoint?
    
    let decoder = JSONDecoder()
    
    override func spec() {
        describe("API Provider를 사용하여 영화 API를 호출한다.") {
            beforeEach {
                self.provider = APIProvider()
                self.trending = EndpointStorage.trendingAPI(.movie, .day).endpoint
                self.upcoming = EndpointStorage.upcomingAPI(.movie).endpoint
                self.popular = EndpointStorage.popularAPI(.movie).endpoint
                self.search = EndpointStorage.searchAPI(.movie, "탑건: 매버릭", 1).endpoint
                self.detail = EndpointStorage.detailAPI(.movie, 361743).endpoint
                self.foster = EndpointStorage.fetchImageAPI("/jeqXUwNilvNqNXqAHsdwm5pEfae.jpg", 200).endpoint
            }
            context("Movie Trending API를 호출한다.") {
                it("결과를 성공적으로 Decode 해야 한다.") {
                    waitUntil(timeout: .seconds(2)) { [weak self] done in
                        self?.provider?.request(endpoint: (self?.trending)!) { result in
                            switch result {
                            case .success(let data):
                                let trending = try! self?.decoder.decode(MovieCollectionDTO.self, from: data)
                                
                                expect(trending?.movies?.count).to(equal(20))
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
                                let upcoming = try! self?.decoder.decode(MovieCollectionDTO.self, from: data)
                                
                                expect(upcoming?.movies?.count).to(equal(20))
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
                                let popular = try! self?.decoder.decode(MovieCollectionDTO.self, from: data)
                                
                                expect(popular?.movies?.count).to(equal(20))
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
                        self?.provider?.request(endpoint: (self?.search)!) { result in
                            switch result {
                            case .success(let data):
                                let movies = try! self?.decoder.decode(MoviesResponse.self, from: data)
                                
                                expect(movies?.page).to(equal(1))
                                expect(movies?.movies.count).to(equal(1))
                                expect(movies?.movies.first!.title).to(equal("Top Gun: Maverick"))
                                expect(movies?.movies.first!.id).to(equal(361743))
                                done()
                            case .failure(_):
                                break
                            }
                        }
                    }
                }
            }
            
            context("Movie Detail API를 호출한다.") {
                it("결과를 성공적으로 Decode 해야 한다.") {
                    waitUntil(timeout: .seconds(2)) { [weak self] done in
                        self?.provider?.request(endpoint: (self?.detail)!) { result in
                            switch result {
                            case .success(let data):
                                let movie = try! self?.decoder.decode(MovieDetail.self, from: data)
                                
                                expect(movie?.budget).to(equal(170000000))
                                expect(movie?.originalTitle).to(equal("Top Gun: Maverick"))
                                expect(movie?.runtime).to(equal(131))
                                expect(movie?.status).to(equal("Released"))
                                done()
                            case .failure(_):
                                break
                            }
                        }
                    }
                }
            }
            
            context("FosterPath로 이미지를 내려받는다.") {
                it("원하는 Size의 이미지를 성공적으로 받아야 한다.") {
                    waitUntil(timeout: .seconds(2)) { [weak self] done in
                        self?.provider?.request(endpoint: (self?.foster)!) { result in
                            switch result {
                            case .success(let data):
                                let expectedImage = UIImage(data: data)
                                
                                expect(expectedImage?.size.width).to(equal(200))
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
