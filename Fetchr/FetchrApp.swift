//
//  REST_RequesterApp.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/21/24.
//

import SwiftUI
import SwiftData

@main
struct FetchrApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RequestData.self,
            HeaderData.self,
            HeaderRow.self,
            BodyData.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let predicate = #Predicate<RequestData> {
                !$0.name.isEmpty
            }
            let descriptor = FetchDescriptor<RequestData>(predicate: predicate)
            
#if DEBUG && !RELEASE
            if try container.mainContext.fetch(descriptor).count == 0 {
                let urls = ["https://api.riotgames.com/v3/blah/blah/nah/nah", "https://api.riotgames.com/v3/nah/nah/blah/blah", "https://api.riotgames.com/v3/blah/blah/nah"]
                let requestTypes = [RequesterMethod.GET, RequesterMethod.DELETE, RequesterMethod.PUT, RequesterMethod.POST]
                var transferableData:[[Any]] = []
                for i in 0..<20 {
                    transferableData.append([])
                    transferableData[i].append(requestTypes[i % requestTypes.count])
                    let idxStr = i % 10 == i ? "0\(i)" : "\(i)"
                    transferableData[i].append("Row\(idxStr)")
                    transferableData[i].append(!(i % 3 == 0))
                    transferableData[i].append(urls[i % urls.count])
                }
                for d in transferableData {
                    container.mainContext.insert(RequestData(url: d[3] as! String, method: d[0] as! RequesterMethod, name: d[1] as! String))
                }
                do {
                    try container.mainContext.save()
                } catch {
                    fatalError("Cannot save data with error: \(error)")
                }
                print("RequestData Length: \(try container.mainContext.fetch(descriptor).count)")
            }
#endif
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
#if os(macOS)
        MenuBarExtra("Inspect", systemImage: "eyedropper") {
            VStack {
                Button("Action One") {
                    print("Action One clicked on Mac!")
                }
            }
        }
#endif
    }
}
