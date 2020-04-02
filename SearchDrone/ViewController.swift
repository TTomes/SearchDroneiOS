import UIKit
import DJISDK
import DJIUXSDK

class ViewController: DUXDefaultLayoutViewController {
    
    // Add mission start and stop buttons
    @IBOutlet weak var missionStart: UIButton!
    @IBOutlet weak var missionStop: UIButton!

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Stylize buttons
        missionStart.layer.cornerRadius = 4
        missionStop.layer.cornerRadius = 4
        
        // Initially hide Stop button
        self.missionStop.isHidden = true
        
        // Do any additional setup after loading the view.
        self.contentViewController?.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.contentViewController?.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.contentViewController?.view.setNeedsDisplay()
        

    }
    
    // Add button functionality
    @IBAction func missionStartAction(_ sender: Any) {
        NSLog("Mission Started!!")
        
    }
    
    @IBAction func missionStopAction(_ sender: UIButton) {
        NSLog("Mission stopped!!")
    }
    
}

