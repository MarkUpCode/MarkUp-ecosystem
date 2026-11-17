import { useState, type FormEvent } from "react";
import { createProduct, type FinancialProductRequest, type ProductCondition, type ProductType } from "@/modules/products/api/products.api";
import type { CreateCooperativeRequest } from "../types/cooperative";

type ProductDraft = {
  type: ProductType; creditCategory: "CONSUMO" | "MICROCREDITO" | ""; name: string; description: string; min: string; max: string;
  termMin: string; termMax: string; rate: string; from: string; until: string;
};
const draftProduct = (type: ProductType): ProductDraft => ({ type, creditCategory: type === "CREDIT" ? "CONSUMO" : "", name: "", description: "", min: "", max: "", termMin: "", termMax: "", rate: "", from: "", until: "" });
const input = "mt-1 w-full rounded-xl border border-white/10 bg-slate-950 px-3 py-2.5 text-white";

export function CooperativeWizard({ open, onClose, onCreate }: {
  open: boolean; onClose: () => void;
  onCreate: (request: CreateCooperativeRequest) => Promise<{ id: number } | undefined>;
}) {
  const [step, setStep] = useState(0);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [pendingCooperative, setPendingCooperative] = useState<{ id: number } | null>(null);
  const [pendingProductIndex, setPendingProductIndex] = useState(0);
  const [form, setForm] = useState<CreateCooperativeRequest>({ nombre: "", ciudad: "", provincia: "", direccion: "", telefono: "", paginaWeb: "", logoUrl: "", calificacion: null, montoMaximoCredito: 0 });
  const [credit, setCredit] = useState<ProductDraft[]>([]);
  const [investment, setInvestment] = useState<ProductDraft[]>([]);
  if (!open) return null;
  const steps = ["Información institucional", "Productos de crédito", "Productos de inversión", "Revisión y confirmación"];
  const list = (type: ProductType) => type === "CREDIT" ? credit : investment;
  const setList = (type: ProductType, fn: (items: ProductDraft[]) => ProductDraft[]) => (type === "CREDIT" ? setCredit : setInvestment)(fn);
  const editProduct = (type: ProductType, index: number, key: keyof ProductDraft, value: string) => setList(type, (items) => items.map((p, i) => i === index ? { ...p, [key]: value } : p));

  function nextStep() {
    setError("");
    const rows = step === 1 ? credit : step === 2 ? investment : [];
    const invalid = rows.some((p) => {
      const min = Number(p.min); const max = Number(p.max);
      const termMin = Number(p.termMin); const termMax = Number(p.termMax); const rate = Number(p.rate);
      return !p.name.trim() || (p.type === "CREDIT" && !p.creditCategory) || !(min > 0) || max < min || !(termMin > 0) || !Number.isInteger(termMin) || !Number.isInteger(termMax) || termMax < termMin || !(rate > 0 && rate <= 100) || !p.from || Number.isNaN(Date.parse(p.from)) || (p.until && Date.parse(p.until) <= Date.parse(p.from));
    });
    if (invalid) { setError("Completa cada producto con montos, plazos, tasa y vigencia válidos, o quítalo para continuar."); return; }
    setStep((current) => current + 1);
  }

  async function submit(event: FormEvent) {
    event.preventDefault(); setBusy(true); setError("");
    try {
      const maxCredit = credit.length ? Math.max(...credit.map((p) => Number(p.max))) : 0;
      const cooperative = pendingCooperative ?? await onCreate({ ...form, montoMaximoCredito: maxCredit });
      if (!cooperative) throw new Error("No se recibió la cooperativa creada.");
      setPendingCooperative(cooperative);
      const drafts = [...credit, ...investment];
      for (let index = pendingProductIndex; index < drafts.length; index += 1) {
        const p = drafts[index];
        const min = Number(p.min); const max = Number(p.max);
        const condition: ProductCondition = { minimumAmount: min, maximumAmount: max, minimumTermMonths: Number(p.termMin), maximumTermMonths: Number(p.termMax), annualRate: Number(p.rate), validFrom: new Date(p.from).toISOString(), validUntil: p.until ? new Date(p.until).toISOString() : null };
        const request: FinancialProductRequest = { type: p.type, creditCategory: p.type === "CREDIT" ? p.creditCategory || null : null, name: p.name, description: p.description, minimumAmount: min, maximumAmount: max, active: true, conditions: [condition] };
        await createProduct(cooperative.id, request);
        setPendingProductIndex(index + 1);
      }
      setPendingCooperative(null); setPendingProductIndex(0); setStep(0); setCredit([]); setInvestment([]); onClose();
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "No se pudo guardar la cooperativa y sus productos.");
    } finally { setBusy(false); }
  }

  const productsForm = (type: ProductType) => <div className="space-y-4">
    <button type="button" onClick={() => setList(type, (items) => [...items, draftProduct(type)])} className="rounded-xl border border-cyan-400/30 px-4 py-2 text-sm text-cyan-200">+ Agregar producto</button>
    {list(type).map((p, i) => <div key={i} className="grid gap-3 rounded-2xl border border-white/10 p-4 sm:grid-cols-2 lg:grid-cols-3">
      {type === "CREDIT" && <label className="text-xs text-slate-400">Tipo de crédito<select required className={input} value={p.creditCategory} onChange={(e) => setList(type, (items) => items.map((item, index) => index === i ? { ...item, creditCategory: e.target.value as ProductDraft["creditCategory"] } : item))}><option value="">Selecciona</option><option value="CONSUMO">Consumo</option><option value="MICROCREDITO">Microcrédito</option></select></label>}
      {([["name","Nombre"],["description","Descripción"],["min","Monto mínimo"],["max","Monto máximo"],["termMin","Plazo desde (meses)"],["termMax","Plazo hasta (meses)"],["rate","Tasa anual (%)"]] as const).map(([key,label]) => <label key={key} className="text-xs text-slate-400">{label}<input required type={key === "name" || key === "description" ? "text" : "number"} min={key === "termMin" || key === "termMax" ? 1 : 0.01} step={key === "termMin" || key === "termMax" ? "1" : "0.01"} className={input} value={p[key]} onChange={(e) => editProduct(type,i,key,e.target.value)} /></label>)}
      <label className="text-xs text-slate-400">Vigente desde<input required type="datetime-local" className={input} value={p.from} onChange={(e) => editProduct(type,i,"from",e.target.value)} /></label>
      <label className="text-xs text-slate-400">Vigente hasta (opcional)<input type="datetime-local" className={input} value={p.until} onChange={(e) => editProduct(type,i,"until",e.target.value)} /></label>
      <button type="button" className="text-left text-xs text-red-300" onClick={() => setList(type, (items) => items.filter((_, index) => index !== i))}>Quitar producto</button>
    </div>)}
  </div>;

  return <div className="fixed inset-0 z-50 grid place-items-center overflow-y-auto bg-black/70 p-4"><form onSubmit={submit} className="my-6 max-h-[92vh] w-full max-w-3xl overflow-y-auto rounded-3xl border border-white/10 bg-slate-900 p-6 text-white">
    <div className="flex justify-between"><div><p className="text-xs uppercase tracking-widest text-cyan-300">Paso {step + 1} de 4</p><h2 className="mt-1 text-2xl font-bold">{steps[step]}</h2></div><button type="button" onClick={onClose} className="text-slate-400">Cerrar</button></div><div className="mt-4 h-1 rounded bg-white/10"><div className="h-1 rounded bg-cyan-400" style={{ width: `${(step + 1) * 25}%` }} /></div>
    {step === 0 && <div className="mt-6 grid gap-4 sm:grid-cols-2">{([["nombre","Nombre"],["ciudad","Ciudad"],["provincia","Provincia"],["direccion","Dirección"],["telefono","Teléfono"],["paginaWeb","Página web"],["logoUrl","URL del logo"]] as const).map(([key,label]) => <label key={key} className="text-sm text-slate-300">{label}<input required={key === "nombre" || key === "ciudad" || key === "provincia"} className={input} value={form[key]} onChange={(e) => setForm((current) => ({ ...current, [key]: e.target.value }))} /></label>)}<label className="text-sm text-slate-300">Calificación registrada (opcional)<input type="number" min="0" max="5" step="0.1" className={input} value={form.calificacion ?? ""} onChange={(e) => setForm((current) => ({ ...current, calificacion: e.target.value ? Number(e.target.value) : null }))} /></label></div>}
    {step === 1 && <div className="mt-6"><p className="mb-4 text-sm text-slate-400">Agrega solo condiciones confirmadas por la cooperativa. Puedes continuar sin configurar productos.</p>{productsForm("CREDIT")}</div>}
    {step === 2 && <div className="mt-6"><p className="mb-4 text-sm text-slate-400">Los productos de inversión son opcionales y pueden configurarse después.</p>{productsForm("INVESTMENT")}</div>}
    {step === 3 && <div className="mt-6 space-y-4"><div className="rounded-2xl border border-white/10 p-4"><h3 className="font-semibold">{form.nombre}</h3><p className="mt-1 text-sm text-slate-400">{form.ciudad}, {form.provincia} · {form.direccion || "Sin dirección"}</p></div><p className="text-sm text-slate-300">{credit.length} productos de crédito · {investment.length} productos de inversión.</p><p className="text-sm text-slate-400">Se guardarán únicamente las tasas y condiciones ingresadas.</p></div>}
    {error && <p className="mt-4 rounded-xl bg-red-500/10 p-3 text-sm text-red-200">{error}</p>}
    <div className="mt-7 flex justify-between"><button type="button" disabled={step === 0 || busy} onClick={() => setStep((s) => s - 1)} className="rounded-xl border border-white/10 px-4 py-2 disabled:opacity-40">Anterior</button>{step < 3 ? <button type="button" disabled={busy || (step === 0 && (!form.nombre || !form.ciudad || !form.provincia))} onClick={nextStep} className="rounded-xl bg-cyan-400 px-5 py-2 font-semibold text-slate-950">Siguiente</button> : <button disabled={busy} className="rounded-xl bg-cyan-400 px-5 py-2 font-semibold text-slate-950">{busy ? "Guardando…" : "Crear cooperativa"}</button>}</div>
  </form></div>;
}
