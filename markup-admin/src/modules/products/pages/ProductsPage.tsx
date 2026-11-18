import { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { Package, Plus, RefreshCw } from "lucide-react";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/card";
import { getCooperativeById, getCooperatives } from "@/modules/cooperatives/api/cooperatives.api";
import type { Cooperative, CooperativeListItem } from "@/modules/cooperatives/types/cooperative";
import { addProductConditions, createProduct, getInvestmentCalculationSetting, getProducts, updateInvestmentCalculationSetting, updateProduct, type CreditProductCategory, type FinancialProduct, type InvestmentCalculationMethod, type ProductCondition, type ProductType } from "../api/products.api";

const fieldClass = "w-full rounded-xl border border-white/10 bg-slate-950 px-3 py-2.5 text-white outline-none focus:border-cyan-400";
const emptyCondition = (): ProductCondition => ({ minimumAmount: 0, maximumAmount: 0, minimumTermMonths: 0, maximumTermMonths: 0, annualRate: 0, validFrom: "", validUntil: null });

export function ProductsPage() {
  const [searchParams] = useSearchParams();
  const [cooperatives, setCooperatives] = useState<CooperativeListItem[]>([]);
  const [cooperativeId, setCooperativeId] = useState<number | "">(() => {
    const requested = Number(searchParams.get("cooperativeId"));
    return Number.isInteger(requested) && requested > 0 ? requested : "";
  });
  const [products, setProducts] = useState<FinancialProduct[]>([]);
  const [selectedCooperative, setSelectedCooperative] = useState<Cooperative | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<FinancialProduct | null>(null);
  const [active, setActive] = useState(true);
  const [type, setType] = useState<ProductType>("CREDIT");
  const [creditCategory, setCreditCategory] = useState<CreditProductCategory | "">("CONSUMO");
  const [minimumAmount, setMinimumAmount] = useState("");
  const [maximumAmount, setMaximumAmount] = useState("");
  const [conditions, setConditions] = useState<ProductCondition[]>([emptyCondition()]);

  useEffect(() => { void getCooperatives(0, 1000).then((result) => setCooperatives(result.content)).catch(() => setError("No se pudieron cargar las cooperativas.")); }, []);
  useEffect(() => {
    if (!cooperativeId) { setProducts([]); setSelectedCooperative(null); return; }
    setLoading(true); setError("");
    let cancelled = false;
    void Promise.all([getProducts(cooperativeId), getCooperativeById(cooperativeId)])
      .then(([nextProducts, cooperative]) => { if (!cancelled) { setProducts(nextProducts); setSelectedCooperative(cooperative); } })
      .catch((cause) => { if (!cancelled) { setProducts([]); setSelectedCooperative(null); setError(cause instanceof Error ? cause.message : "No se pudieron cargar la cooperativa y sus productos."); } })
      .finally(() => { if (!cancelled) setLoading(false); });
    return () => { cancelled = true; };
  }, [cooperativeId]);

  async function loadProducts() {
    if (!cooperativeId) return;
    setLoading(true);
    try { setProducts(await getProducts(cooperativeId)); setError(""); }
    catch { setError("No se pudieron cargar los productos de esta cooperativa."); }
    finally { setLoading(false); }
  }

  async function saveProduct(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!cooperativeId) return;
    setLoading(true); setError("");
    try {
      if (type === "CREDIT" && !creditCategory) throw new Error("Selecciona consumo o microcrédito para este producto.");
      const request = { type, creditCategory: type === "CREDIT" ? creditCategory || null : null, name: type === "INVESTMENT" ? "Depósito a plazo fijo" : creditCategory === "MICROCREDITO" ? "Microcrédito" : "Crédito de consumo", minimumAmount: Number(minimumAmount), maximumAmount: Number(maximumAmount), active };
      if (editing) {
        await updateProduct(cooperativeId, editing.id, request);
        if (conditions.length) await addProductConditions(cooperativeId, editing.id, conditions);
      } else {
        await createProduct(cooperativeId, { ...request, conditions });
      }
      setOpen(false); setEditing(null); setConditions([emptyCondition()]);
      await loadProducts();
    } catch (cause) {
      const message = (cause as { response?: { data?: { message?: string } } })?.response?.data?.message;
      setError(message ?? "No se pudo guardar el producto. Revisa que los rangos no se solapen.");
    } finally { setLoading(false); }
  }

  function editProduct(product: FinancialProduct) {
    setEditing(product); setActive(product.active); setType(product.type); setCreditCategory(product.creditCategory ?? "");
    setMinimumAmount(String(product.minimumAmount)); setMaximumAmount(String(product.maximumAmount)); setConditions([]); setOpen(true);
  }

  function updateCondition(index: number, key: keyof ProductCondition, value: string) {
    setConditions((current) => current.map((condition, i) => i === index ? { ...condition, [key]: key === "validFrom" || key === "validUntil" ? (value ? new Date(value).toISOString() : null) : Number(value) } : condition));
  }

  function beginCreate(nextType: ProductType) {
    setEditing(null); setActive(true); setType(nextType);
    setCreditCategory(nextType === "CREDIT" ? "CONSUMO" : "");
    setMinimumAmount(""); setMaximumAmount("");
    setConditions([emptyCondition()]); setOpen(true);
  }

  return <div className="space-y-6">
    <PageHeader title="Productos financieros" subtitle="Administra el catálogo estándar y sus condiciones vigentes por cooperativa." icon={<Package size={30} />} actionLabel={cooperativeId ? "Nuevo producto" : undefined} onAction={() => { setEditing(null); setActive(true); setType("CREDIT"); setCreditCategory("CONSUMO"); setMinimumAmount(""); setMaximumAmount(""); setConditions([emptyCondition()]); setOpen(true); }} />
    <InvestmentCalculationSettingsCard />
    <Card className="border-white/10 bg-white/[0.04]"><label className="block max-w-xl text-sm text-slate-300">Cooperativa<select className={`${fieldClass} mt-2`} value={cooperativeId} onChange={(e) => setCooperativeId(e.target.value ? Number(e.target.value) : "")}><option value="">Selecciona una cooperativa</option>{cooperatives.map((coop) => <option value={coop.id} key={coop.id}>{coop.nombre} · {coop.ciudad}</option>)}</select></label></Card>
    {selectedCooperative && <Card className="border-white/10 bg-white/[0.04]"><p className="text-xs font-bold uppercase tracking-widest text-cyan-300">Información institucional</p><h2 className="mt-1 text-xl font-bold text-white">{selectedCooperative.nombre}</h2><p className="mt-1 text-sm text-slate-300">{[selectedCooperative.direccion, selectedCooperative.ciudad, selectedCooperative.provincia].filter(Boolean).join(" · ")}</p><p className="mt-1 text-sm text-slate-400">{selectedCooperative.telefono || "Sin teléfono registrado"}{selectedCooperative.paginaWeb ? ` · ${selectedCooperative.paginaWeb}` : ""}</p></Card>}
    {error && <div className="rounded-xl border border-red-400/30 bg-red-500/10 p-3 text-sm text-red-200">{error}</div>}
    {cooperativeId && <div className="flex items-center justify-between"><p className="text-sm text-slate-400">{products.length} productos configurados</p><button className="inline-flex items-center gap-2 text-sm text-cyan-300" onClick={() => void loadProducts()}><RefreshCw size={16} />Actualizar</button></div>}
    {loading && <div className="rounded-2xl bg-white/5 p-8 text-center text-slate-300">Cargando…</div>}
    {!loading && !error && cooperativeId && products.length === 0 && <div className="rounded-2xl border border-dashed border-white/15 p-8 text-center"><h2 className="text-lg font-bold text-white">Esta cooperativa todavía no tiene productos financieros configurados</h2><p className="mt-2 text-sm text-slate-400">Puedes crear productos cuando la cooperativa confirme sus condiciones.</p><div className="mt-5 flex flex-wrap justify-center gap-3"><button type="button" onClick={() => beginCreate("CREDIT")} className="rounded-xl bg-cyan-400 px-4 py-2.5 font-semibold text-slate-950">Crear producto de crédito</button><button type="button" onClick={() => beginCreate("INVESTMENT")} className="rounded-xl border border-cyan-300/40 px-4 py-2.5 font-semibold text-cyan-200">Crear producto de inversión</button></div></div>}
    <div className="grid gap-4 lg:grid-cols-2">{products.map((product) => <Card key={product.id} className="border-white/10 bg-white/[0.04]"><div className="flex items-start justify-between"><div><span className="text-xs font-bold uppercase tracking-wider text-cyan-300">{product.type === "CREDIT" ? (product.creditCategory === "MICROCREDITO" ? "Microcrédito" : product.creditCategory === "CONSUMO" ? "Crédito de consumo" : "Crédito · categoría pendiente") : "Depósito a plazo fijo"}</span><h2 className="mt-1 text-xl font-semibold text-white">{product.name}</h2><p className="mt-1 text-sm text-slate-400">{product.description}</p></div><span className={`rounded-full px-2 py-1 text-xs ${product.active ? "bg-emerald-500/15 text-emerald-300" : "bg-slate-500/15 text-slate-300"}`}>{product.active ? "Activo" : "Pausado"}</span></div><p className="mt-4 text-sm text-slate-300">Monto: ${Number(product.minimumAmount).toLocaleString("es-EC")} – ${Number(product.maximumAmount).toLocaleString("es-EC")}</p><div className="mt-4 space-y-2">{(product.conditions ?? []).map((condition) => <div key={condition.id} className="rounded-xl border border-white/10 bg-black/20 p-3 text-sm"><p className="font-medium text-white">{condition.annualRate}% anual · {condition.minimumTermMonths}–{condition.maximumTermMonths} meses</p><p className="mt-1 text-xs text-slate-400">${condition.minimumAmount.toLocaleString("es-EC")} – ${condition.maximumAmount.toLocaleString("es-EC")} · desde {new Date(condition.validFrom).toLocaleDateString("es-EC")}{condition.validUntil ? ` hasta ${new Date(condition.validUntil).toLocaleDateString("es-EC")}` : " · sin vencimiento"}</p></div>)}{(!product.conditions || product.conditions.length === 0) && <p className="text-sm text-amber-200">Sin condiciones vigentes; agrega tasas y plazos antes de ofrecerlo.</p>}</div><button type="button" onClick={() => editProduct(product)} className="mt-4 rounded-lg border border-white/10 px-3 py-2 text-xs text-cyan-200">Editar producto / agregar condiciones</button></Card>)}</div>
    {open && <div className="fixed inset-0 z-50 grid place-items-center overflow-y-auto bg-black/70 p-4"><form onSubmit={saveProduct} className="my-8 max-h-[90vh] w-full max-w-3xl overflow-y-auto rounded-3xl border border-white/10 bg-slate-900 p-6"><div className="flex items-center justify-between"><h2 className="text-xl font-bold text-white">Configurar producto</h2><button type="button" onClick={() => setOpen(false)} className="text-slate-400">Cerrar</button></div><div className="mt-5 grid gap-4 sm:grid-cols-2"><label className="text-sm text-slate-300">Tipo<select className={`${fieldClass} mt-1`} value={type} onChange={(e) => { const next = e.target.value as ProductType; setType(next); setCreditCategory(next === "CREDIT" ? "CONSUMO" : ""); }}><option value="CREDIT">Crédito</option><option value="INVESTMENT">Depósito a plazo fijo</option></select></label>{type === "CREDIT" && <label className="text-sm text-slate-300">Tipo de crédito<select required className={`${fieldClass} mt-1`} value={creditCategory} onChange={(e) => setCreditCategory(e.target.value as CreditProductCategory | "")}><option value="">Selecciona el tipo</option><option value="CONSUMO">Consumo</option><option value="MICROCREDITO">Microcrédito</option></select></label>}<label className="text-sm text-slate-300">Monto mínimo<input required type="number" min="0.01" step="0.01" className={`${fieldClass} mt-1`} value={minimumAmount} onChange={(e) => setMinimumAmount(e.target.value)} /></label><label className="text-sm text-slate-300">Monto máximo<input required type="number" min="0.01" step="0.01" className={`${fieldClass} mt-1`} value={maximumAmount} onChange={(e) => setMaximumAmount(e.target.value)} /></label></div>
      <div className="mt-6"><div className="mb-3 flex items-center justify-between"><h3 className="font-semibold text-white">Rangos, plazos y tasas</h3><button type="button" className="inline-flex items-center gap-1 text-sm text-cyan-300" onClick={() => setConditions((current) => [...current, emptyCondition()])}><Plus size={16} />Agregar rango</button></div><div className="space-y-4">{conditions.map((condition, index) => <div key={index} className="grid gap-3 rounded-2xl border border-white/10 p-4 sm:grid-cols-2 lg:grid-cols-3">{([ ["minimumAmount", "Monto desde"], ["maximumAmount", "Monto hasta"], ["minimumTermMonths", "Meses desde"], ["maximumTermMonths", "Meses hasta"], ["annualRate", "Tasa anual (%)"] ] as const).map(([key, label]) => <label key={key} className="text-xs text-slate-400">{label}<input required type="number" min={key === "minimumTermMonths" || key === "maximumTermMonths" ? "1" : "0.01"} step={key === "minimumTermMonths" || key === "maximumTermMonths" ? "1" : "0.01"} className={`${fieldClass} mt-1`} value={condition[key]} onChange={(e) => updateCondition(index, key, e.target.value)} /></label>)}<label className="text-xs text-slate-400">Vigente desde<input required type="datetime-local" className={`${fieldClass} mt-1`} value={condition.validFrom.slice(0, 16)} onChange={(e) => updateCondition(index, "validFrom", e.target.value)} /></label><label className="text-xs text-slate-400">Vigente hasta (opcional)<input type="datetime-local" className={`${fieldClass} mt-1`} value={condition.validUntil?.slice(0, 16) ?? ""} onChange={(e) => updateCondition(index, "validUntil", e.target.value)} /></label>{conditions.length > 1 && <button type="button" onClick={() => setConditions((current) => current.filter((_, i) => i !== index))} className="self-end text-left text-xs text-red-300">Quitar rango</button>}</div>)}</div></div>
      {error && <p className="mt-4 text-sm text-red-300">{error}</p>}<div className="mt-6 flex justify-end gap-3"><button type="button" onClick={() => setOpen(false)} className="rounded-xl border border-white/10 px-4 py-2 text-slate-300">Cancelar</button><button disabled={loading} className="rounded-xl bg-cyan-400 px-5 py-2 font-semibold text-slate-950 disabled:opacity-50">Guardar producto</button></div></form></div>}
  </div>;
}

function InvestmentCalculationSettingsCard() {
  const [method, setMethod] = useState<InvestmentCalculationMethod>("UNSPECIFIED");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  useEffect(() => {
    void getInvestmentCalculationSetting()
      .then((setting) => setMethod(setting.calculationMethod))
      .catch(() => setError("No se pudo cargar la configuración central de ganancias."))
      .finally(() => setLoading(false));
  }, []);

  async function save() {
    setSaving(true); setError(""); setNotice("");
    try {
      const setting = await updateInvestmentCalculationSetting(method);
      setMethod(setting.calculationMethod);
      setNotice("Método central actualizado. Las solicitudes anteriores conservan su cálculo original.");
    } catch (cause) {
      const message = (cause as { response?: { data?: { message?: string } } })?.response?.data?.message;
      setError(message ?? "No se pudo guardar el método central.");
    } finally { setSaving(false); }
  }

  return <Card className="border-white/10 bg-white/[0.04]">
    <div className="grid gap-4 md:grid-cols-[1fr_auto] md:items-end">
      <label className="block max-w-xl text-sm text-slate-300">Método central de cálculo para inversiones
        <select disabled={loading} className={`${fieldClass} mt-2`} value={method} onChange={(event) => setMethod(event.target.value as InvestmentCalculationMethod)}>
          <option value="UNSPECIFIED">Sin método seleccionado</option>
          <option value="SIMPLE_INTEREST">Interés simple anual</option>
          <option value="MONTHLY_COMPOUNDING">Capitalización mensual</option>
        </select>
      </label>
      <button type="button" disabled={loading || saving} onClick={() => void save()} className="rounded-xl bg-cyan-400 px-4 py-2.5 font-semibold text-slate-950 disabled:opacity-50">{saving ? "Guardando…" : "Guardar método"}</button>
    </div>
    <p className="mt-3 max-w-3xl text-xs leading-5 text-slate-400">Esta opción la administra DINEROP y se aplica a las nuevas ofertas de depósito a plazo fijo. La tasa se interpreta como nominal anual; «Sin método seleccionado» mantiene las estimaciones vacías cuando no existe un método legado en el producto.</p>
    {error && <p role="alert" className="mt-3 text-sm text-red-300">{error}</p>}
    {notice && <p role="status" className="mt-3 text-sm text-emerald-300">{notice}</p>}
  </Card>;
}
