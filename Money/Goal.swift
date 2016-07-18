import UIKit

class Goal: NSObject, NSCoding {
    // MARK: Properties
    
    var name: String
    var aim: Double
    var balance: Double
    var desc: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("goal")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey    = "name"
        static let aimKey     = "aim"
        static let balanceKey = "balance"
        static let descKey    = "desc"
    }

    // MARK: Initialization
    
    init?(name: String, aim: Double, balance: Double, desc: String) {
        // Initialize stored properties.
        self.name    = name
        self.aim     = aim
        self.balance = balance
        self.desc    = desc
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(aim, forKey: PropertyKey.aimKey)
        aCoder.encodeObject(balance, forKey: PropertyKey.balanceKey)
        aCoder.encodeObject(desc, forKey: PropertyKey.descKey)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name    = aDecoder.decodeObjectForKey(PropertyKey.nameKey)      as! String
        let aim     = aDecoder.decodeObjectForKey(PropertyKey.aimKey)       as! Double
        let balance = aDecoder.decodeObjectForKey(PropertyKey.balanceKey)   as! Double
        let desc    = aDecoder.decodeObjectForKey(PropertyKey.descKey)      as! String
        
        // Must call designated initializer.
        self.init(name: name, aim: aim, balance: balance, desc: desc)
    }

}