 package com.cxai.intune_plugin

 import android.content.Context
 import android.util.Log
 import com.microsoft.intune.mam.client.app.MAMComponents
 import com.microsoft.intune.mam.client.notification.MAMNotificationReceiverRegistry
 import com.microsoft.intune.mam.policy.MAMComplianceManager
 import com.microsoft.intune.mam.policy.MAMEnrollmentManager
 import com.microsoft.intune.mam.policy.MAMServiceAuthenticationCallback
 import com.microsoft.intune.mam.policy.notification.MAMEnrollmentNotification
 import com.microsoft.intune.mam.policy.notification.MAMNotification
 import com.microsoft.intune.mam.policy.notification.MAMNotificationType

 object MAMHelper {
     private var enrollmentManager: MAMEnrollmentManager? = null
     private var complianceManager: MAMComplianceManager? = null
     private var notificationReceiver: MAMNotificationReceiverRegistry? = null

     init {
         enrollmentManager = MAMComponents.get(MAMEnrollmentManager::class.java)
         complianceManager = MAMComponents.get(MAMComplianceManager::class.java)
         notificationReceiver = MAMComponents.get(MAMNotificationReceiverRegistry::class.java)
     }

     /**
      * initialize the MAM service
      */
     fun initialize(context: Context) {
         // Registers a MAMAuthenticationCallback, which will try to acquire access tokens for MAM.
         // This is necessary for proper MAM integration.
         enrollmentManager?.registerAuthenticationCallback(AuthenticationCallback(context))

         /* This section shows how to register a MAMNotificationReceiver, so you can perform custom
          * actions based on MAM enrollment notifications.
          * More information is available here:
          * https://docs.microsoft.com/en-us/intune/app-sdk-android#types-of-notifications */
         notificationReceiver?.registerReceiver({ notification: MAMNotification? ->
             if (notification is MAMEnrollmentNotification) {
                 val result =
                     notification.enrollmentResult
                 when (result) {
                     MAMEnrollmentManager.Result.AUTHORIZATION_NEEDED,
                     MAMEnrollmentManager.Result.NOT_LICENSED,
                     MAMEnrollmentManager.Result.ENROLLMENT_SUCCEEDED,
                     MAMEnrollmentManager.Result.ENROLLMENT_FAILED,
                     MAMEnrollmentManager.Result.WRONG_USER,
                     MAMEnrollmentManager.Result.UNENROLLMENT_SUCCEEDED,
                     MAMEnrollmentManager.Result.UNENROLLMENT_FAILED,
                     MAMEnrollmentManager.Result.PENDING,
                     MAMEnrollmentManager.Result.COMPANY_PORTAL_REQUIRED -> Log.d(
                         "Enrollment Receiver",
                         result.name
                     )

                     else -> Log.d("Enrollment Receiver", result.name)
                 }
             } else {
                 Log.d("Enrollment Receiver", "Unexpected notification type received")
             }
             true
         }, MAMNotificationType.MAM_ENROLLMENT_RESULT)
         // Register for wipe user data notification
         notificationReceiver?.registerReceiver({ notification: MAMNotification ->
             val n = notification as MAMEnrollmentNotification
             Log.d("Enrollment Receiver", n.enrollmentResult.name)
             true
         }, MAMNotificationType.WIPE_USER_DATA)
     }

     /**
      * Register the account for MAM
      */
     fun registerCompliance(upn: String, aadid: String, tenantId: String, authorityURL: String) {
         enrollmentManager?.registerAccountForMAM(upn, aadid, tenantId, authorityURL)
     }

     /**
      * Remediate the compliance
      */
     fun remediateCompliance(upn: String, aaid: String, tenantId: String, authorityURL: String) {
         complianceManager?.remediateCompliance(upn, aaid, tenantId, authorityURL, true)
     }
 }

 /**
  * Implementation of the required callback for MAM integration.
  */
 class AuthenticationCallback(context: Context) : MAMServiceAuthenticationCallback {
     private val mContext: Context

     init {
         mContext = context.applicationContext
     }

     override fun acquireToken(
         upn: String,
         aadId: String,
         resourceId: String,
     ): String? {
         return try {
             // Create the MSAL scopes by using the default scope of the passed in resource id.
             // val scopes = arrayOf("$resourceId/.default")
             //acquireTokenSilentSync(aadId, scopes)

             Log.d("Auth", "Get token for MAM Service")
             null
         } catch (e: InterruptedException) {
             Log.d("Auth", "Failed to get token for MAM Service", e)
             null
         }
     }
 }

