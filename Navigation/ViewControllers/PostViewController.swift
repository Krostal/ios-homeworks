//
//  PostViewController.swift
//  Navigation
//
//  Created by Konstantin Tarasov on 10.06.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    var titlePost: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        self.navigationItem.title = titlePost
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(barButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    
    @objc func barButtonItemTapped(_ sender: UIBarButtonItem) {
        let infoViewController = InfoViewController()
        infoViewController.modalTransitionStyle = .coverVertical
        infoViewController.modalPresentationStyle = .pageSheet
        present(infoViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
