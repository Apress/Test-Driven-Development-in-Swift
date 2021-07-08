#!/usr/bin/env xcrun swift

func fizzBuzz(_ number: Int) -> String {
    let divisibleBy3 = number % 3 == 0
    let divisibleBy5 = number % 5 == 0
    switch (divisibleBy3, divisibleBy5) {
        case (false, false): return "\(number)"
        case (true, false): return "fizz"
        case (false, true): return "buzz"
        case (true, true): return "fizz buzz"
    }
}

func test(value: String, matches expect: String) {
    if value == expect {
        print("PASSED")
    } else {
        print("FAILED")
    }
}

func testFizzBuzz() {
    test(value: fizzBuzz(1), matches: "1")
    test(value: fizzBuzz(3), matches: "fizz")
    test(value: fizzBuzz(5), matches: "buzz")
    test(value: fizzBuzz(15), matches: "fizz buzz")
}

func main() {
    let usage = "Usage: ./fizz_buzz.swift number"

    guard CommandLine.argc > 1 else {
        print(usage)
        return
    }

    guard let number = Int(CommandLine.arguments[1]) else {
        print(usage)
        return
    }

    print(fizzBuzz(number))
}

// TODO: explain why we need to either run main or test? Alternatively, extract
// the tests in a dedicated file?
main()
// testFizzBuzz()
