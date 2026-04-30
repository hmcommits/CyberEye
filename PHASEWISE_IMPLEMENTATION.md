# Phase-Wise Implementation Plan

This document outlines the detailed practical implementation plan and task list for Project CyberEye (Flutter Architecture). The development is divided into 10 logical phases to ensure a structured approach from scaffolding to deployment.

## Phase 1: Project Scaffolding & Design System

**Goal:** Establish the foundational Flutter architecture, set up routing, and build out the design system (adaptive mobile/desktop) for the "Master Eye" aesthetic.

*   [ ] Delete any legacy React/web directories.
*   [ ] Initialize the Flutter project in the `/app` directory.
*   [ ] Configure core dependencies: `flutter_riverpod`, `go_router`, `dio`, `url_launcher`.
*   [ ] Set up adaptive layouts and core theming (colors, typography) for Desktop/Mobile.
*   [ ] Create the "Master Eye" custom painter base and animation controllers (Pulse effect).
*   [ ] Set up basic `go_router` paths with placeholder screens for the main features.
*   [ ] Create core reusable UI components (Buttons, Cards, Modals).

## Phase 2: ML Forensic Microservice (Python/HF Spaces)

**Goal:** Deploy the Swin Transformer deepfake detection logic as a standalone FastAPI microservice on Hugging Face Spaces.

*   [ ] Create a new directory `hf-microservice`.
*   [ ] Set up a Python virtual environment and `requirements.txt` (including `fastapi`, `uvicorn`, `transformers`, `torch`, `Pillow`).
*   [ ] Create `main.py` and set up the FastAPI application structure.
*   [ ] Integrate the `microsoft/swin-base-patch4-window7-224` model using Hugging Face `transformers`.
*   [ ] Implement an endpoint (e.g., `/api/v1/analyze-image`) that accepts an image upload.
*   [ ] Write the logic to process the image through the Swin model and extract confidence scores and patch anomalies.
*   [ ] Return a structured JSON response containing the analysis data.
*   [ ] Deploy the service to Hugging Face Spaces and verify public endpoint accessibility.

## Phase 3: Backend API Layer (Node.js/Vercel)

**Goal:** Create the orchestration layer that securely handles frontend requests, interacts with external APIs (Gemini, HIBP), and communicates with the ML Microservice.

*   [ ] Initialize a Node.js project for the backend (`mkdir backend && cd backend && npm init -y`).
*   [ ] Install necessary dependencies (`express`, `cors`, `dotenv`, `helmet`, `@google/genai`).
*   [ ] Set up the Express server and configure basic middleware (CORS, Helmet).
*   [ ] Create a `.env` file to store API keys securely.
*   [ ] Define the route structure for the different features.
*   [ ] Implement a generic error-handling middleware.
*   [ ] Prepare the Vercel configuration (`vercel.json`) for serverless deployment.

## Phase 4: Feature A - Media Forensic Lab

**Goal:** Connect the Flutter image picker to the Node.js backend, which then orchestrates the Swin model analysis and Gemini "Brutal Judge" evaluation.

*   [ ] **Flutter:** Integrate `image_picker` for mobile and standard file selection for desktop.
*   [ ] **Backend:** Implement an endpoint (`/api/forensics/analyze`) to receive the image.
*   [ ] **Backend:** Forward the image to the Hugging Face microservice and retrieve the Swin report.
*   [ ] **Backend:** Integrate with Gemini 3.1 Pro API for the "Physics & Biological Audit".
*   [ ] **Backend:** Format the final combined response and send it to the frontend.
*   [ ] **Flutter:** Render the final verdict, confidence scores, and visual evidence using a Stack to overlay Grad-CAM heatmaps.

## Phase 5: Feature B - Neural Link Triage

**Goal:** Implement the algorithmic and psychological URL audit feature.

*   [ ] **Flutter:** Create an input component for URLs/messages.
*   [ ] **Flutter/Isolate:** Implement Dart Isolates to calculate Shannon Entropy and Levenshtein Distance at 120FPS without UI jank.
*   [ ] **Backend:** Implement an endpoint (`/api/triage/analyze-link`) to receive the URL context.
*   [ ] **Backend:** Integrate with Gemini 3.1 Pro to perform the "Social Engineering Check".
*   [ ] **Flutter:** Display the "Risk Level" and detailed analysis. Show the "Safe Mode Bridge" button if the risk threshold is met.

## Phase 6: Feature C - Breach Guard

**Goal:** Integrate HIBP API and implement the static severity classification mapping.

*   [ ] **Flutter:** Create an input form to submit an email address.
*   [ ] **Backend:** Implement an endpoint (`/api/breach/check`) that securely proxies requests to the HIBP API (v3).
*   [ ] **Backend/Utility:** Create the static JSON mapping dictionary that correlates HIBP `DataClasses` to human-readable severity alerts.
*   [ ] **Backend:** Process the HIBP response, apply the static mapping, and formulate the final "Identity Risk Report".
*   [ ] **Flutter:** Render the resulting 3-Step Recovery Plan and specific breach details using adaptive data tables.

## Phase 7: Feature D - CyberCheck360 Sandbox

**Goal:** Implement the secure handoff mechanism for opening suspicious links in an isolated environment.

*   [ ] **Flutter:** Implement the URL Base64 encoding logic using `dart:convert`.
*   [ ] **Flutter:** Create the warning modal explaining the detonation process.
*   [ ] **Flutter:** Implement the `url_launcher` logic to trigger the device's external browser with the encoded payload.

## Phase 8: Feature E - Legal Scout

**Goal:** Implement the TOS analyzer using Gemini's large context window.

*   [ ] **Flutter:** Use `file_picker` to upload PDF documents (implement desktop drag-and-drop overlay).
*   [ ] **Backend:** Implement an endpoint (`/api/legal/audit-tos`) to receive the TOS content.
*   [ ] **Backend:** Integrate with Gemini 3.1 Pro, providing a specific prompt to hunt for predatory clauses.
*   [ ] **Flutter:** Parse the structured response from the backend and render the color-coded "Evidence Pills".

## Phase 9: Master Eye UI & Polish

**Goal:** Finalize the user interface, ensuring all components are cohesive, animated smoothly, and visually striking.

*   [ ] Refine the custom painter for the "Riskometer".
*   [ ] Implement "Thinking Mode" Hero transitions and Impeller-optimized animations.
*   [ ] Ensure the adaptive layout cleanly reflows from mobile (vertical stacking) to 4K desktop (multi-pane dashboard).
*   [ ] Implement skeleton loaders for all Riverpod `AsyncValue.loading` states.

## Phase 10: Security Hardening & Deployment

**Goal:** Ensure the application is secure and deployed robustly.

*   [ ] Conduct a thorough security review (verify no exposed API keys in Flutter).
*   [ ] Verify TLS 1.3 usage across all `dio` client calls.
*   [ ] Compile Flutter for Web, Android, iOS, Windows, and macOS.
*   [ ] Deploy the Node.js backend to Vercel and microservice to Hugging Face.
*   [ ] Perform a final end-to-end test of all features.
