//
//  ViewController.swift
//  Fetchr
//
//  Created by Austin Bennett on 8/14/24.
//

import UIKit

class FirstViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        title = "First Tab"
    }
}

class SecondViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        title = "Second Tab"
    }
}

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupTabBarViews(view.window)
        
        print("View Appeared!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View Loaded!")
    }

    func setupTabBarViews(_ window:UIWindow) {
		let firstVC = FirstViewController()
        let secondVC = SecondViewController()

        firstVC.tabBarItem = UITabBarItem(title: "First", image: UIImage(systemName: "house"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "Second", image: UIImage(systemName: "gear"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstVC, secondVC]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
