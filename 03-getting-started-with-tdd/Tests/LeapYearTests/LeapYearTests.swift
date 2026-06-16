@testable import LeapYear
import Testing

@Test func `a year evenly divisible by 4 is leap`() {
    let year = 2020         // Arrange

    let leap = isLeap(year) // Act

    #expect(leap)           // Assert
}

@Test func `a year evenly divisible by 100 is not leap`() {
    #expect(isLeap(2100) == false)
}

@Test func `a year evenly divisible by 400 is leap`() {
    #expect(isLeap(2000))
}

@Test func `a year not evenly divisible by 4 or 400 is not leap`() {
    #expect(isLeap(2021) == false)
}
