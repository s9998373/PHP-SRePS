//
//  CustomTimeframeSelectorReportViewController.swift
//  PHP-SRePS
//
//  Created by School on 20/09/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

class CustomTimeframeSelectorReportViewController: UIViewController {

    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem.init(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CustomTimeframeSelectorReportViewController.nextButtonPressed))
        self.navigationItem.rightBarButtonItem = nextButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextButtonPressed(){
        
    }

}
