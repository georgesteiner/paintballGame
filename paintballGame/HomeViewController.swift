import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var paintballSpeedSlider: UISlider!
    @IBOutlet weak var paintballSpeedLabel: UILabel!
    let prefs = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintballSpeedLabel.text = "\(paintballSpeedSlider.value)"
        
        
        
        prefs.setValue(paintballSpeedSlider.value, forKey: "paintballSpeed")

        
    }
    
    @IBAction func paintballSpeedliderValueChanged(sender: AnyObject) {
        
        print("slider value: \(paintballSpeedSlider.value)")
        
        paintballSpeedLabel.text = "\(paintballSpeedSlider.value)"
        
        
        prefs.setValue(paintballSpeedSlider.value, forKey: "paintballSpeed")
    }
}