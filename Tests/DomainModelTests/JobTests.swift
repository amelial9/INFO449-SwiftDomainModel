import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }
    
    func testWithFractionalRate() {
        let job = Job(title: "Barista", type: .Hourly(13.75))
        XCTAssertEqual(job.calculateIncome(4), 55)
    }
    
    func testNegativeSalaryRaise() {
        let job = Job(title: "Engineer", type: .Salary(1000))
        job.raise(byPercent: -0.1)
        XCTAssertEqual(job.calculateIncome(0), 900)
    }
    
    func testRaiseByZeroPercent() {
      let job = Job(title: "Cashier", type: .Hourly(10.0))
      job.raise(byPercent: 0.0)
      XCTAssertEqual(job.calculateIncome(10), 100)
    }

    func testHourlyJobZeroHours() {
        let job = Job(title: "Cook", type: .Hourly(20.0))
        XCTAssertEqual(job.calculateIncome(0), 0)
    }

    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        ("testWithFractionalRate", testWithFractionalRate),
        ("testNegativeSalaryRaise", testNegativeSalaryRaise),
        ("testRaiseByZeroPercent", testRaiseByZeroPercent),
        ("testHourlyJobZeroHours", testHourlyJobZeroHours),
    ]
}
