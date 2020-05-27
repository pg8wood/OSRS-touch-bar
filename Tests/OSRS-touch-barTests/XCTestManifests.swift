import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OSRS_touch_barTests.allTests),
    ]
}
#endif
