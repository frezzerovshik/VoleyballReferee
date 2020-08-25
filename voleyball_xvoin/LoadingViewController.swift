//
//  LoadingViewController.swift
//  voleyball_xvoin
//
//  Created by Артем Шарапов on 20.08.2020.
//  Copyright © 2020 Artem Sharapov. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    let image = UIImageView(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "logo", ofType: "jpg")!))
    
    var buttonStart = UIButton(type: .roundedRect)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        image.frame = view.frame
        view.addSubview(image)
        self.navigationController?.pushViewController(GameScoreViewController(), animated: true)
    }
}
