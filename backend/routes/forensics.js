const express = require('express');
const router = express.Router();
const mediaForensicsController = require('../controllers/mediaForensicsController');

router.post('/analyze-vision', mediaForensicsController.uploadMiddleware, mediaForensicsController.analyzeMedia);

module.exports = router;
