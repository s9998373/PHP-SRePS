//
//  TransactionTableViewCell.swift
//  PHP-SRePS
//
//  Created by School on 20/09/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// Override for convenience and to deter mistakes from people unfamiliar with the codebase.
    override var textLabel: UILabel?{
        return dateLabel
    }
    
    /// Override for convenience and to deter mistakes from people unfamiliar with the codebase.
    override var detailTextLabel: UILabel?{
        return descriptionLabel
    }

}
