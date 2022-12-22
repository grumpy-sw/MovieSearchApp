//
//  DecodeModelTests.swift
//  MovieSearchAppTests
//
//  Created by 박세웅 on 2022/12/21.
//

import XCTest
import Quick
import Nimble
@testable import MovieSearchApp

class DecodeModelTests: QuickSpec {
    let decoder = JSONDecoder()
    var creditsJsonData: Data? = nil

    override func spec() {
        describe("Decode Test를 진행한다.") {
            beforeEach {
                self.creditsJsonData = NSDataAsset(name: "credits")?.data
            }
            context("Asset의 credits파일로 테스트를 시작한다.") {
                it("프로퍼티인 cast가 [Cast] 타입으로 Decode 되어야 한다.") {
                    var decodedCast: [CastDTO]? = nil
                    do {
                        decodedCast = try self.decoder.decode(CreditsDTO.self, from: self.creditsJsonData!).cast
                    } catch(let error) {
                        print(error.localizedDescription)
                    }
                    expect(decodedCast!.count).to(beGreaterThan(0))
                }
                it("프로퍼티인 crew가 [Crew] 타입으로 Decode 되어야 한다.") {
                    var decodedCrew: [CrewDTO]? = nil
                    do {
                        decodedCrew = try self.decoder.decode(CreditsDTO.self, from: self.creditsJsonData!).crew
                    } catch(let error) {
                        print(error.localizedDescription)
                    }
                    expect(decodedCrew!.count).to(beGreaterThan(0))
                }
                
            }
        }
    }
}
