import ComposableArchitecture
import CustomDump
import Logging
import XCTest
@testable import TCASwiftLog

final class ReducerPrinterTests: XCTestCase {
  func testPrint() throws {
    enum Action {
      case test1
      case test2
    }
    struct State {
      var count: Int
    }
    let handler = TestLogHandler()
    let logger = Logger(label: "test", factory: { _ in handler })
    let printer = _ReducerPrinter<State, Action>.swiftLog(logger)
    printer.printChange(
      receivedAction: .test1,
      oldState: .init(count: 0),
      newState: .init(count: 1)
    )
    printer.printChange(
      receivedAction: .test2,
      oldState: .init(count: 1),
      newState: .init(count: 1)
    )

    XCTAssertNoDifference(handler.logged, [
      .init(
        level: .debug,
        message: """
        received action:
          ReducerPrinterTests.Action.test1
        - ReducerPrinterTests.State(count: 0)
        + ReducerPrinterTests.State(count: 1)

        """
      ),
      .init(
        level: .debug,
        message: """
        received action:
          ReducerPrinterTests.Action.test2
          (No state changes)

        """
      )
    ])
  }
}

private class TestLogHandler: LogHandler {
  struct Logged: Equatable {
    var level: Logger.Level
    var message: Logger.Message
  }

  init() {}

  var logged: [Logged] = []

  @inlinable func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {
    logged.append(.init(level: level, message: message))
  }

  @inlinable subscript(metadataKey _: String) -> Logger.Metadata.Value? {
    get { nil }
    set {}
  }

  @inlinable var metadata: Logger.Metadata {
    get { [:] }
    set {}
  }

  @inlinable var logLevel: Logger.Level {
    get { .debug }
    set {}
  }
}
