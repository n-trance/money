import UIKit

class GoalTableViewController: UITableViewController {
    // MARK: Properties
    
    var goals = [Goal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved goals, otherwise load sample data.
        if let savedgoals = loadGoals() {
            goals += savedgoals
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // cols
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GoalTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GoalTableViewCell
        
        // Fetches the appropriate goal for the data source layout.
        let goal = goals[indexPath.row]
        
        cell.nameLabel.text    = goal.name
        cell.balanceLabel.text = "$" + String(format: "%.2f", goal.balance)
        cell.aimLabel.text     = "$" + String(format: "%.2f", goal.aim)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            goals.removeAtIndex(indexPath.row)
            saveGoals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let goalDetailViewController = segue.destinationViewController as! GoalViewController
            
            // Get the cell that generated this segue.
            if let selectedgoalCell = sender as? GoalTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedgoalCell)!
                let selectedgoal = goals[indexPath.row]
                goalDetailViewController.goal = selectedgoal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new goal.")
        }
    }
    

    @IBAction func unwindTogoalList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? GoalViewController, goal = sourceViewController.goal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing goal.
                goals[selectedIndexPath.row] = goal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new goal.
                let newIndexPath = NSIndexPath(forRow: goals.count, inSection: 0)
                goals.append(goal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the goals.
            saveGoals()
        }
    }
 

    // MARK: NSCoding
    
    func saveGoals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(goals, toFile: Goal.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save goals...")
        }
    }
    
    func loadGoals() -> [Goal]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Goal.ArchiveURL.path!) as? [Goal]
    }
}
