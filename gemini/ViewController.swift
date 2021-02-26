//
//  ViewController.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let navigationViewController = NavigationViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationViewController.modalPresentationStyle = .fullScreen
        present(navigationViewController, animated: true, completion: nil)
    }
    
}

