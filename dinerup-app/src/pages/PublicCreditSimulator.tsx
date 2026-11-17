import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { getErrorMessage } from "../api/errors";
import { getPublicCreditOffers, type CreditCategory, type PublicCreditOffer } from "../api/creditSimulator.api";
import PublicCreditRequestModal from "../components/credit/PublicCreditRequestModal";

export default function PublicCreditSimulator() {
  const navigate = useNavigate();
  const [category, setCategory] = useState<CreditCategory>("CONSUMO");
  const [amount, setAmount] = useState("");
  const [term, setTerm] = useState("12");
  const [offers, setOffers] = useState<PublicCreditOffer[]>([]);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [application, setApplication] = useState(false);
  const numericAmount = Number(amount);

  const compare = async (event: React.FormEvent) => {
    event.preventDefault(); setLoading(true); setError(""); setOffers([]);
    try {
      const result = await getPublicCreditOffers(category, numericAmount, Number(term));
      setOffers([...(result ?? [])].sort((a, b) => b.annualRate - a.annualRate));
      if (!result?.length) setError("No hay productos vigentes que coincidan con ese monto y plazo.");
    } catch (cause) { setError(getErrorMessage(cause, "No se pudieron consultar las ofertas actuales.")); }
    finally { setLoading(false); }
  };

  return <main className="min-h-screen bg-slate-50 px-4 py-8 text-slate-900 sm:px-8"><div className="mx-auto max-w-4xl"><button onClick={() => navigate("/")} className="text-sm font-bold text-emerald-800">← Volver</button><header className="mt-6"><p className="text-xs font-bold uppercase tracking-widest text-emerald-700">Simulador</p><h1 className="mt-1 text-3xl font-extrabold text-[#173b57]">Explora opciones de crédito</h1><p className="mt-2 max-w-2xl text-sm leading-6 text-slate-600">Comparamos las condiciones publicadas por cooperativas. Esta consulta no comparte tus datos ni representa una aprobación.</p></header>
    <form onSubmit={(event) => void compare(event)} className="mt-6 grid gap-4 rounded-2xl border bg-white p-5 shadow-sm sm:grid-cols-3"><label className="text-sm font-semibold">Tipo<select value={category} onChange={(e) => setCategory(e.target.value as CreditCategory)} className="mt-1 w-full rounded-lg border p-3"><option value="CONSUMO">Consumo</option><option value="MICROCREDITO">Microcrédito</option></select></label><label className="text-sm font-semibold">Monto solicitado (USD)<input required type="number" min="0.01" step="0.01" value={amount} onChange={(e) => setAmount(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label><label className="text-sm font-semibold">Plazo<select value={term} onChange={(e) => setTerm(e.target.value)} className="mt-1 w-full rounded-lg border p-3">{[6,12,18,24,36,48,60].map((month) => <option key={month} value={month}>{month} meses</option>)}</select></label><button disabled={loading || !(numericAmount > 0)} className="rounded-lg bg-emerald-700 px-4 py-3 font-bold text-white disabled:opacity-50 sm:col-span-3">{loading ? "Consultando…" : "Comparar cooperativas"}</button></form>
    {error && <p role="status" className="mt-4 rounded-xl bg-amber-50 p-4 text-sm text-amber-900">{error}</p>}
    <section className="mt-6 space-y-3">{offers.map((offer) => <article key={`${offer.cooperativeId}-${offer.productId}`} className="rounded-2xl border bg-white p-5 shadow-sm"><div className="flex flex-wrap items-start justify-between gap-3"><div><p className="text-xs font-bold uppercase tracking-wide text-slate-500">{offer.cooperativeName}</p><h2 className="mt-1 text-lg font-extrabold">{offer.productName}</h2><p className="text-sm text-slate-600">{offer.creditCategory === "CONSUMO" ? "Crédito de consumo" : "Microcrédito"} · ${offer.amount.toLocaleString("es-EC", { minimumFractionDigits: 2 })} · {offer.termMonths} meses</p></div><strong className="rounded-full bg-emerald-50 px-3 py-1.5 text-emerald-800">{offer.annualRate.toFixed(2)}% anual</strong></div>{offer.description && <p className="mt-3 text-sm text-slate-600">{offer.description}</p>}<p className="mt-2 text-xs text-slate-500">{offer.conditions} La tasa y aprobación final dependen de la evaluación de la cooperativa.</p><button onClick={() => setApplication(true)} className="mt-4 rounded-lg border border-emerald-700 px-4 py-2 text-sm font-bold text-emerald-800">Continuar con solicitud</button></article>)}</section>
    </div><PublicCreditRequestModal open={application} onClose={() => setApplication(false)} type="CREDITO" initialCredit={{ amount: numericAmount, termMonths: Number(term), creditType: category }} /></main>;
}
