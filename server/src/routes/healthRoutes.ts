import { Router } from "express";

const router = Router();

// check health
router.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

export default router;
