import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var psswrdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        loginButton.layer.backgroundColor = UIColor.lightGray.cgColor
        
        registerButton.layer.cornerRadius = 10
        registerButton.layer.backgroundColor = UIColor.lightGray.cgColor
        
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        emailLabel.text = ""
        psswrdLabel.text = ""
        
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
            if user != nil
            {
                print("User has signed in")
                self.performSegue(withIdentifier: "loginToApp", sender: self)
            }
            if error != nil
            {
                if let error = error as NSError?
                {
                    guard let errors = AuthErrorCode(rawValue: error.code) else
                    {
                        return
                    }
                    
                    switch errors
                    {
                    case .invalidEmail:
                        self.emailLabel.text = "invalid email"
                    case .userDisabled:
                        self.emailLabel.text = "user is disabled please contact support"
                    case .userNotFound:
                        self.emailLabel.text = "email does not exist"
                    case .wrongPassword:
                        if self.psswrdLabel.text == ""
                        {
                            self.psswrdLabel.text = "please fill in email field"
                        }
                        else
                        {
                            self.psswrdLabel.text = "wrong password"
                        }
                    default:
                        print("Error Signing up")
                    }
                }
                
                if self.emailLabel.text == ""
                {
                    self.emailLabel.text = "please fill in email field"
                }
            }
        }
    }
    

}
