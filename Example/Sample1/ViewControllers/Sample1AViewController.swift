//
//  Sample1AViewController.swift
//  Example
//
//  Created by crexista on 2016/11/24.
//  Copyright © 2016年 crexista. All rights reserved.
//

import UIKit

class Sample1AViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var nextButtonA: UIButton!
    
    @IBOutlet weak var nextButtonB: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    
    deinit {
        print("sample1A deinit")
    }
}
