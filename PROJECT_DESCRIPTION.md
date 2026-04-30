**Project CyberEye** is a high-fidelity, multi-layered security ecosystem designed to provide an "uncompromising audit" of digital assets. It moves beyond simple detection by implementing a **Judicial Ensemble Architecture**—where specialized forensic models act as technical witnesses and **Gemini 3.1 Pro** acts as the final "Brutal Judge."

---

## 🛠️ Feature-by-Feature Breakdown

### 1. Media Forensic Lab (The Deepfake Hunter)
This module targets the growing threat of AI-generated misinformation. It doesn't just guess; it performs a two-stage anatomical and physical audit of media.
*   **The Technical Witness:** A **Swin-B Transformer** (Shifted Window) or **ViT** hosted on a cloud microservice. It breaks images into patches to find "mathematical noise," frequency anomalies, and pixel-warping invisible to humans.
*   **The Brutal Judge:** Results are passed to **Gemini 3.1 Pro**. The judge performs a **Physics & Biological Audit**, checking for impossible shadows, iris reflection inconsistencies, and unnatural ear/jaw geometry.
*   **Output:** A high-contrast **Evidence Map** (Grad-CAM heatmap) showing exactly where the pixels were manipulated, accompanied by a no-nonsense verdict.

### 2. Neural Link Triage (The Fraud Shield)
Designed to intercept phishing, typosquatting, and social engineering attempts in real-time.
*   **Structural Triage:** Before hitting the AI, local algorithms calculate **Shannon Entropy** (to detect random, machine-generated domains) and **Levenshtein Distance** (to detect spoofed domains like `g0ogle.com`).
*   **Psychological Audit:** Gemini 3.1 Pro analyzes the "Social Engineering" context of the message—identifying false urgency, authority impersonation, and "Lottery-trap" linguistic patterns.
*   **Output:** A "Zero-Execution" report that identifies the threat without the user ever having to visit the link.

### 3. CyberCheck360 Sandbox (The Detonation Chamber)
This is the ultimate "Safe Mode" for links that are suspicious but require closer inspection.
*   **The Mechanic:** If a user chooses to investigate a high-risk link, CyberEye provides a **Secure Handoff** to the CyberCheck360 environment.
*   **Isolated Detonation:** The link is opened in a **Cloud-Based Disposable Browser**. Any "drive-by" malware or tracking scripts execute on a remote server that is deleted instantly after the session.
*   **Security Benefit:** Total local hardware isolation. The user's device remains "air-gapped" from the malicious code while still being able to view the content.

### 4. Breach Guard (Password Sentinel)
A proactive privacy-first tool that checks if a user's password has been exposed in a data breach using cryptographic K-Anonymity.
*   **Reconnaissance:** Uses the free **Pwned Passwords Range API**. It hashes the password locally (SHA-1), sends only the first 5 characters (the prefix) to the API, and checks the response locally to see if the full hash exists.
*   **Privacy Guarantee:** The full password or full hash never leaves the user's device, ensuring mathematical privacy.
*   **Output:** A direct warning detailing exactly how many times that specific password has been seen in dark web breaches, prompting immediate rotation.

### 5. Legal Scout (The TOS Auditor)
Most users agree to "Predatory Terms" because they are too long to read. This module uses high-reasoning AI to protect the user's legal rights.
*   **Deep Extraction:** Utilizes Gemini 3.1’s **1-Million Token Context Window** to "read" entire legal PDFs or URL-based Terms of Service in seconds.
*   **Red-Flag Detection:** Specifically hunts for "Anti-User" clauses regarding **Data Sovereignty** (Who owns your photos?), **Shadow Costs** (Hidden fees), and **Privacy Erasure** (Can you actually leave?).
*   **Output:** Categorized **Evidence Pills** (e.g., 🔴 *High Risk: Company claims perpetual ownership of all uploaded media.*).

---

## 🏗️ The Tech Stack (The "Behind the Scenes")

| Layer | Technology | Role |
| :--- | :--- | :--- |
| **Frontend** | Flutter (Dart) + Riverpod | Cross-platform adaptive dashboard (Mobile/Desktop). |
| **Primary Logic** | **Gemini 3.1 Pro** | The "Brutal Judge" and High-Reasoning Auditor. |
| **Vision Model** | **Swin Transformer** | The technical witness for pixel-level forensics. |
| **Cloud Inference** | Hugging Face Spaces | Hosting the specialized Python ML microservices. |
| **Data Source** | HIBP API | Real-time dark web breach monitoring. |
| **Isolation** | CyberCheck360 | The external sandbox "Safe Mode" bridge. |

---

## 📈 The UX: The "Master Eye" Dashboard
The project is centered around a single, interactive **Riskometer**. 
*   **The Pulse:** When a scan is initiated, the UI enters "Thinking Mode," showing real-time logs from the ensemble models (e.g., *"Swin Model: Anomalous Patch Detected..."*).
*   **The Verdict:** Once the models reach a consensus, the "Eye" changes color (Green/Yellow/Red) and presents the **Evidence Wall**, a summary of all technical reasons for the decision.

**CyberEye is more than a scanner—it’s a judicial defense system that ensures you never have to "trust" the digital world blindly again.**