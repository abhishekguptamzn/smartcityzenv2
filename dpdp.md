# DPDP Act Compliance Business Objective

## Purpose & Strategic Context

The purpose of this document is to establish a comprehensive, non-technical business compliance and operational privacy strategy for the **Smart Cityzen** mobile application under the **Digital Personal Data Protection Act, 2023 (DPDP Act) of India**, together with applicable statutory rules and administrative guidelines.

Smart Cityzen functions as a digital civic gateway and venue companion, enabling citizens to discover, reserve, pay for, and physically access municipal and private lifestyle venues (such as sports complexes, badminton courts, swimming pools, fitness centers, community libraries, and coaching batches) using contactless QR codes, Bluetooth Low Energy (BLE) presence verification, and on-device biometrics.

Because the application collects citizen identifiers, contact details, precise location data, attendance logs, and payment records—and handles physical access to community spaces that may be utilized by families and minors—the business must establish robust privacy governance. DPDP compliance is not treated here as a mere software development checkbox; it is an organizational commitment to transparency, citizen trust, lawful processing, and institutional accountability.

---

## Strategic Objectives

### 1. Business Objective
* Enable seamless civic participation and physical facility access while establishing clear legal bases for all personal data processing.
* Protect the organization, its directors, and municipal partners against statutory non-compliance penalties (which can reach up to ₹250 Crores under the DPDP Act for significant failures such as security safeguards failure or non-compliance regarding children's data).
* Foster strong operational relationships with participating municipal corporations, sports facility operators, and commercial partners through standardized data governance agreements.

### 2. Privacy Objective
* Embed privacy by design across the citizen lifecycle, from initial download and onboarding to facility check-in, payment, and account closure.
* Adhere to the core privacy principles of notice, affirmative consent, purpose limitation, data minimisation, accuracy, storage limitation, and confidential processing.
* Guarantee that sensitive citizen attributes (e.g., precise GPS coordinates, attendance timestamps, and demographic details) are processed strictly for verified service delivery and never monetized or repurposed without authorization.

### 3. User-Trust Objective
* Foster citizen confidence through complete transparency regarding what data is collected, why it is necessary, who operates the facilities, and how records are safeguarded.
* Eliminate deceptive patterns, pre-ticked checkboxes, buried legalese, and forced consents.
* Empower citizens with direct, user-friendly controls to view their personal data, correct inaccuracies, withdraw consents, request erasure, and resolve grievances through responsive human channels.

### 4. Compliance Objective
* Align end-to-end mobile processing, backend APIs, third-party vendor integrations, and physical venue operations with the substantive provisions of the DPDP Act, 2023.
* Establish defensible audit trails, consent logs, vendor Data Processing Agreements (DPAs), and documented incident response procedures capable of regulatory presentation before the Data Protection Board of India (DPBI).

---

## Scope, Assumptions & Limitations

### Scope
* **Primary Scope:** The **Smart Cityzen** client application (Android and multi-platform Flutter builds), associated client-side data storage, device permissions (Location, Bluetooth, Camera, Notifications, Biometrics), and direct data exchanges with the backend API and third-party software development kits (SDKs).
* **Operational Scope:** Citizen-facing data lifecycles, customer support tickets, grievance handling mechanisms, and administrative interfaces governing citizen records.

### Assumptions
1. **Jurisdiction & Territorial Scope:** The application is operated primarily for citizens, residents, and visitors within India, processing digital personal data within the territory of India under Section 3 of the DPDP Act.
2. **Role Determination:** The operating entity of Smart Cityzen acts primarily as a **Data Fiduciary** (determining the purpose and means of citizen registration, profile management, and account administration) and in certain municipal contexts may act as a Joint Data Fiduciary or Data Processor in coordination with municipal corporations or private venue licensees.
3. **Regulatory Evolution:** The operational measures outlined herein reflect the statutory text of the DPDP Act, 2023. As the Central Government issues official rules, notifications, and exemptions, specific thresholds and timelines must be periodically re-validated.

### Limitations
* **Non-Legal Advisory:** This document constitutes a business planning, risk assessment, and operational strategy framework. It does not constitute formal legal advice, a judicial interpretation, or a certified compliance audit.
* **Backend Architecture Boundary:** While this document incorporates observed API endpoints interacting with the mobile client, backend database configurations, server infrastructure security, and physical venue turnstile hardware require parallel technical assessments.

---

# 1. Executive Summary

## Current Privacy & Compliance Posture

Based on an exhaustive review of the Smart Cityzen Flutter mobile repository, device permissions, configuration manifests, and user interface flows:

1. **Absence of Statutory Notice & Consent on Registration:**
   * *Observed:* The user registration screen (`login_register_screen.dart`) captures Full Name, Email Address, Mobile Phone Number, City, and Password without displaying a Privacy Notice, without linking to Terms of Service, and without requiring any affirmative action (such as an unchecked consent checkbox).
   * *Risk:* Severe statutory non-compliance under Sections 5 and 6 of the DPDP Act, which require that an itemized notice accompany or precede any request for consent.
2. **Placeholder Privacy Notice in App Settings:**
   * *Observed:* The in-app Privacy Policy (`settings_screen.dart`) consists of a 3-bullet modal dialog referencing the "Municipal Digital Governance Act" (a fictional or non-statutory title) rather than the DPDP Act, 2023. It lacks mandatory disclosures regarding data categories, processing purposes, user rights, retention schedules, third-party processors, and Grievance Officer contact details.
3. **Unregulated Third-Party SDK Integrations:**
   * *Observed:* The application bundles Google Sign-In, Firebase Cloud Messaging (FCM), Google Fonts, and the Facebook / Meta Login SDK (configured in `AndroidManifest.xml` with active Application ID and Client Token).
   * *Risk:* Third-party SDKs can automatically transmit device identifiers, network parameters, and interaction metrics to overseas servers without documented business justifications, vendor agreements, or explicit citizen notice.
4. **Absence of User Rights & Account Deletion Mechanisms:**
   * *Observed:* Citizens can update profile fields and delete individual notifications, but there is no workflow or interface within the mobile application allowing a citizen to request an account deletion, data erasure, summary of processing, or withdrawal of consent.
5. **Vulnerability Surrounding Children's Personal Data:**
   * *Observed:* The application facilitates bookings for sports coaching, swimming lessons, and community libraries—activities heavily utilized by minors. However, there is no age-verification mechanism or parental consent workflow in place, creating immediate regulatory exposure under Section 9 of the DPDP Act.
6. **Positive Privacy Architecture in Biometric Authentication:**
   * *Observed:* Biometric verification (`local_auth`) is executed strictly on-device via Android BiometricPrompt and iOS LocalAuthentication. Raw biometric fingerprints and facial templates are never transmitted to backend servers or stored in plaintext; only salted cryptographic hashes for PINs are retained in secure storage.

---

## Major Business Risks

```
+----------------------------------------------------------------------------------------------------+
|                                     KEY BUSINESS & PRIVACY RISKS                                   |
+-----------------------------+---------------------------------------+------------------------------+
| Risk Category               | Root Cause                            | Potential Business Impact    |
+-----------------------------+---------------------------------------+------------------------------+
| Regulatory Enforcement      | Lack of compliant notice & consent on | Statutory penalties from the |
| & Financial Liability       | onboarding; unverified minor data     | DPBI up to ₹250 Crores       |
+-----------------------------+---------------------------------------+------------------------------+
| Operational & Legal         | Missing vendor Data Processing        | Joint liability for third-   |
| Exposure                    | Agreements (DPAs) with Meta/Google    | party data misuse/transfers  |
+-----------------------------+---------------------------------------+------------------------------+
| Citizen Trust & Reputational| Opaque location and physical tracking | Citizen backlash; loss of    |
| Damage                      | without granular controls             | municipal service contracts  |
+-----------------------------+---------------------------------------+------------------------------+
| App Store Non-Compliance    | Missing in-app account deletion       | Rejection or removal from    |
|                             | mechanism                             | Google Play / Apple App Store|
+-----------------------------+---------------------------------------+------------------------------+
```

---

## Highest-Priority Actions

1. **Deploy DPDP-Compliant Notice & Consent at Registration:** Implement an itemized, clear notice and unbundled affirmative consent mechanism before capturing citizen credentials.
2. **Implement Account Deletion & Right to Erasure:** Establish an in-app "Delete Account & Data" workflow integrated with backend retention and verification processes.
3. **Conduct Vendor Governance & DPA Review:** Audit the business necessity of the Meta/Facebook SDK and execute DPAs with all third-party service providers (Google, Firebase, Payment Gateways).
4. **Establish Children's Privacy Safeguards:** Assess age demographics across facility types and deploy parental consent mechanisms where services target or enroll individuals under 18.
5. **Appoint Grievance Officer & Publish Contact Information:** Establish an internal grievance redressal mechanism and publish the officer's name, email, and postal address within the app.

---

# 2. Application & Business Context

## Application Overview
Smart Cityzen is designed as a **Universal Digital Passport & Civic Venue Companion**. It bridges citizen mobile devices with municipal infrastructure, private fitness studios, sports arenas, and quiet workspaces.

### Primary User Journeys
1. **Onboarding & Authentication:** Citizens register via email, phone, city selection, or social providers (Google, Facebook) and configure optional on-device app locks.
2. **Facility Discovery & Availability:** Citizens browse nearby sports complexes, gyms, and libraries, review live occupancy meters ("Crowd Meter"), and view amenities.
3. **Pass Purchasing & Subscriptions:** Citizens purchase hourly court slots, multi-day visitor passes, fitness memberships, and coaching batch enrollments.
4. **Contactless Facility Access:** Citizens scan venue QR codes and leverage Bluetooth Low Energy (BLE) proximity detection combined with on-device biometrics to gain turnstile entry.
5. **Citizen Support:** Users report facility issues, seek helpdesk assistance, and monitor operational service tickets.

### Intended Users
* Adult citizens, residents, and visitors booking leisure, athletic, or workspace facilities.
* Parents and legal guardians enrolling family members in coaching academies.
* Youth and student visitors accessing public libraries and municipal sports centers.
* Facility administrators and front-desk personnel managing access logs and fee plans.

### Key Business Purposes for Processing
* **Service Delivery:** Providing valid digital tickets, managing active subscriptions, and validating physical entry.
* **Facility Safety & Capacity:** Monitoring real-time venue crowding to maintain health, safety, and fire-code occupancy limits.
* **Fraud Prevention:** Preventing pass sharing, unauthorized turnstile cloning, and fee evasion through synchronized TOTP/HMAC nonces and presence verification.
* **Financial Accounting:** Generating valid invoices, processing digital payments, and maintaining statutory audit trails.

---

# 3. Personal Data Inventory

The following inventory categorizes all personal data fields identified within the Smart Cityzen Flutter client application, APIs, and manifests.

| Data Category | Observed Information | Why It Is Collected | Where / When Collected | Business Purpose | Third-Party Sharing | Retention Consideration | Status | Action Required |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Direct Identifiers** | Full Name, Email Address, Mobile Phone Number | Establish unique identity, prevent fraudulent duplicate accounts, send transaction alerts | Registration form, Profile screen, Social Login | Account identification, ticket verification, transactional messaging | Shared with SMS gateways, Email services, and Facility Operators | Retain for active account lifecycle plus statutory limitation period | **Observed** | Add explicit consent; define verified retention schedule |
| **Demographic & Profile Data** | Date of Birth (DOB), Gender | Age verification for age-restricted facilities (gyms, pools); demographic planning | Optional Profile Update screen (`users_api.dart`) | Eligibility assessment, municipal sports planning | Stored on core API backend; not shared with advertisers | Retain during active membership | **Observed** | Evaluate whether DOB is strictly necessary; introduce age gating |
| **Address & Spatial Data** | City, Locality, Full Address, Pincode, Landmark | Map citizens to jurisdiction; assist in local venue routing | Registration (City), Edit Profile (Full address) | Service localization, municipal zoning, address verification | API backend; municipal dashboards | Retain during account lifecycle | **Observed** | Mark residential address strictly optional; state purpose clearly |
| **Professional & Interest Data** | Profession, Company, Experience, Education, Skills, Languages, Hobbies, Bio | Citizen community networking, interest-based event recommendations | Edit Profile screen (`users_api.dart`) | Community matching, co-working club networking | Visible to other citizens based on profile visibility setting | Retain until edited or deleted by citizen | **Observed** | Ensure profile visibility defaults to "Private"; obtain unbundled consent |
| **Precise Geolocation** | Real-time GPS Latitude & Longitude coordinates | Locate closest sports complexes and public libraries | Home screen search, Venue finder (`location_service.dart`) | Distance calculation ("450 m away"), venue navigation | Processed on-device; coordinates may be sent in search API | Ephemeral (do not retain historical GPS breadcrumbs) | **Observed** | Clarify in notice that location is used ephemerally for distance calculation |
| **Physical Access & Proximity** | Bluetooth BLE advertisement/scan nonces, QR scan timestamps | Verify physical presence at turnstile; generate dynamic time-synced entrance codes | Facility check-in screen (`qr_checkin_screen.dart`, `ble_presence_helper.dart`) | Fraud prevention, gate access control, crowd management | Check-in logs stored on backend; shared with Facility Operator | Retain during active membership & pass validity; delete upon user account erasure request | **Observed** | Connect check-in records to user account erasure pipeline |
| **Biometric Authentication** | Fingerprint and FaceID sensor prompts, biometric success tokens | Fast, frictionless local authentication for pass unlocking | Gate entry, App lock screen (`local_auth_service.dart`) | Prevent unauthorized device use and pass theft | **None.** Sensor data remains exclusively within device Secure Enclave / Keystore | No raw biometric data retained by business | **Observed** | Clarify in Privacy Notice that raw biometrics are never collected or stored |
| **Photographic Media** | Profile Avatar, Facility review images, Support ticket attachments | Visual identity verification at facility desk; evidence of facility defects | Camera / Gallery image picker (`image_picker`) | Desk pass verification, facility maintenance reporting | Stored on media server / S3 bucket; visible to venue staff | Retain profile photo during account lifecycle; tickets for 1 year | **Observed** | Provide instant photo deletion button in UI; restrict employee access |
| **Device & Network Identifiers** | FCM Push Token, Device Platform (Android/iOS), Device Name | Dispatch urgent push notifications, booking confirmations, security alerts | App initialization, FCM registration (`notifications_api.dart`) | Push notification routing, device session management | Google Firebase (FCM servers) | Retain while device is linked to account; clear on logout | **Observed** | Review Firebase Data Processing Terms; provide notification toggles |
| **Financial & Transactional Records** | Order ID, Amount, Payment Status (Paid, Pending, Failed, Refunded), Invoices | Process facility bookings, subscriptions, issue GST receipts | Payments screen, Receipt viewer (`payments_screen.dart`) | Billing, refund processing, statutory tax compliance | Shared with Payment Aggregator / Bank | Statutory retention required (typically 7–8 years under tax laws) | **Observed** | Separate financial records from marketing data; isolate upon account deletion |
| **Third-Party Social Tokens** | Google ID Token, Facebook Access Token, Provider User ID | Fast social sign-in without password entry | Login screen (`auth_api.dart`, `google_sign_in`, `flutter_facebook_auth`) | Federated user authentication | Google LLC, Meta Platforms Inc. | Token cached securely; provider ID stored in user profile | **Observed** | Re-evaluate necessity of Facebook Login; document token lifecycle |

---

# 4. DPDP Principles & Business Objectives

```
+----------------------------------------------------------------------------------------------------+
|                                    DPDP ACT CORE PRINCIPLES FRAMEWORK                              |
|                                                                                                    |
|  [ Notice & Transparency ] ---> [ Affirmative Consent ] ---> [ Purpose Limitation ]                |
|               |                                                     |                              |
|               v                                                     v                              |
|  [ Data Minimisation ]     ---> [ Accuracy & Security ] ---> [ Storage Limitation & Erasure ]      |
+----------------------------------------------------------------------------------------------------+
```

---

## 1. Lawful Processing

### Objective
Ensure every processing activity concerning citizen personal data is grounded in a recognized legal basis under the DPDP Act, primarily explicit affirmative consent, or documented legitimate uses where recognized by statute.

### Why
Processing personal data without a lawful basis exposes the business to regulatory penalties, invalidates service agreements, and erodes civic trust.

### Current Position
The application currently collects personal data upon app installation and registration without capturing an affirmative consent transaction or referencing a formal statutory basis.

### Gap
Absence of recorded consent artifacts and unverified processing grounds for secondary data fields (e.g., career, education, and hobbies).

### Business Action
Implement clear, unbundled consent checkboxes on registration and profile creation; classify core operational data versus optional profiling data.

### Evidence
Timestamped digital consent logs linking user ID, notice version, timestamp, and IP/device metadata.

---

## 2. Notice & Transparency

### Objective
Present every citizen with an itemized, plain-language notice prior to or at the time of collecting their personal data, available in English and constitutional languages (starting with Hindi).

### Why
Section 5 of the DPDP Act mandates that notice must clearly describe the data collected, the specific purpose, the manner of exercising user rights, and grievance redressal contact information.

### Current Position
A brief 3-sentence modal exists inside app settings referencing the non-existent "Municipal Digital Governance Act."

### Gap
Notice does not accompany registration; fails to list data categories, third-party disclosures, retention norms, user rights, or Grievance Officer details.

### Business Action
Draft and publish a comprehensive, layered Privacy Notice in the Flutter app accessible prior to registration, inside account settings, and on the public website.

### Evidence
Published, version-controlled Privacy Notice documents with documented translation approvals.

---

## 3. Affirmative Consent

### Objective
Obtain consent that is free, specific, informed, unconditional, and unambiguous, signified by a clear affirmative action (e.g., an unticked checkbox).

### Why
Section 6 of the DPDP Act invalidates bundled or forced consent. Consent cannot be made a prerequisite for accessing services beyond what is strictly necessary for that service.

### Current Position
The registration button ("Create Identity") submits data immediately without any consent checkbox or acknowledgment of terms.

### Gap
Risk of all collected registration data being deemed unlawfully collected under statutory review.

### Business Action
Introduce an active, unticked checkbox: *"I have read the Privacy Notice and consent to the processing of my personal data for civic venue access."* Keep marketing, social networking, and coaching communications separately consentable.

### Evidence
Database records storing `consent_timestamp`, `consent_version`, `consent_ip`, and `consent_scope`.

---

## 4. Purpose Limitation

### Objective
Process personal data exclusively for the explicit purposes disclosed to and approved by the citizen at the time of collection.

### Why
Section 6(1) provides that personal data shall be processed solely for the purpose for which consent was given. Repurposing data (e.g., using check-in records for municipal commercial marketing) violates the Act.

### Current Position
The app collects extensive demographic and professional profile data (education, skills, company) whose intended purpose is not communicated.

### Gap
Lack of documented firewalls preventing profile and attendance logs from being repurposed for commercial analytics or advertising.

### Business Action
Define strict data silos: check-in records are used solely for gate access and facility safety; demographic data is used solely for opt-in community features.

### Evidence
Approved Internal Data Governance Policy specifying permitted processing scopes per data category.

---

## 5. Data Minimisation

### Objective
Collect and retain only the minimal personal data strictly necessary to achieve the declared operational purpose.

### Why
Excessive data collection inflates breach impact, increases storage overhead, and violates statutory minimisation principles.

### Current Position
The profile update screen allows collection of 15+ secondary attributes (education, company, skills, hobbies, landmark) for a simple venue booking application.

### Gap
No business justification documented for requiring professional and career attributes in a civic sports/library companion app.

### Business Action
Review secondary profile attributes with product teams. Mark all non-essential fields as explicitly optional or eliminate unused fields entirely.

### Evidence
Documented Personal Data Minimisation Assessment approved by Product and Legal owners.

---

## 6. Accuracy Where Applicable

### Objective
Ensure citizen personal data is accurate, complete, and up to date, particularly where it influences booking eligibility or facility entry.

### Why
Section 8(3) mandates reasonable efforts to ensure data accuracy if data is used to make decisions affecting the citizen or shared with other entities.

### Current Position
Citizens can freely edit their profile details via the `EditProfileScreen`.

### Gap
Phone numbers and email addresses can be entered without mandatory OTP or link verification during initial registration.

### Business Action
Introduce phone number OTP verification to ensure accurate citizen records and prevent account spoofing.

### Evidence
Verification status flags in citizen database (`phone_verified_at`, `email_verified_at`).

---

## 7. Security Safeguards

### Objective
Implement reasonable organizational, technical, and administrative security safeguards to prevent personal data breaches.

### Why
Section 8(5) imposes a positive duty on Data Fiduciaries to protect personal data; failures carry penalties up to ₹250 Crores.

### Current Position
App enforces HTTPS/TLS for Dio network calls, stores session tokens in `flutter_secure_storage`, hashes local PINs with cryptographic salt, and keeps biometrics on-device.

### Gap
Logging of sensitive network calls in development environments; absence of formal automated vulnerability management and regular third-party penetration testing.

### Business Action
Enforce API certificate pinning, disable verbose Dio logger in production releases, and conduct quarterly penetration testing across mobile and backend APIs.

### Evidence
Third-party vulnerability assessment and penetration testing (VAPT) certification reports.

---

## 8. Retention & Deletion

### Objective
Retain personal data only as long as necessary to satisfy the specified business purpose, and irreversibly delete or anonymize data once that purpose is exhausted or consent is withdrawn.

### Why
Section 8(7) requires erasing personal data when the purpose is no longer served or upon citizen withdrawal of consent.

### Current Position
No automated retention schedules exist. User data and check-in logs remain in database tables indefinitely.

### Gap
Lack of a citizen-facing account deletion interface and data erasure workflow.

### Business Action
Build a self-service account and data deletion feature ensuring all attendance/BLE check-in logs and personal profile data are permanently erased upon user request.

### Evidence
User deletion confirmation records and documented Deletion Runbooks.

---

## 9. User Rights

### Objective
Provide functional mechanisms allowing citizens to exercise their rights to access summary information, correct inaccuracies, erase personal data, and nominate representatives.

### Why
Sections 11 through 14 establish enforceable rights for Data Principals that must be addressed within reasonable operational timeframes.

### Current Position
Users can edit select profile attributes, but cannot download their data summary, request complete erasure, or appoint nominees.

### Gap
Absence of a documented operational process or self-service interface for handling data subject access and erasure requests.

### Business Action
Create an in-app "Privacy & Data Rights" hub allowing citizens to request their data export and initiate account erasure.

### Evidence
Audited logs of submitted, processed, and fulfilled user-rights tickets.

---

## 10. Withdrawal of Consent

### Objective
Make withdrawing consent as easy and accessible as giving consent.

### Why
Section 6(4) guarantees the citizen the right to withdraw consent at any time, with the same ease of execution.

### Current Position
Once registered, there is no option within the app interface for a citizen to revoke consent without contacting support manually.

### Gap
Non-compliance with statutory requirement for comparable ease of withdrawal.

### Business Action
Provide clear consent toggle switches in app settings for optional processing activities (marketing alerts, community profile visibility, analytics).

### Evidence
System records logging consent revocation timestamps and automated downstream processing suspensions.

---

## 11. Grievance Redressal

### Objective
Establish a prompt, accessible, and effective mechanism for citizens to raise privacy inquiries and complaints.

### Why
Section 8(10) requires Data Fiduciaries to establish effective grievance redressal mechanisms; citizens must exhaust this remedy before escalating to the Board.

### Current Position
App features a general "Support Tickets" module (`support_tickets_screen.dart`), but has no designated Privacy or Grievance Officer channel.

### Gap
Privacy complaints are mixed with facility maintenance tickets (e.g., broken badminton nets), risking regulatory non-compliance.

### Business Action
Designate an official Grievance Officer; publish contact details in the Privacy Notice; add a dedicated "Privacy Grievance" category in the support ticket module.

### Evidence
Published Grievance Officer contact details and dedicated Privacy Grievance Ticket Register.

---

## 12. Vendor & Processor Management

### Objective
Engage data processors only under valid, legally binding Data Processing Agreements (DPAs) that enforce strict confidentiality and security.

### Why
Section 8(2) states that a Data Fiduciary remains accountable for processing carried out on its behalf by any Data Processor.

### Current Position
App embeds SDKs from Google and Meta (Facebook) and connects to third-party SMS/cloud services without documented privacy assessments.

### Gap
Absence of executed DPAs, audit rights, and subprocessors registries for third-party tools.

### Business Action
Execute DPAs with cloud hosts, payment gateways, and Firebase; conduct legal review on removing the Facebook SDK.

### Evidence
Executed DPA repository and annual vendor compliance audit certifications.

---

## 13. Children's Data Protection

### Objective
Protect minors (under 18 years) by obtaining verifiable parental consent and refraining from behavioral tracking or targeted advertising.

### Why
Section 9 mandates verifiable consent from parents/lawful guardians before processing minor data and explicitly prohibits tracking or behavioral monitoring.

### Current Position
App allows bookings for swimming pools, sports academies, and libraries without age verification or parental consent workflows.

### Gap
Direct statutory liability if minors register accounts or if their attendance patterns are tracked without parental verification.

### Business Action
Establish an age confirmation step during onboarding; build a parental delegation workflow for family bookings; disable all analytics and profiling on minor accounts.

### Evidence
Documented Minor Data Handling Policy and verifiable parental consent records.

---

## 14. Cross-Border Data Transfers

### Objective
Ensure all citizen personal data transfers outside India comply with Central Government rules and negative list notifications.

### Why
Section 16 permits cross-border transfers subject to restrictions or blacklists notified by the Central Government.

### Current Position
Google Firebase and Meta SDKs may transmit telemetry, crash reports, and device identifiers to overseas servers (e.g., in the US or EU).

### Gap
Unmapped international data flows and lack of citizen notice regarding offshore server locations.

### Business Action
Conduct a comprehensive data flow mapping exercise; configure cloud storage and databases in Indian regions (e.g., Mumbai / Pune).

### Evidence
Data Transfer Impact Assessment and Cloud Hosting Regional Configuration Statements.

---

## 15. Accountability & Governance

### Objective
Maintain documented internal governance frameworks, role hierarchies, and verifiable records demonstrating end-to-end DPDP compliance.

### Why
Demonstrating accountability is critical during any regulatory inquiry or data protection audit by the Data Protection Board of India.

### Current Position
Ad-hoc privacy practices managed primarily at the engineering level.

### Gap
No formal Privacy Governance Charter, designated ownership matrix, or periodic audit schedule.

### Business Action
Form an internal Privacy Steering Committee comprising Product, Legal, Engineering, and Operations leadership.

### Evidence
Minutes of quarterly Privacy Steering Committee reviews and Board of Directors compliance filings.

---

# 5. Consent Management Objective

```
+----------------------------------------------------------------------------------------------------+
|                                    CONSENT ARCHITECTURE & LIFECYCLE                                |
|                                                                                                    |
|    [ User Action ]                                                                                 |
|           |                                                                                        |
|           v                                                                                        |
|    +-----------------------------+                                                                 |
|    | Itemized Pre-Consent Notice |  ---> Discloses categories, purposes, rights, grievance info    |
|    +-----------------------------+                                                                 |
|           |                                                                                        |
|           +---> Core Service Consent (Unticked Checkbox: Venue Access & Ticketing)                 |
|           |                                                                                        |
|           +---> Optional Consent A (Unbundled: Community Profile Visibility)                       |
|           |                                                                                        |
|           +---> Optional Consent B (Unbundled: Marketing & Promotional Alerts)                     |
|           |                                                                                        |
|           v                                                                                        |
|    +-----------------------------+                                                                 |
|    | Tamper-Resistant Consent Log|  ---> Stores User ID, Version, Timestamp, IP, Scope             |
|    +-----------------------------+                                                                 |
|           |                                                                                        |
|           v                                                                                        |
|    +-----------------------------+                                                                 |
|    | Real-Time Consent Management|  ---> Citizen can toggle/revoke permissions via App Settings    |
|    +-----------------------------+                                                                 |
+----------------------------------------------------------------------------------------------------+
```

## When Consent Is Required
* Prior to completing initial user registration.
* Prior to activating optional public community profiles.
* Prior to accessing hardware device sensors (Camera, Location, Bluetooth) via OS runtime dialogues accompanied by in-app contextual prompts.
* Prior to sending promotional campaigns or partner discounts.

## Criteria for Meaningful Consent
Under Section 6, consent is legally valid only if it satisfies five statutory tests:
1. **Free:** Not coerced; venue booking cannot be denied if a citizen refuses optional marketing communications.
2. **Specific:** Tied to a single, well-defined operational purpose rather than blanket authorizations.
3. **Informed:** The citizen understands exactly what data is collected, who processes it, and why.
4. **Unconditional:** The service contract cannot be contingent on consenting to non-essential data processing.
5. **Unambiguous Affirmative Action:** Implemented via an active, unticked toggle or checkbox. Silence, inaction, pre-ticked boxes, or simply proceeding to use the app do not constitute legal consent.

## Unbundling of Purposes
The application must present discrete, unbundled consent options rather than a single combined agreement:
* **Core Civic Service Consent (Mandatory for service):** Identity creation, pass issuance, check-in verification, and billing.
* **Community Networking Consent (Optional):** Making user skills, hobbies, and profession discoverable by other members.
* **Promotional Communications (Optional):** Venue discounts, off-peak offers, and municipal lifestyle newsletters.

## Consent Withdrawal Workflow
* Citizens must be able to withdraw consent at any time via a dedicated "Privacy & Consent Settings" screen.
* Withdrawing consent for optional features (e.g., marketing or profile visibility) must take effect immediately without disrupting facility access.
* Withdrawing consent for core account processing triggers a clear warning that active passes and account access will be terminated, followed by an account closure and data deletion flow.

## Records to Maintain
For every consent event, the business must record:
* Unique Data Principal Identifier.
* Exact version of the Privacy Notice displayed.
* Timestamp of consent grant or withdrawal.
* Mechanism of consent (e.g., Mobile App UI, web portal).
* Scope of consent granted (core, community, marketing).

---

# 6. Privacy Notice Objective

## Business Requirement & Rationale
Under Section 5 of the DPDP Act, a Data Fiduciary must provide a clear, standalone Privacy Notice before or at the time of requesting personal data. The notice must be written in simple, non-technical language and made available in English as well as languages listed in the Eighth Schedule to the Constitution of India (with Hindi being an immediate priority for North and Central Indian municipal deployments).

## Mandatory Disclosures to Citizens
The Privacy Notice within Smart Cityzen must clearly explain:
1. **Categories of Personal Data Collected:** Direct identifiers, contact information, location coordinates, check-in timestamps, photos, and payment metadata.
2. **Specific Purposes of Processing:** Explaining why each category is needed (e.g., "Location is used solely to show you nearby badminton courts and is not stored as a historical tracking log").
3. **Manner of Exercising User Rights:** Concrete instructions on how citizens can access, correct, or erase their data through the mobile app.
4. **Grievance Redressal Process:** Name, official title, email address, and physical mailing address of the Grievance Officer, along with expected resolution timeframes.
5. **Right to Complain to the DPBI:** Clear notification that citizens have the statutory right to escalate unresolved grievances to the Data Protection Board of India.
6. **Third-Party Disclosures:** Plain disclosure of cloud hosting providers, payment processors, push notification vendors, and municipal facility operators who process data.
7. **Retention & Deletion Commitments:** Specific timelines for data retention and events triggering automatic erasure.

## Accessibility & Presentation
* **Point-of-Collection Access:** A prominent link to the Privacy Notice must be displayed on the registration screen above the submission button.
* **Persistent In-App Availability:** Accessible anytime from the application Drawer/Sidebar and Account Settings menu.
* **Multilingual Toggle:** Seamless language switching (English / Hindi) directly within the notice interface.

---

# 7. User Rights & User Control

```
+----------------------------------------------------------------------------------------------------+
|                                    CITIZEN PRIVACY RIGHTS FRAMEWORK                                |
+-----------------------+---------------------------------------+-------------------+----------------+
| Statutory Right       | Citizen Capability                    | Internal SLA      | Lead Owner     |
+-----------------------+---------------------------------------+-------------------+----------------+
| Right to Access       | Download summary of data, processing  | 7 Business Days   | Engineering /  |
| (Section 11)          | activities, and third-party recipients|                   | Support        |
+-----------------------+---------------------------------------+-------------------+----------------+
| Right to Correction   | Update inaccurate contact details,    | Real-time /       | Product /      |
| (Section 12)          | address, or profile attributes        | 48 Hours          | Operations     |
+-----------------------+---------------------------------------+-------------------+----------------+
| Right to Erasure      | Delete account and associated personal| 14 Business Days  | Engineering /  |
| (Section 12)          | data across production databases      |                   | Legal          |
+-----------------------+---------------------------------------+-------------------+----------------+
| Right to Grievance    | File formal complaint regarding data  | Acknowledge 24h;  | Grievance      |
| Redressal (Section 13)| misuse or unaddressed rights          | Resolve 15-30 Days| Officer        |
+-----------------------+---------------------------------------+-------------------+----------------+
| Right to Nominate     | Designate nominee to manage data in   | On Event Notice   | Legal /        |
| (Section 14)          | case of death or incapacity           |                   | Operations     |
+-----------------------+---------------------------------------+-------------------+----------------+
```

## Detailed Rights Workflows

### 1. Right to Access & Information
* **Citizen Experience:** Citizen taps "Request Data Summary" under App Settings.
* **Business Process:** System compiles an automated, machine-readable PDF/JSON extract containing account profile data, active memberships, transaction logs, and a list of third-party processors who have received data.
* **Evidence:** Cryptographic log of the generated report and secure delivery timestamp.

### 2. Right to Correction & Updating
* **Citizen Experience:** Citizen directly updates editable fields (phone, address, photo, bio) via `EditProfileScreen`.
* **Business Process:** Updates synchronize across active database instances; where verified attributes (e.g., phone number) change, OTP verification ensures data integrity.
* **Evidence:** Versioned audit log of profile modifications.

### 3. Right to Erasure ("Delete My Account")
* **Citizen Experience:** Citizen initiates account deletion through a multi-step confirmation dialogue in settings.
* **Business Process:**
  * System verifies absence of unresolved liabilities (e.g., unreturned library books or disputed pending payments).
  * Personal profile, credentials, device tokens, and attendance logs are permanently deleted or irreversibly anonymized.
  * Legally mandated transaction records (tax invoices) are detached from personal profiles and vaulted in immutable financial archives.
* **Evidence:** Cryptographic Deletion Certificate generated and emailed to the citizen.

### 4. Right to Nominate
* **Citizen Experience:** In-app setting allowing the citizen to designate a legal nominee (Name, Relationship, Contact Details).
* **Business Process:** In the event of death or permanent medical incapacity, the verified nominee can execute account closure or retrieve historical records upon submitting legal proof.
* **Evidence:** Encrypted nomination record linked to the citizen profile.

---

# 8. Data Retention & Deletion Objective

## Retention Strategy
Personal data must not be stored indefinitely. Data retention schedules must be linked to active operational utility, statutory mandates, and legal limitation periods.

```
+----------------------------------------------------------------------------------------------------+
|                                    DATA RETENTION & DISPOSAL SCHEDULE                              |
+---------------------------+-----------------------+-----------------------+------------------------+
| Data Category             | Active Period         | Archival / Statutory  | Final Disposal Action  |
+---------------------------+-----------------------+-----------------------+------------------------+
| Real-time GPS Coordinates | Ephemeral (in-flight) | None                  | Immediate overwrite /  |
|                           |                       |                       | zero disk logging      |
+---------------------------+-----------------------+-----------------------+------------------------+
| BLE & QR Check-in Logs    | Active pass validity  | Kept during active    | Erased upon user       |
|                           |                       | membership & pass use | account deletion request|
+---------------------------+-----------------------+-----------------------+------------------------+
| Account Profile Details   | Active account life   | 30 Days post-closure  | Irreversible scrubbing |
| (Name, Phone, Email)      |                       | (grace period)        | of database records    |
+---------------------------+-----------------------+-----------------------+------------------------+
| Support Tickets & Photos  | Until ticket closed   | 1 Year (quality &     | Hard deletion of media |
|                           |                       | audit assurance)      | and ticket transcripts |
+---------------------------+-----------------------+-----------------------+------------------------+
| Tax & Payment Invoices    | Current fiscal year   | 8 Years (Indian GST & | Transfer to isolated,  |
|                           |                       | Income Tax Acts)      | read-only tax archive  |
+---------------------------+-----------------------+-----------------------+------------------------+
```

## Account Deletion Trigger
When a citizen initiates account deletion:
1. Active session tokens are instantly revoked across all devices (`/auth/logout-all`).
2. Push notification device tokens are decoupled and deleted from FCM tables.
3. Profile photos and uploaded media files are deleted from cloud storage buckets.
4. Identifiers in transactional tables are scrubbed or replaced with salted cryptographic hashes (e.g., `user_id_9482` becomes `ANON_CITIZEN_X92J`).
5. A confirmation notification is dispatched, and the citizen is returned to the public splash screen.

---

# 9. Third-Party & Vendor Data Sharing

## Vendor Inventory & Governance Review

| Vendor / Service | Purpose Identified in Repository | Personal Data Potentially Shared | Business Need | User Disclosure Required | Contract / DPA Review | Risk Level | Recommended Action |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Meta Platforms / Facebook SDK** | Social authentication (`flutter_facebook_auth`, `AndroidManifest.xml`) | Device IDs, advertising ID, IP address, Facebook profile ID, app launch telemetry | Low. Google Sign-In and Phone/Email OTP provide sufficient coverage. | Mandatory if retained | High Risk. Meta terms often grant broad rights to repurpose telemetry. | **CRITICAL** | **Business Decision:** Completely remove Facebook SDK to eliminate severe third-party tracking exposure. |
| **Google LLC (Firebase FCM)** | Remote push notifications for ticket confirmations and alerts | Device token, device hardware model, OS version, notification payload titles | High. Reliable notification delivery is essential for booking confirmations. | Mandatory in Privacy Notice | Standard Google Cloud DPA covers Firebase services. | **Medium** | Ensure notification payloads do not contain sensitive personal health or biometric information. |
| **Google LLC (Sign-In)** | Federated social login (`google_sign_in`) | Google ID, Display Name, Email Address, Profile Avatar URL | Medium. Simplifies login for Android users. | Mandatory in Privacy Notice | Standard Google API terms and consumer auth terms. | **Low** | Restrict OAuth scopes strictly to `openid`, `profile`, and `email`. |
| **Google LLC (Google Fonts)** | Custom typography (`google_fonts: ^6.2.1`) | Device IP address, User-Agent during on-demand font asset retrieval | Low. Font styling can be bundled locally. | Desirable | Standard Google service privacy terms. | **Low** | Package font assets locally within Flutter `assets/` to eliminate external network calls. |
| **Payment Gateway Partner** | Processing digital payments for passes, subscriptions, and court rentals | Customer Name, Email, Phone, Transaction Amount, Payment Method metadata | Critical. Core revenue and ticketing mechanism. | Mandatory in Privacy Notice | Execute bespoke DPA ensuring RBI and DPDP compliance. | **High** | Verify gateway does not leak cardholder or banking credentials to mobile client logs. |
| **Participating Facilities** | Physical verification of entrance rights and attendance rosters | Name, Booking Reference, Pass Validity, Check-in Timestamp, Profile Photo | Critical. Security guards and turnstiles must verify ticket holder. | Mandatory in Privacy Notice | Standardize Municipal / Partner Venue Facility Agreements. | **High** | Implement strict Role-Based Access Control (RBAC) preventing venue staff from exporting citizen phone lists. |

---

# 10. Children's Data

```
+----------------------------------------------------------------------------------------------------+
|                                    CHILDREN'S PRIVACY COMPLIANCE GATEWAY                           |
|                                                                                                    |
|                             [ Citizen Registration / Booking Flow ]                                |
|                                                |                                                   |
|                                                v                                                   |
|                                     [ Age Confirmation Prompt ]                                    |
|                                                |                                                   |
|                       +------------------------+------------------------+                          |
|                       |                                                 |                          |
|                       v                                                 v                          |
|            [ Individual Is >= 18 ]                             [ Individual Is < 18 ]              |
|                       |                                                 |                          |
|                       v                                                 v                          |
|            Standard Consent Flow                          [ Minor Workflow Activated ]             |
|                                                                         |                          |
|                                            +----------------------------+-----------------------+  |
|                                            |                                                    |  |
|                                            v                                                    v  |
|                             [ Verifiable Parental Consent ]                      [ Statutory Bans ]|
|                             • Parent enters mobile/email                         • Zero tracking   |
|                             • Parent OTP verification                            • Zero analytics  |
|                             • Explicit parental approval                         • Zero profiling  |
+----------------------------------------------------------------------------------------------------+
```

## Statutory Mandate (Section 9)
Under Section 9 of the DPDP Act, 2023:
1. **Definition:** Any individual who has not completed 18 years of age is legally a **child**.
2. **Verifiable Parental Consent:** A Data Fiduciary must obtain verifiable consent from the parent or lawful guardian before processing any personal data of a child.
3. **Prohibition on Tracking & Behavioral Monitoring:** The business shall not undertake tracking or behavioral monitoring of children, nor direct targeted advertising toward children.
4. **Protection from Detrimental Processing:** Processing that is likely to cause any detrimental effect on the well-being of a child is strictly prohibited.

## Exposure in Smart Cityzen
Smart Cityzen enables booking for swimming pools, sports academies, badminton coaching, and public libraries. These activities naturally attract minors (children and adolescents under 18). Because the app currently has no age gating or guardian linking:
* If an unaccompanied minor creates an account, all collected data violates Section 9.
* Facility occupancy metrics and check-in logs could be construed as tracking minor movement.

## Recommended Safeguards
1. **Age Confirmation at Onboarding:** Introduce a clear age-selection step during registration: *"I confirm I am 18 years of age or older."*
2. **Family & Minor Booking Workflow:** Minors should not hold standalone accounts. Instead, adult parents/guardians register the primary account and add family dependents (Name, Age) under parental delegation.
3. **Strict Behavioral Tracking Ban:** Ensure all analytics SDKs, advertising tags, and behavioral profiling algorithms are completely disabled for any dependent minor profile.

---

# 11. Security & Privacy Risk Objectives

## Business-Level Expectations
The business must implement comprehensive organizational, physical, and technical safeguards to protect personal data against unauthorized access, disclosure, alteration, loss, or destruction.

## Objective Breakdown
1. **Confidentiality & Access Control:** Restrict access to citizen databases strictly on a need-to-know basis. Customer support personnel should view masked phone numbers (e.g., `+91 98XXX-XX123`) unless full unmasking is authorized for specific troubleshooting.
2. **Data in Transit:** Enforce TLS 1.3 encryption across all mobile network traffic interacting with backend APIs. Disallow insecure cleartext HTTP traffic unconditionally (`android:usesCleartextTraffic="false"`).
3. **Data at Rest:** Encrypt all citizen identity tables, backups, and media buckets using industry-standard AES-256 encryption. Keep encryption keys managed via dedicated Key Management Services (KMS).
4. **On-Device Data Protection:** Maintain sensitive credentials and session tokens exclusively within `FlutterSecureStorage` (hardware-backed Android Keystore and iOS Keychain). Ensure debug loggers (`pretty_dio_logger`) are strictly stripped from production release builds to prevent credential leakage to device logs.
5. **Biometric Isolation:** Preserve the architecture where biometric authentication occurs exclusively within on-device hardware enclaves, guaranteeing that fingerprint or facial biometric data is never transmitted to or processed by company servers.

---

# 12. Data Breach & Incident Response Objective

```
+----------------------------------------------------------------------------------------------------+
|                                      DATA BREACH INCIDENT LIFECYCLE                                |
|                                                                                                    |
|  [ 1. Detect & Contain ]  ---> Identify anomaly; isolate affected servers; preserve forensic logs  |
|              |                                                                                     |
|              v                                                                                     |
|  [ 2. Assess & Classify]  ---> Determine compromised data categories, scale, and citizen impact     |
|              |                                                                                     |
|              v                                                                                     |
|  [ 3. Statutory Notice ]  ---> Submit formal notification to the Data Protection Board of India   |
|              |                                                                                     |
|              v                                                                                     |
|  [ 4. Citizen Notice   ]  ---> Notify affected citizens with impact assessment & remediation steps |
|              |                                                                                     |
|              v                                                                                     |
|  [ 5. Post-Mortem Audit]  ---> Root-cause analysis, corrective patching, and governance reporting  |
+----------------------------------------------------------------------------------------------------+
```

## Business Incident Expectations
Under Section 8(6) of the DPDP Act, in the event of a personal data breach, the Data Fiduciary must notify the **Data Protection Board of India (DPBI)** and each affected **Data Principal** in the form and manner prescribed by Central Government rules.

## Operational Incident Protocol
1. **Immediate Containment:** The Incident Response Team isolates compromised systems, revokes active API tokens, and halts affected data pipelines within the first hours of detection.
2. **Forensic Assessment:** Determine the precise nature of the compromise: Were direct identifiers, phone numbers, or passwords exposed? Were records encrypted?
3. **Statutory Escalation:** Notify the DPBI and CERT-In (under applicable Indian cybersecurity directives) following approved legal formats and timelines.
4. **Direct Citizen Communication:** Provide transparent, plain-language notifications to affected citizens detailing:
   * What happened and what data was involved.
   * Potential risks to the citizen (e.g., phishing, spam).
   * Immediate measures taken by the company to secure systems.
   * Recommended actions for the citizen (e.g., password resets).
   * Contact details of the Grievance Officer for direct inquiries.
5. **Evidence Preservation:** Preserve all server access logs, firewall telemetry, and snapshot images in tamper-proof custody for regulatory inspection.

---

# 13. Grievance Management

## Grievance Framework
Section 8(10) requires a Data Fiduciary to establish an accessible, prompt grievance redressal channel. The business must provide citizens with an effective escalation path before any regulatory intervention occurs.

```
+----------------------------------------------------------------------------------------------------+
|                                    GRIEVANCE REDRESSAL WORKFLOW                                    |
|                                                                                                    |
|  [ Citizen Submission ]  ---> Submits via App Settings ("Privacy Grievance") or Email to DPO       |
|             |                                                                                      |
|             v                                                                                      |
|  [ Auto-Acknowledgment]  ---> Automated ticket issued with Unique Tracking ID within 24 Hours       |
|             |                                                                                      |
|             v                                                                                      |
|  [ Triage & Review    ]  ---> Grievance Officer investigates issue with Engineering / Product      |
|             |                                                                                      |
|             v                                                                                      |
|  [ Formal Resolution  ]  ---> Detailed written resolution provided to citizen within 15-30 Days   |
|             |                                                                                      |
|             v                                                                                      |
|  [ Closure or Appeal  ]  ---> Citizen accepts resolution OR escalates complaint to the DPBI        |
+----------------------------------------------------------------------------------------------------+
```

## Mandatory Grievance Officer Disclosures
The business must appoint a Grievance Officer based in India and publicly publish their contact credentials:
* **Title:** Grievance & Data Protection Officer
* **Official Postal Address:** [Registered Corporate Office, India]
* **Dedicated Email:** `privacy@smartcityzen.in` (or organizational domain)
* **Designated Phone Line:** [Direct Grievance Contact Number]

## Tracking & SLA Standards
* **Acknowledgment:** Within 24 hours of ticket submission.
* **Resolution SLA:** Target full investigation and resolution within **15 business days** (not exceeding 30 calendar days).
* **Logging:** All grievance records must be maintained in a secure, auditable register for a minimum of 3 years.

---

# 14. Governance & Accountability

## Privacy Responsibility Matrix (RACI)

```
+----------------------------------------------------------------------------------------------------+
|                                  PRIVACY GOVERNANCE RESPONSIBILITY MATRIX                          |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
| Compliance Area       | Business | Legal /  | Product  | Software | InfoSec  | Customer | Vendor   |
|                       | Exec     | Privacy  | Lead     | Eng      | Lead     | Support  | Mgmt     |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
| Privacy Notice        | Approve  | Account- | Consult  | Implement| Review   | Informed | Informed |
| Approvals             |          | able     |          |          |          |          |          |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
| Consent Architecture  | Informed | Review   | Account- | Respon-  | Review   | Informed | NA       |
| & Workflows           |          |          | able     | sible    |          |          |          |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
| Data Retention &      | Approve  | Review   | Consult  | Respon-  | Account- | NA       | Informed |
| Purge Execution       |          |          |          | sible    | able     |          |          |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
| Vendor DPAs & SDK     | Informed | Account- | Consult  | Respon-  | Review   | NA       | Respon-  |
| Audits                |          | able     |          | sible    |          |          | sible    |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
| Data Subject Rights   | Informed | Review   | Consult  | Respon-  | Review   | Account- | NA       |
| & Erasure Delivery    |          |          |          | sible    |          | able     |          |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
| Data Breach & Board   | Account- | Respon-  | Informed | Respon-  | Respon-  | Informed | Informed |
| Notification          | able     | sible    |          | sible    | sible    |          |          |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
| Grievance Redressal   | Informed | Account- | Informed | Informed | Informed | Respon-  | NA       |
| Operations            |          | able     |          |          |          | sible    |          |
+-----------------------+----------+----------+----------+----------+----------+----------+----------+
```

* **Accountable (A):** The ultimate decision-maker possessing institutional veto power.
* **Responsible (R):** The role tasked with operational execution.
* **Consulted (C):** Subject matter experts consulted prior to execution.
* **Informed (I):** Stakeholders updated following decisions or milestones.

---

# 15. Data Lifecycle

```
+----------------------------------------------------------------------------------------------------+
|                                    PERSONAL DATA LIFECYCLE MODEL                                   |
|                                                                                                    |
| 1. COLLECTION          Citizen inputs data; sensors read BLE/GPS/Camera; third-party auth tokens   |
|       |                                                                                            |
|       v                                                                                            |
| 2. NOTICE              Itemized statutory notice presented in plain English/Hindi                  |
|       |                                                                                            |
|       v                                                                                            |
| 3. CONSENT             Unbundled, affirmative action captured and cryptographically logged         |
|       |                                                                                            |
|       v                                                                                            |
| 4. USE                 Data strictly processed for facility booking, entry, and account management |
|       |                                                                                            |
|       v                                                                                            |
| 5. SHARING             Minimal operational sharing with facility operators & verified processors   |
|       |                                                                                            |
|       v                                                                                            |
| 6. RETENTION           Enforce automated data aging; separate tax invoices from operational data   |
|       |                                                                                            |
|       v                                                                                            |
| 7. USER REQUEST        Citizen accesses, updates, or revokes consent via in-app privacy hub        |
|       |                                                                                            |
|       v                                                                                            |
| 8. DELETION            Automated, irreversible purging across active tables, backups, and caches   |
+----------------------------------------------------------------------------------------------------+
```

---

# 16. Compliance Gap Assessment

| Area | Current State (Observed) | Desired State (Compliant) | Identified Gap | Risk Rating | Business Owner | Recommended Action |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Registration Notice & Consent** | Sign-up captures name, email, phone, city without notice or checkbox. | Pre-registration notice displayed; unbundled affirmative consent checkbox required. | Total absence of consent artifacts and statutory notice at entry point. | **CRITICAL** | Product Lead / Legal | Add notice text and mandatory unticked consent checkbox before sign-up button. |
| **App Privacy Policy** | 3-bullet placeholder text mentioning fictional municipal act. | Comprehensive, multilingual DPDP Notice covering all mandatory Section 5 disclosures. | Misleading legal references; complete lack of required statutory disclosures. | **CRITICAL** | Legal / Privacy Lead | Draft, approve, and deploy comprehensive Privacy Notice with English/Hindi toggle. |
| **Account Deletion & Erasure** | No account deletion button exists in Flutter mobile interface. | Self-service "Delete Account" button executing automated data scrubbing. | Violation of DPDP Section 12 and Apple/Google App Store mandatory guidelines. | **CRITICAL** | Engineering Lead / Product | Build in-app deletion workflow and backend automated erasure pipelines. |
| **Third-Party Tracking SDKs** | Facebook SDK bundled in app manifest with active client tokens. | No unconsented commercial tracking SDKs; documented DPAs with all active processors. | Unchecked data leakage to Meta; lack of data processing agreements. | **HIGH** | Product Lead / InfoSec | Deprecate and remove Facebook SDK; execute DPA with Google and cloud vendors. |
| **Children's Privacy Protection** | Sports and coaching bookings open to all ages without age check. | Age verification gate; minor booking handled via parental accounts only. | Severe exposure under Section 9 if minors register without parental verification. | **HIGH** | Product Lead / Legal | Implement age verification gate and parental consent workflow. |
| **Grievance Redressal** | Generic support ticket form without designated privacy escalation. | Dedicated Privacy Grievance category routing directly to published Grievance Officer. | Non-compliance with Section 8(10) mandatory grievance machinery. | **MEDIUM** | Customer Support / Legal | Designate Grievance Officer; publish details in app and configure ticketing queue. |
| **Data Retention & User Erasure** | Personal data stored without self-service erasure mechanism. | User-controlled data lifecycle with on-demand account & profile erasure. | Lack of compliant Section 12 erasure mechanism for citizens. | **HIGH** | Product / Engineering | Implement in-app account deletion workflow and backend data wipe routines. |
| **Local Logging Security** | `pretty_dio_logger` active in networking layer. | Zero sensitive data logging in release builds; robust certificate pinning. | Potential exposure of auth tokens and personal data in device logcat. | **LOW** | Engineering Lead | Disable Dio logger in production environment; verify release obfuscation. |

---

# 17. DPDP Compliance Roadmap

```
+----------------------------------------------------------------------------------------------------+
|                                    DPDP IMPLEMENTATION ROADMAP                                     |
|                                                                                                    |
|  Phase 1: Immediate Remediation (Weeks 1–2)  ===> Stop active non-compliance & critical liabilities|
|  Phase 2: Policy & Legal Alignment (Weeks 3–4) ===> Approve statutory notices, DPAs, and registers |
|  Phase 3: Product Experience (Weeks 5–6)      ===> Deploy UX privacy hub, deletion flow, age gate |
|  Phase 4: Governance & Ongoing Audit (Week 7+)===> Operationalize monitoring, VAPT, and committees |
+----------------------------------------------------------------------------------------------------+
```

## Phase 1 — Immediate Remediation (Weeks 1–2)
* **Action 1.1: Remove Meta / Facebook SDK**
  * *Objective:* Eliminate unauthorized third-party telemetry leakage.
  * *Owner:* Engineering Lead
  * *Priority:* Critical
* **Action 1.2: Deploy Interim Registration Notice & Consent Checkbox**
  * *Objective:* Secure affirmative consent on all new user registrations immediately.
  * *Owner:* Product Lead / Engineering
  * *Priority:* Critical
* **Action 1.3: Secure Production Network Logging**
  * *Objective:* Strip all API request/response logging from production application binaries.
  * *Owner:* Engineering Lead
  * *Priority:* High

## Phase 2 — Policy & Legal Alignment (Weeks 3–4)
* **Action 2.1: Finalize & Publish Comprehensive Privacy Notice**
  * *Objective:* Replace placeholder modal with legally reviewed bilingual notice.
  * *Owner:* Legal / Privacy Lead
  * *Priority:* Critical
* **Action 2.2: Execute Data Processing Agreements (DPAs)**
  * *Objective:* Secure signed DPAs with cloud host, payment gateway, and SMS vendors.
  * *Owner:* Vendor Management / Legal
  * *Priority:* High
* **Action 2.3: Appoint Official Grievance Officer**
  * *Objective:* Establish statutory escalation officer and register contact email/address.
  * *Owner:* Management / Legal
  * *Priority:* High

## Phase 3 — Product Experience (Weeks 5–6)
* **Action 3.1: Deliver "Delete My Account" Feature**
  * *Objective:* Enable self-service account closure and automated backend erasure.
  * *Owner:* Product Lead / Engineering Lead
  * *Priority:* Critical
* **Action 3.2: Implement Age Gate & Minor Booking Protection**
  * *Objective:* Introduce age confirmation and parental consent delegation.
  * *Owner:* Product Lead
  * *Priority:* High
* **Action 3.3: Launch Citizen Privacy Hub**
  * *Objective:* Provide in-app controls for consent withdrawal, data export, and grievance filing.
  * *Owner:* Product Lead / Engineering
  * *Priority:* Medium

## Phase 4 — Governance & Ongoing Audit (Week 7 Onward)
* **Action 4.1: Establish User-Triggered Data Erasure Pipelines**
  * *Objective:* Ensure complete, irreversible deletion of user profile and logs upon deletion request.
  * *Owner:* Engineering Lead / InfoSec
  * *Priority:* High
* **Action 4.2: Conduct Comprehensive VAPT Audit**
  * *Objective:* Validate security safeguards via accredited external security auditors.
  * *Owner:* InfoSec Lead
  * *Priority:* High
* **Action 4.3: Institute Quarterly Privacy Steering Committee**
  * *Objective:* Maintain organizational oversight, review grievances, and update DPDP policies.
  * *Owner:* Business Executive
  * *Priority:* Medium

---

# 18. Business Decisions Required

The following fundamental policy and operational decisions must be reviewed and formally approved by executive management, legal counsel, and product leadership:

1. **Third-Party Social Login Strategy:**
   * *Decision:* Shall the business completely remove the Facebook Login SDK to eliminate third-party data tracking risks, relying exclusively on Google Sign-In and Mobile OTP?
   * *Owner:* Product Owner & Management
2. **Profile Attribute Minimisation:**
   * *Decision:* Which secondary profile attributes (education, profession, skills, hobbies, bio) should be retained as optional community features, and which should be permanently removed from the data schema?
   * *Owner:* Product Lead & Business Owner
3. **Children's Service Policy:**
   * *Decision:* Does the business permit minors (under 18) to use facilities independently, or will the terms mandate that all bookings for individuals under 18 must be managed through an adult guardian's account?
   * *Owner:* Legal Counsel & Business Management
4. **Data Retention & User-Driven Erasure Policy:**
   * *Decision:* Confirm policy that check-in records and pass history are retained exclusively for the duration of the user's active account/membership and deleted strictly upon user request or account cancellation.
   * *Owner:* Legal / Privacy & Product Lead
5. **Residual Financial Data Post-Account Erasure:**
   * *Decision:* How should financial tax invoices be archived following user account deletion to ensure compliance with Indian GST laws while fulfilling the citizen's erasure right?
   * *Owner:* Finance, Legal & Engineering Lead
6. **Appointment of Grievance Officer:**
   * *Decision:* Who within the organization shall be officially designated and publicly registered as the statutory Grievance Officer under the DPDP Act?
   * *Owner:* Executive Management

---

# 19. Evidence & Compliance Records

To satisfy statutory scrutiny and demonstrate defensible accountability before the Data Protection Board of India, the organization must systematically maintain the following records:

```
+----------------------------------------------------------------------------------------------------+
|                                      COMPLIANCE EVIDENCE REPOSITORY                                |
+-----------------------------------+----------------------------------------------------------------+
| Compliance Artifact               | Contents & Purpose                                             |
+-----------------------------------+----------------------------------------------------------------+
| **Consent Ledger**                | Immutable, timestamped database records linking citizen ID,    |
|                                   | notice version, IP address, and specific consent scope.        |
+-----------------------------------+----------------------------------------------------------------+
| **Versioned Notice Archive**      | Historical repository of every published Privacy Notice with   |
|                                   | effective dates, revision notes, and legal approval sign-offs. |
+-----------------------------------+----------------------------------------------------------------+
| **Vendor DPA Register**           | Signed Data Processing Agreements and security assessments for |
|                                   | every external cloud host, payment gateway, and SDK vendor.    |
+-----------------------------------+----------------------------------------------------------------+
| **Data Inventory & Data Flows**   | Current Record of Processing Activities (ROPA) mapping all     |
|                                   | personal data sources, processing purposes, and storage tiers. |
+-----------------------------------+----------------------------------------------------------------+
| **User Rights & Erasure Audit**   | Completed tickets documenting data summary exports, consent    |
|                                   | withdrawals, and cryptographic account deletion receipts.      |
+-----------------------------------+----------------------------------------------------------------+
| **Grievance Register**            | Formal register recording every privacy complaint received,    |
|                                   | communication log, investigation notes, and final closure SLA. |
+-----------------------------------+----------------------------------------------------------------+
| **Data Retention Purge Logs**     | Automated system logs confirming the scheduled destruction     |
|                                   | of expired attendance records and temporary media caches.      |
+-----------------------------------+----------------------------------------------------------------+
| **Security Audit Certificates**   | Annual third-party VAPT reports, ISO/IEC 27001 certifications, |
|                                   | and vulnerability remediation sign-offs.                       |
+-----------------------------------+----------------------------------------------------------------+
```

---

# 20. Definition of Done

The Smart Cityzen application and its governing operations shall be considered **Ready for Final Legal & Privacy Certification** only when all of the following measurable criteria have been satisfied:

* [ ] **Personal Data Inventory Reviewed:** Product and Engineering teams have validated all collected fields; unnecessary secondary profile fields have been eliminated.
* [ ] **Notice & Consent Implemented:** A bilingual (English/Hindi) statutory notice precedes registration; affirmative, unbundled consent checkboxes are live in production builds.
* [ ] **Self-Service Erasure Operational:** Citizens can initiate account deletion within app settings; automated backend routines permanently scrub personal records.
* [ ] **Vendor Clean-up Completed:** The Meta/Facebook SDK has been excised; signed DPAs are executed with Google, AWS, and Payment Gateway partners.
* [ ] **Children's Policy Enforced:** Age gate confirmed at registration; child tracking prohibited; parental delegation workflow approved.
* [ ] **Grievance Machinery Operational:** Grievance Officer appointed, contact details published in-app, and dedicated privacy ticketing queue active.
* [ ] **Security Hardening Verified:** In-app production logging disabled; sensitive tokens stored in secure enclaves; external VAPT audit conducted without open critical findings.
* [ ] **Evidence Framework Automated:** Tamper-resistant consent logging, deletion auditing, and automated data retention purge routines verified by engineering.

*(Completion of these items establishes operational readiness and alignment; it does not constitute a perpetual legal immunity or external certification without periodic legal review.)*

---

# 21. Final Recommendations

## Management Summary

```
+----------------------------------------------------------------------------------------------------+
|                                       EXECUTIVE ACTION MATRIX                                      |
|                                                                                                    |
| 1. Biggest Current Risk   ===> Operating registration without statutory notice & affirmative       |
|                                consent while bundling unverified third-party tracking SDKs.        |
|                                                                                                    |
| 2. Most Important Action  ===> Excising the Facebook SDK, deploying an in-app Account Deletion    |
|                                mechanism, and establishing an itemized pre-registration notice.    |
|                                                                                                    |
| 3. Execution Priority     ===> Phase 1 Immediate Remediation (Weeks 1-2) must be launched          |
|                                immediately to cap active statutory exposure under DPDP.           |
+----------------------------------------------------------------------------------------------------+
```

### Action Segregation by Team

#### Items Requiring Immediate Legal & Privacy Specialist Review
* Final review and sign-off on the full bilingual statutory Privacy Notice.
* Legal determination of Joint Data Fiduciary versus Data Processor relationships with municipal corporations and private facility operators.
* Validation of parental consent mechanisms for coaching batch enrollments involving minors.
* Formal drafting of standard Data Processing Agreements (DPAs) for venue partners.

#### Items Requiring Business & Management Decisions
* Approval to deprecate and remove the Facebook / Meta Login SDK.
* Formal selection and appointment of the statutory Grievance Officer.
* Formal approval of the Data Retention & User Erasure Policy (retained during active membership, deleted strictly on user request).
* Resource allocation for external VAPT security testing.

#### Items Requiring Product & Engineering Implementation
* Introduce mandatory, unticked consent checkbox and pre-registration notice link on `login_register_screen.dart`.
* Build in-app "Delete Account & Personal Data" workflow in `settings_screen.dart` connected to backend deletion APIs.
* Implement age-gating prompt during registration and dependent booking profiles.
* Strip `pretty_dio_logger` from production release builds.
* Build backend erasure routines to wipe user check-in logs and personal records upon user account deletion.

---

# Important Legal Disclaimer

> [!CAUTION]
> **LEGAL NOTICE & PRACTICE LIMITATION:**
> This document is an operational business strategy, privacy risk assessment, and technical-compliance planning framework. It **does NOT constitute legal advice, a formal legal opinion, or a legal certification of compliance** under the Digital Personal Data Protection Act, 2023, or any other Indian or international privacy statute.
>
> The regulatory requirements under the DPDP Act are subject to formal administrative rules, official gazette notifications, government exemptions, and evolving judicial interpretations by the Central Government and the Data Protection Board of India. Any final compliance posture, privacy notice wording, contract terms, or operational process must be reviewed, finalized, and approved by an appropriately qualified legal practitioner specializing in Indian data protection law.
