//
//  NavView.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/29/24.
//

import SwiftUI
import SwiftData

struct NavView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var requestData:[RequestData]
    #if os(iOS)
        let tabNavColor:Color = Color(red: Double(0x30) / 255.0, green: Double(0x3A) / 255.0, blue: Double(0xCB) / 255.0) //Background tab view color
    #elseif os(tvOS)
        let tabNavColor:Color = Color(red: Double(0x44) / 255.0, green: Double(0x48) / 255.0, blue: Double(0x82) / 255.0)
    #endif
    
    let useThinPlus:Bool = true
    let deviceWidth:CGFloat = UIScreen.main.bounds.width
    let deviceHeight:CGFloat = UIScreen.main.bounds.height
    let grayTabViewColor:Color = Color(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0)
    
    static let isDarkMode:Bool = UIScreen.main.traitCollection.userInterfaceStyle == .dark
    
    @State var selection:Int = 0
    
    init() {
        #if os(iOS)
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(cgColor: tabNavColor.cgColor!)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().compactAppearance = coloredAppearance //Not sure when this one shows up.. Maybe when searching?
        UINavigationBar.appearance().standardAppearance = coloredAppearance //When scrolling begins
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance //When Title is BIG
        
        UINavigationBar.appearance().tintColor = coloredAppearance.backgroundColor
        #endif
        
        let tabBarColoredAppearance = UITabBarAppearance()
        tabBarColoredAppearance.configureWithOpaqueBackground()
        tabBarColoredAppearance.backgroundColor = UIColor(cgColor: tabNavColor.cgColor!)
        
        UITabBar.appearance().scrollEdgeAppearance = tabBarColoredAppearance //What happens when there is no content behind it
        UITabBar.appearance().standardAppearance = tabBarColoredAppearance //What happens when there is content behind it
    }
    
    var body: some View {
        if #available(iOS 18.0, tvOS 18.0, watchOS 11.0, macOS 15.0, *) {
            TabView {
                Tab("Home", systemImage: "house") {
                    HomeView(navTitle: "REST Requester")
                        .modelContext(modelContext)
                }
                Tab("Automation", systemImage: "wrench") {
                    AutomationView()
                        .modelContext(modelContext)
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                        .modelContext(modelContext)
                }
                #if os(tvOS)
                Tab {
                    SetupConnectionView()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                #endif
            }
            #if DEBUG
            .task {
                print("iOS 18.0")
            }
            #endif
            .tint(.white)
        }
        else if #available(iOS 17.0, tvOS 17.0, watchOS 10.0, macOS 14.0, *) {
            NavigationView {
                TabView(selection: $selection) {
                    HomeView(navTitle: "REST Requester")
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(0)
                    AutomationView()
                        .tabItem {
                            Label("Automation", systemImage: "wrench")
                        }
                        .tag(1)
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(2)
                    #if os(tvOS)
                    SetupConnectionView()
                        .tabItem {
                            Label("New", systemImage: "square.and.pencil")
                        }
                    #endif
                }
                #if DEBUG
                .task {
                    print("iOS 17.X")
                }
                #endif
                .tint(.white)
                .onAppear {
                    UITabBar.appearance().unselectedItemTintColor = .white
                    print("Appeared")
                }
            }
        }
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}
