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
    swiftLog(Logger(label: label))
  }

  /// Logs info about received actions and state changes to provided swift-log's Logger.
  ///
  /// Example usage:
  /// ```
  /// let store = Store(initialState: AppFeature.State()) {
  ///   AppFeature()._printChanges(.swiftLog(Logger(label: "tca")))
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
      logger.info(.init(stringLiteral: message))
    }
  }
}
