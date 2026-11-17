import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import NewInvestmentModal, { type PublicDraft } from "../components/investment/NewInvestmentModal";

const KEY = "dinerop_pending_investment_v1";
const TTL = 30 * 60 * 1000;

export default function PublicInvestments() {
  const navigate = useNavigate();
  const [draft, setDraft] = useState<PublicDraft | null>(null);
  useEffect(() => {
    try {
      const raw = sessionStorage.getItem(KEY);
      if (!raw) return;
      const saved = JSON.parse(raw) as PublicDraft;
      if (Date.now() - saved.savedAt > TTL || saved.savedAt > Date.now() + 60_000) sessionStorage.removeItem(KEY);
      else setDraft(saved);
    } catch { sessionStorage.removeItem(KEY); }
  }, []);
  const requireAccount = (next: PublicDraft) => {
    sessionStorage.setItem(KEY, JSON.stringify(next));
    navigate("/login?returnTo=%2Finvestments");
  };
  return <NewInvestmentModal open onClose={() => navigate("/login")} onSubmit={() => {}} onRequestAuthentication={requireAccount} initialDraft={draft} />;
}
