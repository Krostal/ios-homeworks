//
//  InfoViewController.swift
//  Navigation
//
//  Created by Konstantin Tarasov on 10.06.2023.
//

import UIKit

class InfoViewController: UIViewController {

    private lazy var buttonDelete: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("Delete this post", for: .normal)
        deleteButton.setTitleColor(.darkText, for: .normal)
        deleteButton.backgroundColor = .systemCyan
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        setupUI()
        buttonDelete.addTarget(self, action: #selector(pressDelete(_:)), for: .touchDown)

    }
    
    private func setupUI() {
        view.addSubview(buttonDelete)
        
        NSLayoutConstraint.activate([
            buttonDelete.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 50
            ),
            buttonDelete.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -50
            ),
            buttonDelete.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            buttonDelete.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    @objc func pressDelete(_ sender: UIButton) {
        
        Alert.showAlert(on: self)
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
