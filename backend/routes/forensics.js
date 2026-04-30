const express = require('express');
const router = express.Router();
const multer = require('multer');
const axios = require('axios');
const FormData = require('form-data');
const { GoogleGenAI } = require('@google/genai');

const upload = multer({ storage: multer.memoryStorage() });

// Initialize Gemini Client
// We assume GEMINI_API_KEY is available in the environment
const ai = new GoogleGenAI({});

router.post('/analyze', upload.single('image'), async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No image uploaded' });
    }

    const hfUrl = process.env.HF_MICROSERVICE_URL;
    const hfToken = process.env.HF_TOKEN;

    if (!hfUrl) {
      return res.status(500).json({ error: 'HF_MICROSERVICE_URL not configured' });
    }

    // Step 1: Send to Hugging Face Microservice (Swin Transformer)
    const formData = new FormData();
    formData.append('file', req.file.buffer, {
      filename: req.file.originalname,
      contentType: req.file.mimetype,
    });

    const hfHeaders = { ...formData.getHeaders() };
    if (hfToken) {
      hfHeaders['Authorization'] = `Bearer ${hfToken}`;
    }

    let hfReport = {};
    try {
      const hfResponse = await axios.post(`${hfUrl}/api/v1/analyze-image`, formData, {
        headers: hfHeaders,
        timeout: 30000, // 30 seconds timeout for ML Inference
      });
      hfReport = hfResponse.data.analysis;
    } catch (hfError) {
      console.error('[HF Microservice Error]', hfError.message);
      // In a real scenario, we might fail fast or continue with Gemini only.
      // For this robust 2026 system, we want to inform the user if a layer fails.
      hfReport = { error: 'Technical Witness Unavailable', details: hfError.message };
    }

    // Step 2: Gemini 3.1 Pro Physics & Biological Audit
    let geminiVerdict = '';
    try {
      const base64Image = req.file.buffer.toString('base64');
      const response = await ai.models.generateContent({
        model: 'gemini-1.5-flash', // Gracefully degrading to 1.5-Flash to bypass the 'limit: 0' restriction on free-tier keys
        contents: [
          {
            role: 'user',
            parts: [
              {
                inlineData: {
                  data: base64Image,
                  mimeType: req.file.mimetype,
                },
              },
              {
                text: "You are the 'Brutal Judge' in a cyber-forensics pipeline. " +
                      "Analyze this image for impossible shadows, iris reflection inconsistencies, " +
                      "unnatural ear/jaw geometry, or physical anomalies common in AI generation. " +
                      "Provide a concise, highly technical paragraph outlining your findings, " +
                      "and end with a definitive verdict of either 'SYNTHETIC' or 'AUTHENTIC'.",
              },
            ],
          },
        ],
      });
      geminiVerdict = response.text;
    } catch (geminiError) {
      console.error('[Gemini Error]', geminiError.message);
      geminiVerdict = 'Error performing physics audit: ' + geminiError.message;
    }

    // Step 3: Combine and return
    res.json({
      status: 'success',
      report: {
        technical_witness: hfReport,
        brutal_judge_verdict: geminiVerdict,
      },
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
