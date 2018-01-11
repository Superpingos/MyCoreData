//
//  TableViewController.swift
//  MyCoreData
//
//  Created by Superpingos on 14.09.17.
//
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    private var datas = [[String:Any]]()
    
    let segueEditIdentifier:String = "editPerson"
    
    var frc:NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = ""
        
        // Available > iOS 10.0
        let refreshTableView = UIRefreshControl()
        refreshTableView.backgroundColor = UIColor.lightGray
        let refreshText = NSLocalizedString("Pull to refresh", comment: "")
        refreshTableView.attributedTitle = NSAttributedString(string: refreshText)
        refreshTableView.addTarget(self, action: #selector(newRandomPerson), for: .valueChanged)
        self.tableView.refreshControl = refreshTableView
        
        frc = getFRC()
        frc.delegate = self
        
        do {
            try frc.performFetch()
            //print("*> \(frc)")
        } catch {
            print("\(error.localizedDescription)")
            //return
        }
        self.displayList()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.displayList()
        //print("\(#function) > Content did change!")
    }
    /*
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("\(#function)")
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        print("\(#function)")
        return "-x-"
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("\(#function)")
     
        // for type > .Insert / .Delete / .Update / .Move
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        print("\(#function)")
    }
    */
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        if let sections = frc.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath)

        // Configure the cell...
        var dogNameAndAge:String = ""
        
        let person = frc.object(at: indexPath) as! Person
        
        if let dog = person.dogs {
            if dog.allObjects.count > 0 {
                if let aDog = dog.allObjects as? [Dog] {
                    let yearOld = NSLocalizedString("y.o", comment: "")
                    dogNameAndAge = "\(aDog[0].name!) - \(aDog[0].age) \(yearOld)"
                }
            }
        }
        
        cell.textLabel?.text = person.fullname
        cell.detailTextLabel?.text = dogNameAndAge
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            // Delete the row from the data source
            let wantToDelete = frc.object(at: indexPath) as! NSManagedObject
            context.delete(wantToDelete)
            
            do {
                try context.save()
            } catch {
                let err = error as NSError
                print("\(err.localizedDescription)")
                //return
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print("\(#function) > Editing...")
        }    
    }
    /*
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
    */
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == segueEditIdentifier {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)!    // change!
            
            let newPersonController:NewPersonTableViewController = segue.destination as! NewPersonTableViewController
            let person:Person = frc.object(at: indexPath) as! Person
            
            newPersonController.person = person
            //print("\(#function) > Edit...")
        }
    }
    @IBAction func deleteAll(_ sender: UIBarButtonItem)
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        delete.resultType = .resultTypeCount
        
        do {
            let deleteRows = try context.execute(delete) as! NSBatchDeleteResult
            print("\(#function) > \(deleteRows.result!) row(s) deleted")
            context.reset()
            //try frc.performFetch()        // why?
            displayList()
        } catch {
            let err = error as NSError
            print("\(#function) > Delete all err: \(err.localizedDescription)")
        }
    }
    
    // MARK: -
    func dataCount() -> Int
    {
        var count:Int = 0
        
        if let rows = frc.fetchedObjects {
            count = rows.count
        }
        //print("\(#function) > Row #\(count)")
        return count
    }
    func displayList()
    {
        let count = dataCount()
        
        let person_s = (count > 1 ? NSLocalizedString("people", comment: "") : NSLocalizedString("person", comment: ""))
        self.navigationItem.title = "\(count) \(person_s)"
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        //print("\(#function) > #\(count)")
    }
    @objc func newRandomPerson()
    {
        let datasCount = dataCount() + 1
        let fullname = "Person_\(datasCount)"
        let name = "dog_\(datasCount)"
        let age = datasCount
        let pId = UUID().uuidString
        let dId = UUID().uuidString
        
        let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let aPerson = Person(entity: personEntity!, insertInto: context)
        
        let dogEntity = NSEntityDescription.entity(forEntityName: "Dog", in: context)
        let aDog = Dog(entity: dogEntity!, insertInto: context)
        
        aPerson.id_person = pId
        aPerson.fullname = fullname
        aPerson.addToDogs(aDog)
        
        aDog.id_dog = dId
        aDog.name = name
        aDog.age = Int32(age)
        aDog.owner = aPerson
        
        do {
            try context.save()
        } catch {
            let err = error as NSError
            print("Saving err: \(err.localizedDescription)")
        }
    }
    /* Not used
    func getFeReCo() -> NSFetchedResultsController<NSFetchRequestResult>
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let sorter = NSSortDescriptor(key: "fullname", ascending: false)
        fetchRequest.sortDescriptors = [sorter]
        //fetchRequest.fetchLimit = 2
        //fetchRequest.fetchBatchSize = 20
        //fetchRequest.returnsObjectsAsFaults = false
     
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
    */
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        /**
         *  %K: propertie name, %@: string, %i: int, float?
         * Basic comparisons: == (=), >= (=>), <= (=<), != (<>), <, >, between {0, 10}
         * Basic compound predicate: && (and), || (or), ! (not)
         * Str comparison: contains &@, like, matches, beginswith, endswith
         * Str comparison: contains[c|d] %@ => c: case insensitivity, d: diacritic insensitivity
         * Aggregate Operation: any (some), all, none, in
         */
        //fetchRequest.predicate = NSPredicate(format: "%K like %@", "fullname", "Mickey")
        //fetchRequest.predicate = NSPredicate(format: "%K contains %@", "fullname", "ck")
        //fetchRequest.predicate = NSPredicate(format: "%K beginswith[c] %@", "fullname", "m")
        //fetchRequest.predicate = NSPredicate(format: "any %K > %i", "dogs.age", 1)
        
        let sorter = NSSortDescriptor(key: "fullname", ascending: false)
        fetchRequest.sortDescriptors = [sorter]
        //fetchRequest.fetchLimit = 2
        //fetchRequest.fetchBatchSize = 20
        //fetchRequest.returnsObjectsAsFaults = false
        //fetchRequest.resultType = .dictionaryResultType       // def: NSManagedObjectResult
        
        return fetchRequest
    }
    func getFRC() -> NSFetchedResultsController<NSFetchRequestResult>
    {
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
}
