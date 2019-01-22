//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  private static var exchanges = ["USD": 1.0, "CAN": 1.25, "GBP": 0.5, "EUR": 1.5]
  
  public func convert(_ to: String) -> Money {
    let m = Int(Double(amount) * (Money.exchanges[to]! / Money.exchanges[currency]!))
    return Money(amount: m, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    let convertedSelf = self.convert(to.currency)
    return Money(amount: to.amount + convertedSelf.amount, currency: to.currency)
  }
  
  public func subtract(_ from: Money) -> Money {
    let convertedSelf = self.convert(from.currency)
    return Money(amount: from.amount - convertedSelf.amount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let h):
      return Int(h * Double(hours))
    case .Salary(let s):
      return s
    }
  }
  
  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let h):
      type = Job.JobType.Hourly(h + amt)
    case .Salary(let s):
      type = Job.JobType.Salary(Int(Double(s) + amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
      if (age > 18) {
        _job = value
      }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
      if (age > 18) {
        _spouse = value
      }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(_job) spouse:\(_spouse)]"
  }
}

////////////////////////////////////
// Family

open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    members.append(spouse1)
    members.append(spouse2)
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if !(members[1].age > 20 || members[0].age > 20) {
      return false
    }
    if members.contains(where: { $0.firstName == child.firstName && $0.lastName == child.lastName && $0.age == child.age}) {
      return false
    }
    members.append(child)
    return true
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for member in members {
      if let i = member.job?.calculateIncome(2000) {
        income += i
      }
    }
    return income
  }
}





