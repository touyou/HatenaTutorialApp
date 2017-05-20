//
//  DetailViewController.swift
//  HatenaTutorial
//
//  Created by 藤井陽介 on 2017/05/20.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var repository: Repository? {
        
        didSet {
            
            configureView()
        }
    }

    fileprivate func configureView() {
        // Update the user interface for the detail item.
        if let repository = repository {
            
            if let label = detailDescriptionLabel {
                
                label.text = repository.name
            }
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
}

