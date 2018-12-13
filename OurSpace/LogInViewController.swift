import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var psswrdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 25
        email.layer.cornerRadius = 25
        password.layer.cornerRadius = 25
        
        registerButton.layer.cornerRadius = 25

        
        email.delegate = self
        password.delegate = self
    }
    
    // Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        emailLabel.text = ""
        psswrdLabel.text = ""
        
        if self.email.text == ""
        {
            self.emailLabel.text = "Please fill in e-mail field."
        }
        
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
                            self.emailLabel.text = "Invalid e-mail."
                        case .userDisabled:
                            self.emailLabel.text = "User is disabled please contact support."
                        case .userNotFound:
                            self.emailLabel.text = "E-mail does not exist."
                        case .wrongPassword:
                            if self.password.text == ""
                            {
                                self.psswrdLabel.text = "Please fill in password field."
                            }
                            else
                            {
                                self.psswrdLabel.text = "Wrong Password."
                            }
                        default:
                            print("Error Signing Up.")
                    }
                }
                
            }
        }
    }
    
    // UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
}
