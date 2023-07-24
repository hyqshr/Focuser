import SwiftUI
import UserNotifications
@available(macOS 13.0, *)
@main
struct Dad_JokesApp: App {
    @AppStorage("currentFocus") var currentFocus: String = ""
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        MenuBarExtra {
            MainView()
        } label: {
            if currentFocus.isEmpty{
                Text("Focuser")
            } else{
                Text(currentFocus)
            }
        }
        .menuBarExtraStyle(.window)
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()
    
    func applicationDidFinishLaunching(_ notification: Notification) {

        AppDelegate.instance = self
        statusBarItem.button?.image = NSImage(named: NSImage.Name("CWC"))
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
        UNUserNotificationCenter.current().delegate = self
        
        popover.contentSize = NSSize(width: 500, height: 500)
        popover.contentViewController = NSHostingController(rootView: MainView())
    }
    
    func appllicationWillTerminate(_ aNotification: Notification) {
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.list, .sound])
    }
}

