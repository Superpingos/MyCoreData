//
//  NewPersonTableViewCell.swift
//  MyCoreData
//
//  Created by Superpingos on 06.01.18.
//

import UIKit

class NewPersonTableViewCell: UITableViewCell
{
    @IBOutlet weak var personFullname: UITextField!
    @IBOutlet weak var dgoName: UITextField!
    @IBOutlet weak var dogAge: UITextField!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
