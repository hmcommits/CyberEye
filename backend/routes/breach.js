const express = require('express');
const router = express.Router();

router.get('/check-range/:prefix', async (req, res, next) => {
  try {
    const { prefix } = req.params;
    if (!prefix || prefix.length !== 5) {
      return res.status(400).json({ error: 'Prefix must be exactly 5 characters.' });
    }
    // Placeholder for Phase 6 (Password Sentinel)
    // 1. Proxy GET request to https://api.pwnedpasswords.com/range/{prefix}
    // 2. Return text response to Flutter
    res.json({ message: 'Breach range route placeholder' });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
