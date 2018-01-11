//
//  NewPersonTableViewController.swift
//  MyCoreData
//
//  Created by Superpingos on 06.01.18.
//

import UIKit
import CoreData

class NewPersonTableViewController: UITableViewController, UITextFieldDelegate
{

    @IBOutlet weak var pFullname: UITextField!
    @IBOutlet weak var dName: UITextField!
    @IBOutlet weak var dAge: UITextField!
    
    var person:Person? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if person == nil {
            self.navigationItem.title = NSLocalizedString("Add new person", comment: "")
        } else {
            pFullname.text = person?.fullname
            if let dog = person?.dogs {
                if dog.allObjects.count > 0 {
                    if let aDog = dog.allObjects as? [Dog] {
                        dName.text = aDog[0].name!
                        dAge.text = "\(aDog[0].age)"
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return (section == 1 ? 2 : 1)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("\(#function) > indexpath: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "aNewCell", for: indexPath) as! NewPersonTableViewCell
        print("\(#function) > cell: \(cell)")
        
        // Configure the cell...
        //cell.personFullname.text = "A"
        //cell.dgoName.text = "B"
        //cell.dogAge.text = "C"
            
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    {

    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
     
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITextFieldDelegate
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("\(#function) > \(textField) >> \(textField.tag)")
        let currentTag = textField.tag
        let nextResponder = textField.superview?.viewWithTag(currentTag + 1) as? UITextField
        
        if currentTag != 0 {
            nextResponder.becomeFirstResponder()
            print("\(#function) > ")
        } else {
            textField.resignFirstResponder()
        }
        return false
    }*/
    
    // MARK: - Custom func
    func emptyInput(inputText: UITextField)
    {
        inputText.layer.borderColor = UIColor.red.cgColor
        inputText.layer.borderWidth = 1.0
        inputText.layer.cornerRadius = 5.0
    }
    
    func resetInput(inputText: UITextField)
    {
        inputText.layer.borderColor = UIColor.clear.cgColor
        inputText.layer.borderWidth = 0.0
        inputText.layer.cornerRadius = 0.0
    }
    
    // MARK: - Actions
    @IBAction func saveAction(_ sender: UIBarButtonItem)
    {
        guard let person_fullname = pFullname.text, person_fullname != "" else {
            self.emptyInput(inputText: pFullname)
            //print("\(#function) > fullname is empty")
            return
        }
        self.resetInput(inputText: pFullname)
        
        guard let dog_name = dName.text, dog_name != "" else {
            self.emptyInput(inputText: dName)
            //print("\(#function) > name is empty")
            return
        }
        self.resetInput(inputText: dName)
        //print("\(#function) > \(person_fullname) - \(dog_name)")
        
        let personId = UUID().uuidString
        let dogId = UUID().uuidString
        
        if person == nil {
            let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: context)
            let aPerson = Person(entity: personEntity!, insertInto: context)
            
            let dogEntity = NSEntityDescription.entity(forEntityName: "Dog", in: context)
            let aDog = Dog(entity: dogEntity!, insertInto: context)
            
            aPerson.id_person = personId
            aPerson.fullname = person_fullname
            aPerson.addToDogs(aDog)
            
            aDog.id_dog = dogId
            aDog.name = dog_name
            if let dog_age = dAge.text, dog_name != "" {
                aDog.age = Int32(dog_age)!
            }
            aDog.owner = aPerson
        } else {
            person?.fullname = pFullname.text
            person?.id_person = personId
            
            if let dogs = person?.dogs?.allObjects {
                let dog = dogs[0] as! Dog
                dog.id_dog = dogId
                dog.name = dName.text
                if let dog_age = dAge.text, dog_name != "" {
                    dog.age = Int32(dog_age)!
                }
            }
        }
        
        do {
            try context.save()
        } catch {
            let err = error as NSError
            print("Saving err: \(err.localizedDescription)")
        }
        self.navigationController?.popViewController(animated: true)
        //print("\(#function)")
    }
    @IBAction func dismissKeyboard(_ sender: UITextField)
    {
        self.resignFirstResponder()
    }
}
