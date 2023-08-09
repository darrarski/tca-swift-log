import ComposableArchitecture
import Logging

extension _ReducerPrinter {
  /// Logs info about received actions and state changes to swift-log's Logger with provided label.
  ///
  /// Example usage:
  /// ```
  /// let store = Store(initialState: AppFeature.State()) {
  ///   AppFeature()._printChanges(.swiftLog(label: "tca"))
  /// }
  /// ```
  ///
  /// - Parameter label: Logger's label
  public static func swiftLog(label: String) -> Self {
    var logger = Logger(label: label)
    logger.logLevel = .debug
    return swiftLog(logger)
  }

  /// Logs info about received actions and state changes to provided swift-log's Logger.
  ///
  /// Example usage:
  /// ```
  /// var logger = Logger(label: "tca")
  /// logger.logLevel = .debug
  /// let store = Store(initialState: AppFeature.State()) {
  ///   AppFeature()._printChanges(.swiftLog(logger))
  /// }
  /// ```
  ///
  /// - Parameter logger: Logger
  public static func swiftLog(_ logger: Logger) -> Self {
    Self { receivedAction, oldState, newState in
      var message = "received action:\n"
      CustomDump.customDump(receivedAction, to: &message, indent: 2)
      message.write("\n")
      message.write(diff(oldState, newState).map { "\($0)\n" } ?? "  (No state changes)\n")
      logger.debug(.init(stringLiteral: message))
    }
  }
}
