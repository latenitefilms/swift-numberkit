//
//  RationalTests.swift
//  NumberKit
//
//  Created by Matthias Zenger on 16/08/2015.
//  Copyright © 2015-2020 Matthias Zenger. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest

@testable import NumberKit

class RationalTests: XCTestCase {

  func testConstructors() {
    let r0: Rational<Int> = 8
    XCTAssert(r0.numerator == 8 && r0.denominator == 1)
    XCTAssert(r0 == 8)
    let r1: Rational<Int> = 7/2
    XCTAssert(r1.numerator == 7 && r1.denominator == 2)
    XCTAssert(r1.floatValue == 7.0/2.0)
    let r2 = Rational(43, 7)
    XCTAssert(r2.numerator == 43 && r2.denominator == 7)
    let r3 = Rational(19 * 3 * 5 * 7, 2 * 5 * 7)
    XCTAssertEqual(r3.numerator, 1995)
    XCTAssertEqual(r3.denominator, 70)
    let r4: Rational<Int>? = Rational(from: "172346/254")
    if let r4u = r4 {
      XCTAssertEqual(r4u.numerator, 172346)
      XCTAssertEqual(r4u.denominator, 254)
    } else {
      XCTFail("cannot parse r4 string")
    }
    let r5: Rational<Int>? = Rational(from: "-128/64")
    if let r5u = r5 {
      XCTAssertEqual(r5u.numerator, -128)
      XCTAssertEqual(r5u.denominator, 64)
    } else {
      XCTFail("cannot parse r5 string")
    }
  }
  
  func testNormalized() {
    let r0 = Rational(-128, 64).normalized
    XCTAssertEqual(r0.numerator, -2)
    XCTAssertEqual(r0.denominator, 1)
  }
  
  func testPlus() {
    let r1 = Rational(16348, 343).plus(24/7)
    XCTAssertEqual(r1, 17524/343)
    XCTAssert(r1 == Rational(from: "17524/343"))
    XCTAssert(r1 == 17524/343)
    let r2: Rational<Int> = (74433/215).plus(312/15)
    XCTAssertEqual(r2.numerator, 236715)
    XCTAssertEqual(r2.denominator, 645)
    XCTAssert(r2 == 367)
    let r3: Rational<Int> = (458200/50).plus(3440/17)
    XCTAssert(r3 == 159228/17)
    let x = Rational(BigInt(458200)/BigInt(50))
    let r4: Rational<BigInt> = x.plus(Rational(BigInt(3440)/BigInt(17)))
    XCTAssert(r4 == Rational(BigInt(159228)/BigInt(17)))
  }

  func testMinus() {
    let r1 = Rational(123, 5).minus(247/10)
    XCTAssertEqual(r1, Rational(1, 10).negate)
    let r2 = Rational(0).minus(72372/30)
    XCTAssertEqual(r2, -Rational(72372, 30))
    let r3 = Rational(98232, 536).minus(123/12)
    XCTAssertEqual(r3, Rational(46369, 268))
  }

  func testTimes() {
    let r1 = Rational(4, 8).times(2)
    XCTAssertEqual(r1, 1)
    let r2 = Rational(83987, 12).times(48/42)
    XCTAssertEqual(r2, Rational(83987 * 48, 12 * 42))
    let r3 = Rational(170, 9).times(-17/72)
    XCTAssertEqual(r3, Rational(-170 * 17, 9 * 72))
  }

  func testDividedBy() {
    let r1 = Rational(10, -3).divided(by: Rational(-31, 49))
    XCTAssertEqual(r1, Rational(10 * 49, 3 * 31))
    let r2 = Rational(1262999999875, 1263000000000).divided(by: Rational(-1262999999875, 1263000000000))
    XCTAssertEqual(r2, Rational(-1, 1))
  }

  func testRemainder() {
    let r1 = Rational(10, 3).remainder(dividingBy: 9/3)
    XCTAssertEqual(r1, Rational(1, 3))

    // A whole number division, should equal using remainder for an integer
    let r3 = Rational(10, 1).remainder(dividingBy: 3/1)
    XCTAssertEqual(r3, Rational(1, 1))

    // Using remainderWithOverflow
    let (r4, overflow) = Rational(10, 3).remainderReportingOverflow(dividingBy: 9/3)
    XCTAssertEqual(r4, Rational(1, 3))
    XCTAssertFalse(overflow)

    let (r5, overflow2) = Rational(-10, 3).remainderReportingOverflow(dividingBy: 9/3)
    XCTAssertEqual(r5, Rational(-1, 3))
    XCTAssertFalse(overflow2)

    // Division by zero, leading to overflow
    let (r6, overflow3) = Rational(10, -3).remainderReportingOverflow(dividingBy: 0)
    XCTAssertEqual(r6, Rational(-10, 3))
    XCTAssertTrue(overflow3)

    // Using the % operator
    let r7: Rational<Int> = Rational(10, 3) % Rational(9, 3)
    XCTAssertEqual(r7, Rational(1, 3))
  }

  func testQuotientAndRemainder() {
    let (q1, r1) = Rational(10, 3).quotientAndRemainder(dividingBy: 9/3)
    XCTAssertEqual(q1, 1)
    XCTAssertEqual(r1, Rational(1, 3))

    // A whole number division, should equal using remainder for an integer
    let (q3, r3) = Rational(10, 1).quotientAndRemainder(dividingBy: 3/1)
    XCTAssertEqual(q3, 3)
    XCTAssertEqual(r3, Rational(1, 1))

    // Using quotientAndRemainderReportingOverflow
    let (q4, r4, overflow) = Rational(10, 3).quotientAndRemainderReportingOverflow(dividingBy: 9/3)
    XCTAssertEqual(q4, 1)
    XCTAssertEqual(r4, Rational(1, 3))
    XCTAssertFalse(overflow)

    let (q5, r5, overflow2) = Rational(-10, 3).quotientAndRemainderReportingOverflow(dividingBy: 9/3)
    XCTAssertEqual(q5, -1)
    XCTAssertEqual(r5, Rational(-1, 3))
    XCTAssertFalse(overflow2)

    let (q6, r6, overflow3) = Rational(10, -3).quotientAndRemainderReportingOverflow(dividingBy: 0)
    XCTAssertEqual(q6, -10)
    XCTAssertEqual(r6, Rational(-10, 3))
    XCTAssertTrue(overflow3)    
  }
  
  func testEquals() {
    let r1 = Rational(1, 2)
    let r2 = Rational(2, 4)
    XCTAssertEqual(r1, r2)
  }

  func testIntValue() {
    let r1 = Rational(1, 2)
    XCTAssertNil(r1.intValue)
    let r2 = Rational(3, 2)
    XCTAssertNil(r2.intValue)
    let r3 = Rational(4, 2)
    XCTAssertEqual(r3.intValue, 2)
    let r4 = Rational(-10, 5)
    XCTAssertEqual(r4.intValue, -2)
  }
  
  func testRationalize() {
    let r1 = Rational<Int>(1.0/3.0)
    XCTAssertEqual(r1, Rational(1, 3))
    let r2 = Rational<Int>(1931.0 / 9837491.0, precision: 1.0e-14)
    XCTAssertEqual(r2, Rational(1931, 9837491))
    let r3 = Rational<Int>(-17.0/3.0)
    XCTAssertEqual(r3, -Rational(17, 3))
    let r4 = Rational<BigInt>(1931.0 / 9837491.0, precision: 1.0e-14)
    XCTAssertEqual(r4, Rational(BigInt(1931), BigInt(9837491)))
  }
    
  func testCasting() {
    let i1 = Int(Rational(9/3))
    XCTAssertEqual(i1, 3)
    let i2 = Int(Rational(10/3))
    XCTAssertEqual(i2, 3)
    let i3 = Int(Rational(8/3))
    XCTAssertEqual(i3, 2)
    
    let r4 = Rational<Int>(11/5)
    let i4 = Int64(r4)
    XCTAssertEqual(i4, 2)
  }

  static let allTests = [
    ("testConstructors", testConstructors),
    ("testNormalized", testNormalized),
    ("testPlus", testPlus),
    ("testMinus", testMinus),
    ("testTimes", testTimes),
    ("testDividedBy", testDividedBy),
    ("testEquals", testEquals),
    ("testRationalize", testRationalize),
  ]
}
