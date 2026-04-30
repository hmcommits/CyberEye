require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Routes
const forensicsRoutes = require('./routes/forensics');
const triageRoutes = require('./routes/triage');
const breachRoutes = require('./routes/breach');
const legalRoutes = require('./routes/legal');

app.use('/api/forensics', forensicsRoutes);
app.use('/api/triage', triageRoutes);
app.use('/api/breach', breachRoutes);
app.use('/api/legal', legalRoutes);

// Health Check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', service: 'CyberEye Orchestration API' });
});

// Generic Error Handler
app.use((err, req, res, next) => {
  console.error('[Error]', err.message);
  res.status(err.status || 500).json({
    error: {
      message: err.message || 'Internal Server Error',
    },
  });
});

app.listen(port, () => {
  console.log(`CyberEye API running on port ${port}`);
});

module.exports = app; // Export for Vercel Serverless
