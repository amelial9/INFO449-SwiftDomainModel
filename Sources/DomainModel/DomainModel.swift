struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount: Int
    public var currency: String
    
    private static let currencies = ["USD", "GBP", "EUR", "CAN"]
    private static let toUSDExchangeRates: [String: Double] = [
        "USD": 1.0,
        "GBP": 2.0,
        "EUR": 2.0/3.0,
        "CAN": 0.8
    ]
    
    private static let fromUSDExchangeRates: [String: Double] = [
        "USD": 1.0,
        "GBP": 0.5,
        "EUR": 1.5,
        "CAN": 1.25
    ]
    
    public init (amount: Int, currency: String) {
        guard Money.currencies.contains(currency) else {
            fatalError("Unsupported currency")
        }
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ target: String) -> Money {
        guard Money.currencies.contains(target) else {
            fatalError("Unsupported currency")
        }
        
        let inUSD = Double(self.amount) * Money.toUSDExchangeRates[self.currency]!
        let converted = inUSD * Money.fromUSDExchangeRates[target]!
        return Money(amount: Int(converted.rounded()), currency: target)
    }
    
    public func add (_ other: Money) -> Money {
        let converted = self.convert(other.currency)
        return Money(amount: converted.amount + other.amount, currency: other.currency)
    }
    
    public func subtract (_ other: Money) -> Money {
        let converted = self.convert(other.currency)
        return Money(amount: converted.amount - other.amount, currency: other.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public var title: String
    public var type: JobType
    
    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public func calculateIncome(_ hours: Int) -> Int {
        switch type {
            case .Hourly(let hourlyRate):
                return Int(hourlyRate * Double(hours))
            case .Salary(let salary):
                return Int(salary)
        }
    }
    
    public func raise(byAmount amount: Double) {
        switch type {
            case .Hourly(let rate):
                type = .Hourly(rate + amount)
            case .Salary(let salary):
                type = .Salary(salary + UInt(amount))
        }
    }
    
    public func raise(byPercent percent: Double) {
        switch type {
            case .Hourly(let rate):
                type = .Hourly(rate * (1+percent))
            case .Salary(let salary):
            type = .Salary(UInt(Double(salary) * (1+percent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    public var firstName: String
    public var lastName: String
    public var age: Int
    
    private var _job: Job?
    public var job: Job? {
        get { return _job }
        set {
            if age >= 16 {
                _job = newValue
            }
        }
    }
    
    private var _spouse: Person?
    public var spouse: Person? {
        get { return _spouse }
        set {
            if age >= 18 {
                _spouse = newValue
            }
        }
    }
    
    public init(firstName: String = "", lastName: String = "", age: Int) {
        if firstName.isEmpty && lastName.isEmpty {
            fatalError("At least one of firstName / lastName must be provided.")
        }
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        let jobDetail = job.map {
            switch $0.type {
                case .Hourly(let rate): return "Hourly(\(rate))"
                case .Salary(let salary): return "Salary(\(salary))"
            }
        } ?? "nil"
        
        let spouseName = spouse?.firstName ?? "nil"
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobDetail) spouse:\(spouseName)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    public var members: [Person]
    
    public init (spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        
        members = [spouse1, spouse2]
    }
    
    public func haveChild (_ child: Person) -> Bool {
        if members[0].age >= 21 || members[1].age >= 21 {
            members.append(child)
            return true
        }
        return false
    }
    
    public func householdIncome() -> Double {
        var income: Double = 0.0
        
        for member in members {
            if let job = member.job {
                income += Double(job.calculateIncome(2000))
            }
        }
        return income
    }
}
