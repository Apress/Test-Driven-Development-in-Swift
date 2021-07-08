#!/usr/bin/env xcrun swift

// There is currently (5 years later!) no way for a Swift script to import
// another script.
//
// What follows is a bit of a hack where we test the fizz-buzz implementation
// from fizz_buzz.swift by calling the script directly.
//
// I find this acceptable in the context of providing an harness for showing
// how to write code that tests other code as part of the introduction of
// Test-Driven Development in Swift (https://tddinswift.com). It definitely is
// not a scalabe solution for testing Swift scripts, but, again, that's not
// what the examples in the book introduction are about.

import Foundation

/// Run a shell command and capture its output
func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/sh"
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output.trimmingCharacters(in: .whitespacesAndNewlines)
}

/// Call the fizz-buzz script with a given input and return the script's output.
func fizzBuzz(_ number: Int) -> String {
    return shell("./fizz_buzz.swift \(number)")
}

/// Check if two input `String`s are equal, printing "PASSED" if true and
/// "FAILED" otherwise.
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

testFizzBuzz()
