This is the definitive, zero-compromise implementation plan for **Project CyberEye**. This plan eliminates the need for expensive infrastructure by using a distributed "Serverless + Microservice" architecture, ensuring a **₹0 operational cost** while maintaining elite technical depth.

---

### **1. Core System Architecture**
CyberEye is built on a **Quad-Tier Security Stack**:
*   **Frontend:** Flutter (Dart 3.x) + Riverpod (Adaptive Mobile & Desktop UI).
*   **Primary Backend:** Node.js (Vercel Edge Functions) for API orchestration.
*   **Forensic Microservice:** Python (FastAPI) on Hugging Face Spaces for Swin/ViT inference.
*   **Reasoning Engine:** Google Gemini 3.1 Pro API (High-Reasoning mode).

---

### **2. Feature-Specific Implementation**

#### **A. Media Forensic Lab (M-Feature)**
*   **Objective:** Multi-stage deepfake detection.
*   **Step 1 (Technical Witness):** Setup a Python script on Hugging Face using `transformers`. Load `microsoft/swin-base-patch4-window7-224` (fine-tuned for deepfakes).
*   **Step 2 (The Hook):** Flutter frontend sends the image buffer to the HF Space.
*   **Step 3 (Brutal Judge):** Node.js receives the Swin model's confidence score and patches. It then forwards the **Image + Swin Report** to Gemini 3.1 Pro.
*   **Step 4 (XAI Output):** Gemini generates a "Brutal Decision" based on physics (shadows, biological logic). The UI renders a **Grad-CAM Heatmap** showing suspicious pixel regions.

#### **B. Neural Link Triage (F-Feature)**
*   **Objective:** Algorithmic and psychological URL audit.
*   **Step 1 (Local Triage):** Implement a Dart Isolate utility in the frontend to calculate **Shannon Entropy** (randomness) and **Levenshtein Distance** (similarity to sites like Google/Amazon) at 120 FPS.
*   **Step 2 (The Judge):** Pass the full message context and URL metadata to Gemini 3.1 Pro.
*   **Step 3 (Social Engineering Check):** Gemini identifies "Linguistic Urgency" or "Credential Phishing" patterns.
*   **Step 4 (Verdict):** Display a "Risk Level" (0-100) and the **Safe Mode Bridge** button if the risk is $>40\%$.

#### **C. Breach Guard (Password Sentinel)**
*   **Objective:** Password breach detection using K-Anonymity (Zero-Cost).
*   **Step 1 (Local Hashing):** The Flutter frontend hashes the user's inputted password using SHA-1.
*   **Step 2 (The Proxy):** The frontend sends **only the first 5 characters** of the hash to the Node.js backend proxy.
*   **Step 3 (The Recon):** Node.js makes a GET request to `https://api.pwnedpasswords.com/range/{prefix}` and returns the list of matching hash suffixes and breach counts.
*   **Step 4 (Local Verification):** Flutter receives the list, searches for the remaining characters of the local hash, and if a match is found, displays the exposure count.

#### **D. CyberCheck360 Sandbox (The Bridge)**
*   **Objective:** 100% hardware isolation for suspicious links.
*   **Step 1 (The Handshake):** When a user clicks "Open in Safe Mode," the URL is Base64 encoded.
*   **Step 2 (Redirect):** The app triggers the device's external browser (via `url_launcher`) to the **CyberCheck360** endpoint with the encoded payload: `[https://cybercheck360.com/detonate?target=BASE64_URL](https://cybercheck360.com/detonate?target=BASE64_URL)`.
*   **Step 3 (UX):** A warning modal appears first, explaining that the site is now "detonating" in a cloud container.

#### **E. Legal Scout (TOS Feature)**
*   **Objective:** Summarizing predatory legal terms.
*   **Step 1 (Ingestion):** User uploads a TOS PDF or pastes a link.
*   **Step 2 (The Deep Read):** Send the text to Gemini 3.1 Pro using its **1-Million Token Window**.
*   **Step 3 (The Red Flag Hunter):** Gemini is prompted to extract only clauses related to:
    *   *Data Ownership*, *Auto-renewal*, *Liability Waivers*, and *Privacy Erasure*.
*   **Step 4 (Pill UI):** Render these as color-coded "Evidence Pills" (Red/Yellow/Green) for scannability.

---

### **3. Detailed Development Roadmap**

| Phase | Task | Key Deliverable |
| :--- | :--- | :--- |
| **Wk 1** | **Foundation** | Flutter setup + Adaptive Theming + Riverpod + Desktop Drag/Drop. |
| **Wk 2** | **ML Microservice** | Deploy FastAPI on Hugging Face with Swin Transformer. |
| **Wk 3** | **Ensemble Core** | Connect Node.js to Gemini 3.1 & HF Space. Implement the "Brutal Judge" logic. |
| **Wk 4** | **Data & Sandbox** | HIBP Integration + Breach Text Mapping + CyberCheck360 Bridge. |
| **Wk 5** | **The Master Eye** | Build the SVG Riskometer + Real-time Forensic Log UI. |
| **Wk 6** | **Zero-Cost Deploy** | Connect GitHub to Vercel. Setup Env Variables. Final Security Audit. |

---

### **4. Security & Privacy Protocols**
*   **Zero-Persistence:** CyberEye will **not** use a database. All scans are stateless—once the tab is closed, the data is gone.
*   **Header Security:** Use `helmet.js` on the Node.js backend and strict `CSP` (Content Security Policy) to prevent XSS.
*   **Encryption:** All communication between the frontend, Node.js, and Hugging Face must occur over **TLS 1.3 (HTTPS)**.
*   **API Masking:** All API keys (Gemini, HIBP) are stored as **Server-Side Environment Variables**—they are never exposed to the browser.

---

### **5. Final "Technical Depth" Checklist**
*   [ ] **Algorithmic:** Levenshtein and Shannon Entropy implemented locally.
*   [ ] **Machine Learning:** Swin Transformer running on server-side GPU/CPU.
*   [ ] **Reasoning:** Gemini 3.1 Pro performing "High Thinking" physics audits.
*   [ ] **Architecture:** Serverless Microservice structure (Flutter + Node + Python).
*   [ ] **Isolation:** External Detonation via CyberCheck360 bridge.

**CyberEye is now fully mapped. Would you like to see the specific JSON mapping for the "Breach Guard" text explanations to ensure they are professional and detailed?**