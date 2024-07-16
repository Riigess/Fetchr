//
//  SettingsView.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/30/24.
//

import SwiftUI

struct SettingsView: View {
    @State var inMemoryOnly:Bool = true
    @State var storeLocal:Bool = false
    @State var useiCloud:Bool = false
    @State var storeInFilesApp:Bool = false
    
    @State var shareWithSlack:Bool = true
    @State var shareWithiMessage:Bool = true
    @State var shareWithDiscord:Bool = true
    @State var shareWithFilesApp:Bool = true
    
    @State var useEnvironmentVariablesMac:Bool = false
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Store Data")) {
                    Toggle("Store Data in-memory only", isOn: $inMemoryOnly)
                        .onChange(of: inMemoryOnly, initial: false) {
                            if inMemoryOnly {
                                withAnimation {
                                    storeLocal = false
                                    useiCloud = false
                                    storeInFilesApp = false
                                }
                            }
                            dumpState()
                        }
                    Toggle("Store Data Locally", isOn: $storeLocal)
                        .onChange(of: storeLocal, initial: false) {
                            withAnimation {
                                storeInFilesApp = false
                            }
                            dumpState()
                        }
                    Toggle("Store Data on iCloud", isOn: $useiCloud)
                        .onChange(of: useiCloud, initial: false) {
                            withAnimation {
                                storeLocal = true
                            }
                            dumpState()
                        }
                    Toggle("Store Data in file", isOn: $storeInFilesApp)
                    
                    //TODO: Create clear data locally, on iCloud, and last stored location in Files app buttons
                }
                Section(header: Text("Sharing")) {
                    Toggle("Allow sharing with Slack", isOn: $shareWithSlack)
                    Toggle("Allow sharing through iMessage", isOn: $shareWithiMessage)
                    Toggle("Allow sharing with Discord", isOn: $shareWithDiscord)
                    Toggle("Allow sharing with Email", isOn: $shareWithFilesApp)
                }
                Section(header: Text("Licensing")) {
                    NavigationLink("View {library_name} license") {
                        Text("Tapped on license A")
                    }
                }
                #if !RELEASE
                Section(header: Text("Variables")) {
#if os(macOS)
                    Toggle("Use Environment Variables", isOn: $useEnvironmentVariablesMac)
                    NavigationLink("View Imported Environment Variables") {
                        Text("There's nothing here Bob!")
                        //TODO: Create view that fetches environment variables and displays them for macOS
                    }
#endif
                    //TODO: Create a system to create & store app-level variables (and store them using the Store Data options)
                }
                #endif
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func dumpState() {
        let date = Date()
        print(" ---- Timestamp: \(date.description) ---- ")
        let values = [
            "storeLocal": storeLocal,
            "useiCloud": useiCloud,
            "storeInFilesApp": storeInFilesApp,
            "inMemoryOnly": inMemoryOnly
        ]
        for pair in values {
            print("\(pair.key): \(pair.value)")
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
