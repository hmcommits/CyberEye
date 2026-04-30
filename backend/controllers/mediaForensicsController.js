const fs = require('fs');
const path = require('path');
const multer = require('multer');
const axios = require('axios');
const FormData = require('form-data');
const { GoogleGenAI } = require('@google/genai');

// Configure Disk Storage
const uploadDir = path.join(__dirname, '../uploads');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + '-' + file.originalname);
  }
});
const upload = multer({ storage: storage });

const ai = new GoogleGenAI({});

// Exponential Backoff helper for Gemini
async function generateWithBackoff(prompt, maxRetries = 3, initialDelay = 1000) {
  let attempt = 0;
  while (attempt < maxRetries) {
    try {
      const response = await ai.models.generateContent({
        model: 'gemini-2.5-flash',
        contents: prompt
      });
      return response.text;
    } catch (error) {
      if (error.message && (error.message.includes('429') || error.message.includes('503'))) {
        attempt++;
        if (attempt >= maxRetries) throw error;
        const delay = initialDelay * Math.pow(2, attempt - 1);
        console.warn(`[Gemini] Rate limit hit. Retrying in ${delay}ms... (Attempt ${attempt}/${maxRetries})`);
        await new Promise(resolve => setTimeout(resolve, delay));
      } else {
        throw error;
      }
    }
  }
}

exports.uploadMiddleware = upload.single('image');

exports.analyzeMedia = async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ success: false, error: 'No image uploaded' });
  }

  const filePath = req.file.path;
  const hfUrl = process.env.HF_MICROSERVICE_URL;
  const hfToken = process.env.HF_TOKEN || process.env.HF_API_TOKEN;

  try {
    // 1. Call HF Microservice (YOLOv12)
    let technicalWitness = [];
    if (hfUrl) {
      try {
        const fileStream = fs.createReadStream(filePath);
        const formData = new FormData();
        formData.append('file', fileStream);

        const headers = { ...formData.getHeaders() };
        if (hfToken) {
          headers['Authorization'] = `Bearer ${hfToken}`;
        }

        const hfResponse = await axios.post(`${hfUrl}/api/v1/analyze-image`, formData, { headers, timeout: 30000 });
        
        // Ensure array format for UI compatibility
        if (hfResponse.data.analysis && Array.isArray(hfResponse.data.analysis)) {
           technicalWitness = hfResponse.data.analysis;
        } else if (hfResponse.data.analysis) {
           technicalWitness = [{ 
             label: hfResponse.data.analysis.predicted_class || 'Unknown Object', 
             confidence: hfResponse.data.analysis.confidence_score || 0.0 
           }];
        }
      } catch (err) {
        console.error('[HF Error]', err.message);
        technicalWitness = [{ label: 'YOLOv12 API Unavailable', confidence: 0.0 }];
      }
    }

    // 2. Brutal Judge (Gemini 2.5 Flash) with Exponential Backoff
    const base64Image = fs.readFileSync(filePath, { encoding: 'base64' });
    const prompt = [
      {
        role: 'user',
        parts: [
          {
            inlineData: { data: base64Image, mimeType: req.file.mimetype }
          },
          {
            text: `You are the 'Brutal Judge'. Based on the image and these YOLOv12 detections: ${JSON.stringify(technicalWitness)}, provide a 3-sentence forensic analysis of physical anomalies (shadows, edges, lighting). End with VERDICT: AUTHENTIC or VERDICT: SYNTHETIC.`
          }
        ]
      }
    ];

    let brutalJudgeVerdict = "";
    try {
      brutalJudgeVerdict = await generateWithBackoff(prompt);
    } catch (gErr) {
      brutalJudgeVerdict = "Error performing physics audit: " + gErr.message;
    }

    // 3. Cleanup Buffer
    fs.unlinkSync(filePath);

    // 4. Return formatted JSON
    return res.json({
      success: true,
      technical_witness: technicalWitness,
      brutal_judge: brutalJudgeVerdict
    });

  } catch (error) {
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }
    return res.status(500).json({ success: false, error: error.message });
  }
};
