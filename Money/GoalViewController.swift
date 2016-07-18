import UIKit

class GoalViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // goals
    @IBOutlet weak var aimLabel: UILabel!
    @IBOutlet weak var aimTextfield: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    
    // balance
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var userBal: UITextField!
    @IBOutlet weak var addBal: UIButton!
    @IBOutlet weak var subBal: UIButton!
    
    // description    
    @IBOutlet weak var descTextField: UITextView!
    
    /*
        This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
        or constructed as part of adding a new meal.
    */
    var goal: Goal?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        //descTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let goal = goal {
            navigationItem.title = goal.name
            nameTextField.text   = goal.name
            aimLabel.text        = String(format:"%.2f", goal.aim) //String(goal.aim)
            balanceLabel.text    = String(format:"%.2f", goal.aim) //String(goal.balance)
            descTextField.text   = goal.desc

            
        } else {
            aimLabel.text        = String(format: "%.2f", 0.00)
            balanceLabel.text    = String(format: "%.2f", 0.00)
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidName()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidName()
        navigationItem.title = textField.text
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: goal button method
    @IBAction func changeGoal(sender: AnyObject) {
        let aim = Double(aimTextfield.text!) ?? Double(aimLabel.text!)
        aimLabel.text = String(format: "%.2f", aim!)
    }
    
    // MARK: Button methods


    @IBAction func addBal(sender: AnyObject) {
        let val = Double(userBal.text!) ?? 0
        var bal = Double(balanceLabel.text!)
        bal! += val
        balanceLabel.text = String(format: "%.2f", bal!)
    }
    
    @IBAction func subBal(sender: AnyObject) {
        let val = Double(userBal.text!) ?? 0
        var bal = Double(balanceLabel.text!)
        bal! -= val
        balanceLabel.text = String(format: "%.2f", bal!)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddGoalMode = presentingViewController is UINavigationController
        
        if isPresentingInAddGoalMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name    = nameTextField.text ?? ""
            let aim     = Double(aimLabel.text!) ?? Double(0)
            let balance = Double(balanceLabel.text!) ?? Double(0)
            let desc    = descTextField.text ?? ""
            
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            goal = Goal(name: name, aim: aim, balance: balance, desc: desc)
        }
    }
    


}

