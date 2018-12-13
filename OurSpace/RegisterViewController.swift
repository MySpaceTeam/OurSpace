import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var confirmEmailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    @IBOutlet weak var unmatchEmail: UILabel!
    @IBOutlet weak var unmatchPsswrd: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 25
        
        
        emailText.delegate = self
        confirmEmailText.delegate = self
        passwordText.delegate = self
        confirmPasswordText.delegate = self
        
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        unmatchEmail.text = ""
        unmatchPsswrd.text = ""
        
        if self.emailText.text != self.confirmEmailText.text
        {
            self.unmatchEmail.text = "E-mail does not match."
        }
        if self.passwordText.text != self.confirmPasswordText.text
        {
            self.unmatchPsswrd.text = "Password does not match."
        }
        if self.confirmEmailText.text == "" || self.emailText.text == ""
        {
            self.unmatchEmail.text = "Please fill in e-mail fields."
        }
        
        if
            self.emailText.text! == self.confirmEmailText.text! &&
            self.passwordText.text! == self.confirmPasswordText.text!
        {
            Auth.auth().createUser(withEmail: self.emailText.text!, password: self.passwordText.text!) { (authResult, error) in
                if authResult != nil
                {
                    print("User has signed up")
                    self.unmatchEmail.text = ""
                    self.unmatchPsswrd.text = ""
                    self.performSegue(withIdentifier: "registeredtologin", sender: self)
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
                                self.unmatchEmail.text = "Invalid e-mail."
                            case .emailAlreadyInUse:
                                self.unmatchEmail.text = "E-mail is already in use."
                            case .weakPassword:
                                if  self.confirmPasswordText.text == "" || self.passwordText.text == ""
                                {
                                    self.unmatchPsswrd.text = "Please fill in password fields."
                                }
                                else
                                {
                                    self.unmatchPsswrd.text = "Weak Password."
                                }
                            default:
                                print("Error Signing Up.")
                        }
                    }
                }
                guard let user = authResult?.user else {return}
            }
        }
    }
    
    // UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailText.resignFirstResponder()
        confirmEmailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        confirmPasswordText.resignFirstResponder()
        return true
    }
}
