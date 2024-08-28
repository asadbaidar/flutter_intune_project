//
//  CXIntuneMAMManager.swift
//  intune_plugin
//
//  Created by Faheem on 07/05/2024.
//

import Foundation
import IntuneMAMSwift

class CXIntuneMAMManager : NSObject {
    
    static let instance:CXIntuneMAMManager = CXIntuneMAMManager()
    
    private override init() {
        super.init()
    }
    
    var presentingViewController: UIViewController?
    
    func setupFromConfig() {
        IntuneMAMSettings.aadAuthorityUriOverride = "msalConfig.authority"
        IntuneMAMSettings.aadClientIdOverride = "msalConfig.client_id"
        IntuneMAMSettings.aadRedirectUriOverride = "msalConfig.redirect_uri"
    }
    
    func setupDelegate() {
        IntuneMAMEnrollmentManager.instance().delegate = self
        IntuneMAMPolicyManager.instance().delegate = self
        IntuneMAMComplianceManager.instance().delegate = self
    }
    
    func registerAndEnroll(email:String) {
        IntuneMAMEnrollmentManager.instance().registerAndEnrollAccount(email)
    }
    
    func deRegisterAndUnencrollAll() {
        for upn in IntuneMAMEnrollmentManager.instance().allowedAccounts()?.compactMap({ $0 as? String }) ?? [] {
            IntuneMAMEnrollmentManager.instance().deRegisterAndUnenrollAccount(upn, withWipe: true)
        }
    }
}

extension CXIntuneMAMManager: IntuneMAMEnrollmentDelegate {
    
    func enrollmentRequest(with status: IntuneMAMEnrollmentStatus) {
        //DRSingleton.loadingDismiss()
        if status.didSucceed{
            //If enrollment was successful, change from the current view (which should have been initialized with the class) to the desired page on the app (in this case ChatPage)
            print("[IntuneMAM] Login successful")
            
            // We cannot do navigation from this delegate method because this causes issues and sometimes return response very late, As per communicated with Microsoft on BNYM issue they asked to leave unenrollment case, and this one is enrollment case. I used it, but this is causing issue, Althought the code is written.
            // This will be observed in SigninCOntroller to do further navigation.
//            NotificationCenter.default.post(name: kNIntuneUserEnrolledORDeviceCompliant, object: nil, userInfo: nil)
            
        } else if (status.statusCode == .authRequired) {
            print("[IntuneMAM] Enrollment result for identity \(status.identity) with status code \(status.statusCode)")
            IntuneMAMEnrollmentManager.instance().loginAndEnrollAccount(status.identity)
        }
        else {
//            NCMessaging.alert(title: "Error",message: "Failed to enroll user in MAM, please try again later.", buttons: "OK")
            //In the case of a failure, log failure error status and code
            print("[IntuneMAM] Enrollment result for identity \(status.identity) with status code \(status.statusCode)")
            print("[IntuneMAM] Debug message: \(String(describing: status.errorString))")
        }
    }
    
    func policyRequest(with status: IntuneMAMEnrollmentStatus) {
        print("[IntuneMAM] Policy Request Status: \(status)")
    }
    
    func unenrollRequest(with status: IntuneMAMEnrollmentStatus) {
        //Go back to login page from current view controller
        // We cannot follow above commented instruction here because microsoft solution proposed us not to call deRegisterAndUnenrollAccount() method on logout and hence control will never come in this delegate.
        if status.didSucceed != true {
            //In the case unenrollment failed, log error
            print("[IntuneMAM] Unenrollment result for identity \(status.identity) with status code \(status.statusCode)")
            print("[IntuneMAM] Debug message: \(String(describing: status.errorString))")
        }
    }
}

extension CXIntuneMAMManager: IntuneMAMPolicyDelegate {
    
    /*
     wipeDataForAccount is called by the Intune SDK when the app needs to wipe all the data for a specified user
     With chatr, the only user data stored are the sent chat messages and drafted chat messages.
     If this is wiped successfully, return true, otherwise return false
     
     @param upn is the upn of the user whoes data is to be wiped (for example "user@example.com")
     */
    func wipeData(forAccount: String) -> Bool {
        //variable to track if the data wipe was successful
        var wipeSuccess = true
        
        //remove all files in each directory
        let fileManager: FileManager = FileManager.default
        let paths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        for fileDirectory in paths {
            do {
                let fileArray = try fileManager.contentsOfDirectory(atPath: fileDirectory)
                for fileName in fileArray {
                    let fileDirectoryURL = URL(fileURLWithPath: fileDirectory)
                    let fullPathURL = fileDirectoryURL.appendingPathComponent(fileName)
                    try fileManager.removeItem(atPath: fullPathURL.path)
                }
            } catch {
                print("[IntuneMAM] Could not successfully remove files from directory. Error: \(error)")
                wipeSuccess = false
            }
        }
        return wipeSuccess
    }
    
    /*
     In the case that the app needs to perform tasks like save user data before the Intune SDK restarts the app, those tasks can be done here
     With Chatr, drafted messages need to be saved if a restart is forced.
     
     If the app will handle restarting on its own, return true.
     If the app wants the Intune SDK to handle the restart, @return false.
     See IntuneMAMPolicyDelegate documentation or header file for more information
     */
    func restartApplication() -> Bool {
        return false
    }
}

extension CXIntuneMAMManager: IntuneMAMComplianceDelegate {
    
    func identity(_ identity: String, hasComplianceStatus status: IntuneMAMComplianceStatus, withErrorMessage errMsg: String, andErrorTitle errTitle: String) {
        
        OperationQueue.main.addOperation({
            
            if status == IntuneMAMComplianceStatus.compliant {
                print("IntuneMAMComplianceStatus \(status)")
                
            } else {
                
                if (status == IntuneMAMComplianceStatus.notCompliant) {
                    
                } else if (status == IntuneMAMComplianceStatus.serviceFailure) {
                    
                } else if (status == IntuneMAMComplianceStatus.networkFailure) {
                    
                } else if (status == IntuneMAMComplianceStatus.interactionRequired) {
                    
                }
            }
        })
    }
}

