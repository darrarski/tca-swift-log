import ComposableArchitecture
import Logging
import PulseLogHandler
import PulseUI
import SwiftUI
import TCASwiftLog

@main
struct StandupsApp: App {
  init() {
    LoggingSystem.bootstrap(PersistentLogHandler.init)
  }

  var body: some Scene {
    WindowGroup {
      // NB: This conditional is here only to facilitate UI testing so that we can mock out certain
      //     dependencies for the duration of the test (e.g. the data manager). We do not really
      //     recommend performing UI tests in general, but we do want to demonstrate how it can be
      //     done.
      if ProcessInfo.processInfo.environment["UITesting"] == "true" {
        UITestingView()
      } else if _XCTIsTesting {
        // NB: Don't run application when testing so that it doesn't interfere with tests.
        EmptyView()
      } else {
        TabView {
          AppView(
            store: Store(initialState: AppFeature.State()) {
              AppFeature()
                ._printChanges(.swiftLog(label: "ComposableArchitecture"))
            }
          )
          .tabItem {
            Label("Standups", systemImage: "app")
          }

          NavigationStack {
            ConsoleView(store: .shared)
          }
          .tabItem {
            Label("Logs Console", systemImage: "list.dash.header.rectangle")
          }
        }
      }
    }
  }
}

struct UITestingView: View {
  var body: some View {
    AppView(
      store: Store(initialState: AppFeature.State()) {
        AppFeature()
      } withDependencies: {
        $0.dataManager = .mock()
      }
    )
  }
}
