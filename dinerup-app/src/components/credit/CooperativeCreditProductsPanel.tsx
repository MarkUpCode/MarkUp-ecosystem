import { useEffect, useMemo, useState } from "react";
import { getCooperativeCreditProducts, saveCooperativeCreditProduct, type FinancialProduct } from "../../api/investments.api";
import { getErrorMessage } from "../../api/errors";

type CreditCategory = "CONSUMO" | "MICROCREDITO";
type CreditRule = {
  id: string;
  minimumAmount: string;
  maximumAmount: string;
  minimumTermMonths: string;
  maximumTermMonths: string;
  annualRate: string;
};
const categories: Array<{ id: CreditCategory; title: string; description: string }> = [
  { id: "CONSUMO", title: "Crédito de consumo", description: "Financiamiento para necesidades personales de consumo." },
  { id: "MICROCREDITO", title: "Microcrédito", description: "Financiamiento para actividades productivas y pequeños negocios." },
];
const emptyRule = (): CreditRule => ({ id: crypto.randomUUID?.() ?? `${Date.now()}-${Math.random()}`, minimumAmount: "", maximumAmount: "", minimumTermMonths: "1", maximumTermMonths: "12", annualRate: "" });

export default function CooperativeCreditProductsPanel() {
  const [products, setProducts] = useState<FinancialProduct[]>([]);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [editingCategory, setEditingCategory] = useState<CreditCategory | null>(null);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [minimum, setMinimum] = useState("");
  const [maximum, setMaximum] = useState("");
  const [active, setActive] = useState(true);
  const [rules, setRules] = useState<CreditRule[]>([emptyRule()]);

  const refresh = async () => setProducts(await getCooperativeCreditProducts());
  useEffect(() => {
    setLoading(true);
    void refresh().catch((cause) => setError(getErrorMessage(cause, "No se pudieron cargar los productos de crédito.")))
      .finally(() => setLoading(false));
  }, []);

  const validation = useMemo(() => {
    if (!editingCategory) return "";
    if (!(Number(minimum) > 0) || Number(maximum) < Number(minimum)) return "Revisa el monto mínimo y máximo del producto.";
    if (!rules.length) return "Agrega al menos una condición financiera.";
    for (const [index, rule] of rules.entries()) {
      const amountMin = Number(rule.minimumAmount);
      const amountMax = Number(rule.maximumAmount);
      const termMin = Number(rule.minimumTermMonths);
      const termMax = Number(rule.maximumTermMonths);
      const rate = Number(rule.annualRate);
      if (!(amountMin >= Number(minimum) && amountMax <= Number(maximum) && amountMax >= amountMin)) return `Revisa los montos de la condición ${index + 1}; deben estar dentro del rango del producto.`;
      if (!Number.isInteger(termMin) || !Number.isInteger(termMax) || termMin < 1 || termMax > 600 || termMax < termMin) return `Revisa los plazos de la condición ${index + 1}.`;
      if (!(rate > 0 && rate <= 100)) return `Ingresa una tasa anual válida en la condición ${index + 1}.`;
    }
    for (let i = 0; i < rules.length; i += 1) for (let j = i + 1; j < rules.length; j += 1) {
      const a = rules[i]; const b = rules[j];
      const amountOverlap = Number(a.minimumAmount) <= Number(b.maximumAmount) && Number(b.minimumAmount) <= Number(a.maximumAmount);
      const termOverlap = Number(a.minimumTermMonths) <= Number(b.maximumTermMonths) && Number(b.minimumTermMonths) <= Number(a.maximumTermMonths);
      if (amountOverlap && termOverlap) return "Las condiciones no pueden superponerse en monto y plazo.";
    }
    return "";
  }, [editingCategory, minimum, maximum, rules]);

  const beginCreate = (category: CreditCategory) => {
    setEditingCategory(category); setEditingId(null); setMinimum(""); setMaximum(""); setActive(true); setRules([emptyRule()]); setError("");
  };
  const beginEdit = (product: FinancialProduct) => {
    if (product.creditCategory !== "CONSUMO" && product.creditCategory !== "MICROCREDITO") return;
    setEditingCategory(product.creditCategory); setEditingId(product.id); setMinimum(String(product.minimumAmount)); setMaximum(String(product.maximumAmount)); setActive(product.active);
    setRules(product.conditions.map((condition) => ({ id: String(condition.id), minimumAmount: String(condition.minimumAmount), maximumAmount: String(condition.maximumAmount), minimumTermMonths: String(condition.minimumTermMonths), maximumTermMonths: String(condition.maximumTermMonths), annualRate: String(condition.annualRate) })));
    setError("");
  };
  const run = async (operation: () => Promise<unknown>) => {
    setBusy(true); setError("");
    try { await operation(); await refresh(); }
    catch (cause) { setError(getErrorMessage(cause, "No se pudo guardar la configuración.")); }
    finally { setBusy(false); }
  };
  const save = () => editingCategory && run(async () => {
    await saveCooperativeCreditProduct({
      type: "CREDIT", creditCategory: editingCategory,
      name: editingCategory === "MICROCREDITO" ? "Microcrédito" : "Crédito de consumo",
      minimumAmount: Number(minimum), maximumAmount: Number(maximum), active,
      conditions: rules.map((rule) => ({ minimumAmount: Number(rule.minimumAmount), maximumAmount: Number(rule.maximumAmount), minimumTermMonths: Number(rule.minimumTermMonths), maximumTermMonths: Number(rule.maximumTermMonths), annualRate: Number(rule.annualRate), validFrom: new Date().toISOString(), validUntil: null })),
    }, editingId ?? undefined);
    setEditingCategory(null);
  });
  const toggleProduct = (product: FinancialProduct) => product.creditCategory && run(() => saveCooperativeCreditProduct({
    type: "CREDIT", creditCategory: product.creditCategory, name: product.creditCategory === "MICROCREDITO" ? "Microcrédito" : "Crédito de consumo",
    minimumAmount: product.minimumAmount, maximumAmount: product.maximumAmount, active: !product.active,
  }, product.id));

  return <section className="space-y-6">
    <header><p className="text-xs font-bold uppercase tracking-widest text-emerald-700">Catálogo estándar</p><h2 className="mt-1 text-2xl font-extrabold text-[#173b57]">Créditos</h2><p className="mt-2 text-sm text-slate-600">Activa los tipos de crédito que ofreces y define los rangos de monto, plazos y tasas. Cada tipo se configura una sola vez.</p></header>
    {error && <p role="alert" className="rounded-xl bg-rose-50 p-3 text-sm text-rose-700">{error}</p>}
    {loading ? <p className="rounded-xl border bg-white p-5 text-sm text-slate-500">Cargando configuración…</p> : <div className="grid gap-4 lg:grid-cols-2">{categories.map((category) => {
      const product = products.find((item) => item.creditCategory === category.id);
      return <article key={category.id} className="rounded-2xl border bg-white p-5 shadow-sm"><div className="flex items-start justify-between gap-3"><div><h3 className="font-extrabold text-[#173b57]">{category.title}</h3><p className="mt-1 text-sm text-slate-500">{category.description}</p></div>{product && <span className={`rounded-full px-3 py-1 text-xs font-bold ${product.active ? "bg-emerald-50 text-emerald-700" : "bg-slate-100 text-slate-500"}`}>{product.active ? "Activo" : "Inactivo"}</span>}</div>
        {product ? <><p className="mt-4 text-sm text-slate-600">Monto: ${product.minimumAmount.toLocaleString("es-EC")}–${product.maximumAmount.toLocaleString("es-EC")} · {product.conditions.length} condiciones vigentes</p><div className="mt-3 space-y-2">{product.conditions.map((condition) => <p key={condition.id} className="rounded-lg bg-slate-50 p-3 text-sm">${condition.minimumAmount.toLocaleString("es-EC")}–${condition.maximumAmount.toLocaleString("es-EC")} · {condition.minimumTermMonths}–{condition.maximumTermMonths} meses · {condition.annualRate}% anual</p>)}</div><div className="mt-4 flex flex-wrap gap-2"><button type="button" onClick={() => beginEdit(product)} className="rounded-lg border px-3 py-2 text-sm font-bold">Editar condiciones</button><button type="button" disabled={busy} onClick={() => void toggleProduct(product)} className="rounded-lg border px-3 py-2 text-sm font-bold disabled:opacity-50">{product.active ? "Desactivar" : "Activar"}</button></div></> : <button type="button" onClick={() => beginCreate(category.id)} className="mt-4 rounded-lg bg-emerald-700 px-4 py-2.5 text-sm font-bold text-white">Configurar {category.title.toLowerCase()}</button>}
      </article>;
    })}</div>}
    {editingCategory && <div className="fixed inset-0 z-[70] grid place-items-center overflow-y-auto bg-slate-950/50 p-3"><section className="my-6 max-h-[92vh] w-full max-w-3xl overflow-y-auto rounded-2xl bg-white p-5 shadow-2xl sm:p-7"><div className="flex items-start justify-between gap-3"><div><p className="text-xs font-bold uppercase tracking-widest text-emerald-700">{editingId ? "Editar" : "Configurar"}</p><h3 className="mt-1 text-xl font-extrabold">{categories.find((item) => item.id === editingCategory)?.title}</h3></div><button type="button" onClick={() => setEditingCategory(null)} className="rounded-lg border px-3 py-2">Cerrar</button></div>
      <div className="mt-5 grid gap-3 sm:grid-cols-2"><Field label="Monto mínimo del producto (USD)" value={minimum} onChange={setMinimum} /><Field label="Monto máximo del producto (USD)" value={maximum} onChange={setMaximum} /><label className="flex items-center gap-2 text-sm font-semibold"><input type="checkbox" checked={active} onChange={(event) => setActive(event.target.checked)} />Producto activo</label></div>
      <div className="mt-6"><div className="mb-3 flex items-center justify-between gap-3"><div><h4 className="font-extrabold">Condiciones financieras</h4><p className="text-xs text-slate-500">Agrega condiciones sin crear productos duplicados.</p></div><button type="button" onClick={() => setRules((items) => [...items, emptyRule()])} className="rounded-lg border px-3 py-2 text-xs font-bold">Agregar condición</button></div><div className="space-y-3">{rules.map((rule, index) => <article key={rule.id} className="grid gap-3 rounded-xl border p-4 sm:grid-cols-2 lg:grid-cols-3">{([ ["minimumAmount", "Monto desde (USD)"], ["maximumAmount", "Monto hasta (USD)"], ["minimumTermMonths", "Plazo desde (meses)"], ["maximumTermMonths", "Plazo hasta (meses)"], ["annualRate", "Tasa anual (%)"] ] as const).map(([key, label]) => <Field key={key} label={label} type="number" value={rule[key]} onChange={(value) => setRules((items) => items.map((item) => item.id === rule.id ? { ...item, [key]: value } : item))} />)}{rules.length > 1 && <button type="button" onClick={() => setRules((items) => items.filter((item) => item.id !== rule.id))} className="text-left text-xs font-bold text-rose-700">Eliminar condición {index + 1}</button>}</article>)}</div></div>
      {validation && <p className="mt-4 rounded-lg bg-amber-50 p-3 text-sm text-amber-800">{validation}</p>}<div className="mt-6 flex justify-end gap-2"><button type="button" onClick={() => setEditingCategory(null)} className="rounded-lg border px-4 py-2.5 font-bold">Cancelar</button><button type="button" disabled={busy || Boolean(validation)} onClick={() => void save()} className="rounded-lg bg-emerald-700 px-4 py-2.5 font-bold text-white disabled:opacity-50">{busy ? "Guardando…" : "Guardar"}</button></div>
    </section></div>}
  </section>;
}

function Field({ label, value, onChange, type = "number" }: { label: string; value: string; onChange: (value: string) => void; type?: string }) {
  return <label className="block text-sm font-semibold text-slate-700">{label}<input type={type} value={value} onChange={(event) => onChange(event.target.value)} className="mt-1 w-full rounded-lg border p-3 font-normal" /></label>;
}
