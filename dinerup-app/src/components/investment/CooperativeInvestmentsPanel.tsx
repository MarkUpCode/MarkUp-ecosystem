import { useEffect, useMemo, useState } from "react";
import { acceptInvestmentRequest, addInvestmentRate, getCooperativeInvestmentProducts, getCooperativeInvestmentRequests, saveCooperativeInvestmentProduct, updateInvestmentRequest, type FinancialProduct, type InvestmentRequest } from "../../api/investments.api";
import { getErrorMessage } from "../../api/errors";

type RateRange = { id: string; minimum: string; maximum: string; rates: Record<number, string> };
type Requirement = { description: string; mandatory: boolean };
const suggestedTerms = [3, 6, 9, 12, 18, 24];
const blankRange = (minimum = "", maximum = ""): RateRange => ({ id: crypto.randomUUID?.() ?? `${Date.now()}-${Math.random()}`, minimum, maximum, rates: {} });

export default function CooperativeInvestmentsPanel() {
  const [products, setProducts] = useState<FinancialProduct[]>([]);
  const [requests, setRequests] = useState<InvestmentRequest[]>([]);
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const [activeStep, setActiveStep] = useState(1);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [minimum, setMinimum] = useState("");
  const [maximum, setMaximum] = useState("");
  const [active, setActive] = useState(true);
  const [terms, setTerms] = useState<number[]>([3, 6, 12]);
  const [ranges, setRanges] = useState<RateRange[]>([blankRange()]);
  const [method, setMethod] = useState("UNSPECIFIED");
  const [paymentOptions, setPaymentOptions] = useState<string[]>([]);
  const [renewal, setRenewal] = useState("");
  const [cancellation, setCancellation] = useState("");
  const [audience, setAudience] = useState("");
  const [validUntil, setValidUntil] = useState("");
  const [accepting, setAccepting] = useState<InvestmentRequest | null>(null);
  const [acceptanceMessage, setAcceptanceMessage] = useState("Tu solicitud de inversión ha sido aceptada. Para continuar con el proceso, acércate a una de nuestras agencias con los requisitos indicados.");
  const [agencyName, setAgencyName] = useState("");
  const [agencyAddress, setAgencyAddress] = useState("");
  const [agencyCity, setAgencyCity] = useState("");
  const [mapsUrl, setMapsUrl] = useState("");
  const [contactPhone, setContactPhone] = useState("");
  const [openingHours, setOpeningHours] = useState("");
  const [contactDepartment, setContactDepartment] = useState("");
  const [responseDeadline, setResponseDeadline] = useState("");
  const [instructions, setInstructions] = useState("");
  const [confirmedRate, setConfirmedRate] = useState("");
  const [requirements, setRequirements] = useState<Requirement[]>([]);
  const [note, setNote] = useState<Record<number, string>>({});

  const refresh = async () => {
    const [nextProducts, nextRequests] = await Promise.all([getCooperativeInvestmentProducts(), getCooperativeInvestmentRequests()]);
    setProducts(nextProducts); setRequests(nextRequests);
  };
  useEffect(() => {
    void refresh().catch((e) => setError(getErrorMessage(e, "No se pudieron cargar los datos de inversión.")));
    const timer = window.setInterval(() => void refresh().catch(() => {}), 25000);
    return () => window.clearInterval(timer);
  }, []);
  const run = async (operation: () => Promise<unknown>) => {
    setBusy(true); setError("");
    try { await operation(); await refresh(); }
    catch (e) { setError(getErrorMessage(e, "No se pudo guardar el cambio.")); }
    finally { setBusy(false); }
  };
  const resetWizard = () => {
    setEditingId(null); setName(""); setDescription(""); setMinimum(""); setMaximum(""); setActive(true);
    setTerms([3, 6, 12]); setRanges([blankRange()]); setMethod("UNSPECIFIED"); setPaymentOptions([]);
    setRenewal(""); setCancellation(""); setAudience(""); setValidUntil(""); setActiveStep(1);
  };
  const beginEdit = (product: FinancialProduct) => {
    setEditingId(product.id); setName(product.name); setDescription(product.description ?? "");
    setMinimum(String(product.minimumAmount)); setMaximum(String(product.maximumAmount)); setActive(product.active);
    setMethod(product.calculationMethod); setPaymentOptions(product.interestPaymentOptions ?? []);
    setRenewal(product.renewalConditions ?? ""); setCancellation(product.earlyCancellationConditions ?? ""); setAudience(product.targetAudience ?? "");
    const allTerms = [...new Set(product.conditions.flatMap((c) => Array.from({ length: Math.max(0, c.maximumTermMonths - c.minimumTermMonths + 1) }, (_, i) => c.minimumTermMonths + i)))].sort((a, b) => a - b);
    setTerms(allTerms.length ? allTerms : [3, 6, 12]);
    const grouped = new Map<string, RateRange>();
    for (const condition of product.conditions) {
      const key = `${condition.minimumAmount}:${condition.maximumAmount}`;
      const row = grouped.get(key) ?? blankRange(String(condition.minimumAmount), String(condition.maximumAmount));
      for (let term = condition.minimumTermMonths; term <= condition.maximumTermMonths; term++) row.rates[term] = String(condition.annualRate);
      grouped.set(key, row);
    }
    setRanges(grouped.size ? [...grouped.values()] : [blankRange(String(product.minimumAmount), String(product.maximumAmount))]);
    setActiveStep(1); window.scrollTo({ top: 0, behavior: "smooth" });
  };
  const toggleTerm = (term: number) => setTerms((current) => {
    const next = current.includes(term) ? current.filter((item) => item !== term) : [...current, term];
    return next.sort((a, b) => a - b);
  });
  const updateRate = (rangeId: string, term: number, value: string) => setRanges((rows) => rows.map((row) => row.id === rangeId ? { ...row, rates: { ...row.rates, [term]: value } } : row));
  const validation = useMemo(() => {
    if (!name.trim()) return "Ingresa el nombre del producto.";
    if (!(Number(minimum) > 0) || Number(maximum) < Number(minimum)) return "Revisa los montos mínimo y máximo.";
    if (!terms.length) return "Activa al menos un plazo.";
    if (!ranges.length) return "Agrega al menos un rango de monto.";
    for (const row of ranges) {
      if (!(Number(row.minimum) >= Number(minimum) && Number(row.maximum) <= Number(maximum) && Number(row.maximum) >= Number(row.minimum))) return "Los rangos de tasas deben estar dentro de los montos del producto.";
      for (const term of terms) if (!(Number(row.rates[term]) > 0)) return `Completa la tasa del rango $${row.minimum}–$${row.maximum} para ${term} meses.`;
    }
    const sorted = [...ranges].sort((a, b) => Number(a.minimum) - Number(b.minimum));
    for (let i = 1; i < sorted.length; i++) if (Number(sorted[i].minimum) <= Number(sorted[i - 1].maximum)) return "Los rangos de monto no pueden superponerse.";
    return "";
  }, [name, minimum, maximum, terms, ranges]);
  const saveProduct = async () => run(async () => {
    const product = await saveCooperativeInvestmentProduct({ type: "INVESTMENT", name: name.trim(), description: description.trim(), minimumAmount: Number(minimum), maximumAmount: Number(maximum), active, interestPaymentOptions: paymentOptions, calculationMethod: method, renewalConditions: renewal.trim(), earlyCancellationConditions: cancellation.trim(), targetAudience: audience.trim() }, editingId ?? undefined);
    const validUntilIso = validUntil ? new Date(`${validUntil}T23:59:59`).toISOString() : null;
    for (const range of ranges) for (const term of terms) {
      const annualRate = Number(range.rates[term]);
      const existing = editingId == null ? null : products.find((p) => p.id === editingId)?.conditions.find((c) => c.minimumAmount === Number(range.minimum) && c.maximumAmount === Number(range.maximum) && c.minimumTermMonths === term && c.maximumTermMonths === term && c.annualRate === annualRate);
      if (existing) continue;
      await addInvestmentRate(product.id, { minimumAmount: Number(range.minimum), maximumAmount: Number(range.maximum), minimumTermMonths: term, maximumTermMonths: term, annualRate, validFrom: new Date().toISOString(), validUntil: validUntilIso });
    }
    resetWizard();
  });
  const startAcceptance = (request: InvestmentRequest) => {
    setAccepting(request); setConfirmedRate(""); setRequirements([]); setAgencyName(""); setAgencyAddress(""); setAgencyCity(""); setMapsUrl(""); setContactPhone(""); setOpeningHours(""); setContactDepartment(""); setResponseDeadline(""); setInstructions("");
  };
  const submitAcceptance = () => accepting && run(async () => {
    await acceptInvestmentRequest(accepting.id, {
      acceptanceMessage, confirmedAnnualRate: confirmedRate ? Number(confirmedRate) : null,
      agencyName, agencyAddress, agencyCity, mapsUrl: mapsUrl || null, contactPhone: contactPhone || null,
      openingHours: openingHours || null, contactDepartment: contactDepartment || null,
      responseDeadline: responseDeadline || null, instructions: instructions || null,
      requirements,
    });
    setAccepting(null);
  });
  const canOpenMap = () => {
    if (!mapsUrl) return true;
    try { const parsed = new URL(mapsUrl); return parsed.protocol === "https:" && ["maps.google.com", "www.google.com", "google.com", "maps.app.goo.gl", "goo.gl", "www.google.com.ec"].includes(parsed.hostname); }
    catch { return false; }
  };

  return <section className="space-y-7">
    <header><p className="text-xs font-bold uppercase tracking-widest text-emerald-700">Productos financieros</p><h2 className="mt-1 text-2xl font-extrabold text-[#173b57]">Inversiones</h2><p className="mt-2 text-sm text-slate-600">Configura depósitos a plazo y atiende solicitudes. La aceptación requiere que el cliente formalice la operación directamente con la cooperativa.</p></header>
    {error && <p role="alert" className="rounded-xl bg-rose-50 p-3 text-sm text-rose-700">{error}</p>}

    <section className="rounded-2xl border bg-white p-5 sm:p-6">
      <div className="mb-5 flex flex-wrap items-center justify-between gap-3"><div><p className="text-xs font-bold uppercase tracking-widest text-slate-400">{editingId ? "Editar producto" : "Nuevo producto"}</p><h3 className="mt-1 text-lg font-extrabold">Asistente de publicación</h3></div><button type="button" onClick={resetWizard} className="rounded-lg border px-3 py-2 text-sm font-bold">Limpiar</button></div>
      <ol className="mb-6 grid grid-cols-2 gap-2 sm:grid-cols-4">{["Producto", "Plazos", "Tasas", "Revisar"].map((label, i) => <li key={label}><button type="button" onClick={() => i + 1 < activeStep && setActiveStep(i + 1)} className={`w-full rounded-xl px-3 py-2 text-left text-xs font-bold ${activeStep === i + 1 ? "bg-emerald-700 text-white" : activeStep > i + 1 ? "bg-emerald-50 text-emerald-800" : "bg-slate-100 text-slate-500"}`}><span className="mr-2">0{i + 1}</span>{label}</button></li>)}</ol>
      {activeStep === 1 && <div className="space-y-4"><p className="text-sm text-slate-600">Empieza con un depósito a plazo fijo. Los cambios de estado no eliminan el historial ni las solicitudes anteriores.</p><label className="block text-sm font-semibold">Nombre<input value={name} onChange={(e) => setName(e.target.value)} placeholder="Depósito a plazo fijo" className="mt-1 w-full rounded-lg border p-3" /></label><label className="block text-sm font-semibold">Descripción<textarea value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Explica brevemente el producto" className="mt-1 w-full rounded-lg border p-3" /></label><div className="grid gap-3 sm:grid-cols-2"><label className="text-sm font-semibold">Monto mínimo (USD)<input type="number" min="0.01" value={minimum} onChange={(e) => setMinimum(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label><label className="text-sm font-semibold">Monto máximo (USD)<input type="number" min="0.01" value={maximum} onChange={(e) => setMaximum(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label></div><label className="flex items-center gap-2 text-sm font-semibold"><input type="checkbox" checked={active} onChange={(e) => setActive(e.target.checked)} />Producto activo</label><details className="rounded-xl border p-4"><summary className="cursor-pointer text-sm font-bold">Condiciones adicionales</summary><div className="mt-4 space-y-3"><label className="block text-sm font-semibold">Método de cálculo<select value={method} onChange={(e) => setMethod(e.target.value)} className="mt-1 w-full rounded-lg border p-3"><option value="UNSPECIFIED">Según condiciones del producto</option><option value="SIMPLE_INTEREST">Interés simple</option><option value="MONTHLY_COMPOUNDING">Capitalización mensual</option></select></label><div className="flex flex-wrap gap-4 text-sm">{[["MONTHLY", "Pago mensual"], ["AT_MATURITY", "Al vencimiento"], ["REINVEST", "Reinvertir"]].map(([value, label]) => <label key={value} className="flex items-center gap-2"><input type="checkbox" checked={paymentOptions.includes(value)} onChange={(e) => setPaymentOptions((current) => e.target.checked ? [...current, value] : current.filter((item) => item !== value))} />{label}</label>)}</div><label className="block text-sm font-semibold">Renovación (opcional)<input value={renewal} onChange={(e) => setRenewal(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label><label className="block text-sm font-semibold">Cancelación anticipada (opcional)<input value={cancellation} onChange={(e) => setCancellation(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label><label className="block text-sm font-semibold">Público al que se dirige (opcional)<input value={audience} onChange={(e) => setAudience(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label></div></details><button type="button" onClick={() => setActiveStep(2)} disabled={!name.trim() || !(Number(minimum) > 0) || Number(maximum) < Number(minimum)} className="rounded-lg bg-emerald-700 px-4 py-2.5 font-bold text-white disabled:opacity-50">Continuar</button></div>}
      {activeStep === 2 && <div><p className="mb-4 text-sm text-slate-600">Activa los plazos que ofrece tu cooperativa. Por ahora se manejan meses.</p><div className="grid grid-cols-2 gap-3 sm:grid-cols-3">{suggestedTerms.map((term) => <label key={term} className={`flex cursor-pointer items-center gap-3 rounded-xl border p-4 ${terms.includes(term) ? "border-emerald-500 bg-emerald-50" : "border-slate-200"}`}><input type="checkbox" checked={terms.includes(term)} onChange={() => toggleTerm(term)} /><span className="font-bold">{term} meses</span></label>)}</div><div className="mt-4 flex gap-2"><input type="number" min="1" max="600" id="custom-term" placeholder="Otro plazo en meses" className="w-56 rounded-lg border p-3" /><button type="button" onClick={() => { const el = document.getElementById("custom-term") as HTMLInputElement; const n = Number(el.value); if (n > 0 && n <= 600) { setTerms((current) => [...new Set([...current, n])].sort((a, b) => a - b)); el.value = ""; } }} className="rounded-lg border px-4 font-bold">Agregar plazo</button></div><div className="mt-6 flex gap-2"><button type="button" onClick={() => setActiveStep(1)} className="rounded-lg border px-4 py-2.5 font-bold">Atrás</button><button type="button" disabled={!terms.length} onClick={() => { setRanges((rows) => rows.map((row) => ({ ...row, rates: Object.fromEntries(terms.map((t) => [t, row.rates[t] ?? ""])) }))); setActiveStep(3); }} className="rounded-lg bg-emerald-700 px-4 py-2.5 font-bold text-white disabled:opacity-50">Configurar tasas</button></div></div>}
      {activeStep === 3 && <div><p className="mb-4 text-sm text-slate-600">Indica la tasa anual para cada monto y plazo. Puedes usar un único rango o crear varios que no se superpongan.</p><div className="space-y-4">{ranges.map((row, rowIndex) => <article key={row.id} className="overflow-hidden rounded-xl border"><div className="flex flex-wrap items-end gap-3 bg-slate-50 p-3"><label className="text-xs font-bold">Desde USD<input type="number" value={row.minimum} onChange={(e) => setRanges((rs) => rs.map((r) => r.id === row.id ? { ...r, minimum: e.target.value } : r))} className="mt-1 block w-36 rounded-lg border bg-white p-2.5 text-sm" /></label><label className="text-xs font-bold">Hasta USD<input type="number" value={row.maximum} onChange={(e) => setRanges((rs) => rs.map((r) => r.id === row.id ? { ...r, maximum: e.target.value } : r))} className="mt-1 block w-36 rounded-lg border bg-white p-2.5 text-sm" /></label><span className="pb-2 text-xs text-slate-500">Rango {rowIndex + 1}</span><button type="button" disabled={ranges.length === 1} onClick={() => setRanges((rs) => rs.filter((r) => r.id !== row.id))} className="ml-auto pb-2 text-xs font-bold text-rose-600 disabled:opacity-40">Eliminar rango</button></div><div className="grid gap-3 p-3 sm:grid-cols-2 lg:grid-cols-3">{terms.map((term) => <label key={term} className="text-xs font-bold text-slate-600">Tasa anual · {term} meses<div className="mt-1 flex items-center rounded-lg border px-3"><input type="number" min="0.0001" step="0.0001" value={row.rates[term] ?? ""} onChange={(e) => updateRate(row.id, term, e.target.value)} placeholder="0,00" className="w-full py-2.5 text-sm outline-none" /><span>%</span></div></label>)}</div></article>)}</div><button type="button" onClick={() => setRanges((rows) => [...rows, blankRange()])} className="mt-3 rounded-lg border px-4 py-2 text-sm font-bold">+ Agregar rango de monto</button>{validUntil && <p className="mt-3 text-xs text-slate-500">Las nuevas condiciones vencen el {new Date(validUntil).toLocaleDateString("es-EC")}.</p>}<label className="mt-4 block max-w-sm text-sm font-semibold">Vigencia hasta (opcional)<input type="date" value={validUntil} onChange={(e) => setValidUntil(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label><div className="mt-6 flex gap-2"><button type="button" onClick={() => setActiveStep(2)} className="rounded-lg border px-4 py-2.5 font-bold">Atrás</button><button type="button" disabled={Boolean(validation)} onClick={() => setActiveStep(4)} className="rounded-lg bg-emerald-700 px-4 py-2.5 font-bold text-white disabled:opacity-50">Revisar configuración</button></div>{validation && <p className="mt-3 text-sm text-rose-600">{validation}</p>}</div>}
      {activeStep === 4 && <div><h4 className="font-extrabold">Vista previa</h4><div className="mt-3 space-y-3 rounded-xl bg-slate-50 p-4 text-sm"><p><b>{name}</b> · {active ? "Activo" : "Inactivo"}</p><p>{description || "Sin descripción"}</p><p>Monto: ${minimum}–${maximum} · Plazos: {terms.map((t) => `${t} meses`).join(", ")}</p>{ranges.map((row) => <div key={row.id} className="rounded-lg border bg-white p-3"><b>${row.minimum}–${row.maximum}</b><div className="mt-2 flex flex-wrap gap-3">{terms.map((term) => <span key={term}>{term} meses: <b>{row.rates[term]}%</b></span>)}</div></div>)}<p>Pago de intereses: {paymentOptions.length ? paymentOptions.map((p) => p === "MONTHLY" ? "mensual" : p === "AT_MATURITY" ? "al vencimiento" : "reinversión").join(", ") : "sin preferencia configurada"} · Vigencia: {validUntil || "sin fecha de vencimiento"}</p><p>Renovación: {renewal || "No especificada"} · Cancelación anticipada: {cancellation || "No especificada"}</p>{audience && <p>Público: {audience}</p>}<p className="text-xs text-slate-500">Se crearán condiciones versionadas. Las tasas ilustrativas nunca se guardan por defecto: ingresa las tasas propias de tu cooperativa.</p></div><div className="mt-5 flex flex-wrap gap-2"><button type="button" onClick={() => setActiveStep(3)} className="rounded-lg border px-4 py-2.5 font-bold">Volver a tasas</button><button type="button" onClick={() => setActiveStep(1)} className="rounded-lg border px-4 py-2.5 font-bold">Editar producto</button><button type="button" disabled={busy || Boolean(validation)} onClick={() => void saveProduct()} className="rounded-lg bg-emerald-700 px-5 py-2.5 font-bold text-white disabled:opacity-50">{busy ? "Guardando…" : editingId ? "Guardar nueva versión" : "Publicar producto"}</button></div></div>}
    </section>

    <section className="rounded-2xl border bg-white p-5"><h3 className="mb-4 font-extrabold">Productos publicados</h3>{!products.length ? <p className="text-sm text-slate-500">Todavía no hay productos. Publica el primero con el asistente.</p> : <div className="grid gap-4 lg:grid-cols-2">{products.map((product) => <article key={product.id} className="rounded-xl border p-4"><div className="flex items-start justify-between gap-3"><div><p className="text-xs font-bold uppercase tracking-wide text-emerald-700">Depósito a plazo fijo</p><h4 className="mt-1 font-extrabold">{product.name}</h4><p className="mt-1 text-sm text-slate-600">${product.minimumAmount.toLocaleString("es-EC")}–${product.maximumAmount.toLocaleString("es-EC")} · {product.conditions.length} condiciones</p></div><span className={`rounded-full px-3 py-1 text-xs font-bold ${product.active ? "bg-emerald-50 text-emerald-700" : "bg-slate-100 text-slate-500"}`}>{product.active ? "Activo" : "Inactivo"}</span></div><div className="mt-3 flex flex-wrap gap-2"><button onClick={() => beginEdit(product)} className="rounded-lg border px-3 py-2 text-xs font-bold">Editar y versionar tasas</button><button onClick={() => void run(() => saveCooperativeInvestmentProduct({ type: "INVESTMENT", name: product.name, description: product.description, minimumAmount: product.minimumAmount, maximumAmount: product.maximumAmount, active: !product.active, interestPaymentOptions: product.interestPaymentOptions, calculationMethod: product.calculationMethod, renewalConditions: product.renewalConditions, earlyCancellationConditions: product.earlyCancellationConditions, targetAudience: product.targetAudience }, product.id))} className="rounded-lg border px-3 py-2 text-xs font-bold">{product.active ? "Desactivar" : "Activar"}</button></div></article>)}</div>}</section>

    <section className="rounded-2xl border bg-white p-5"><div className="flex flex-wrap items-center justify-between gap-3"><div><h3 className="font-extrabold">Solicitudes recibidas</h3><p className="text-xs text-slate-500">Actualización automática cada 25 segundos. Los datos de contacto se muestran porque el cliente autorizó compartirlos con tu cooperativa.</p></div><button onClick={() => void run(refresh)} className="rounded-lg border px-3 py-2 text-sm font-bold">Actualizar</button></div>{!requests.length ? <p className="mt-4 text-sm text-slate-500">Aún no hay solicitudes.</p> : <div className="mt-4 space-y-4">{requests.map((request) => <article key={request.id} className="rounded-xl border p-4"><div className="flex flex-wrap justify-between gap-2"><div><strong>{request.clientName || "Cliente"} · {request.productName}</strong><p className="text-sm text-slate-600">${request.amount.toLocaleString("es-EC", { minimumFractionDigits: 2 })} · {request.termMonths} meses · {request.annualRate.toFixed(2)}% anual</p><p className="text-xs text-slate-500">{request.clientEmail || ""} {request.clientPhone || ""}</p><p className="mt-1 text-xs text-slate-500">Recibida: {new Date(request.createdAt).toLocaleString("es-EC")}</p></div><span className="text-sm font-bold text-emerald-700">{statusLabel(request.status)}</span></div>{request.statusNote && <p className="mt-2 rounded-lg bg-amber-50 p-2 text-sm">{request.statusNote}</p>}<div className="mt-3 flex flex-wrap gap-2">{request.status === "SUBMITTED" && <button onClick={() => void run(() => updateInvestmentRequest(request.id, "IN_REVIEW", ""))} className="rounded-lg border px-3 py-2 text-xs font-bold">Marcar en revisión</button>}{!["CONDITIONS_CONFIRMED", "DECLINED"].includes(request.status) && <button onClick={() => startAcceptance(request)} className="rounded-lg bg-emerald-700 px-3 py-2 text-xs font-bold text-white">Aceptar inversión</button>}{!["CONDITIONS_CONFIRMED", "DECLINED"].includes(request.status) && <button onClick={() => void run(() => updateInvestmentRequest(request.id, "INFORMATION_REQUIRED", note[request.id] || ""))} className="rounded-lg border px-3 py-2 text-xs font-bold">Solicitar información</button>}{!["CONDITIONS_CONFIRMED", "DECLINED"].includes(request.status) && <button onClick={() => void run(() => updateInvestmentRequest(request.id, "DECLINED", note[request.id] || ""))} className="rounded-lg border border-rose-200 px-3 py-2 text-xs font-bold text-rose-700">Rechazar</button>}</div>{!["CONDITIONS_CONFIRMED", "DECLINED"].includes(request.status) && <input value={note[request.id] || ""} onChange={(e) => setNote({ ...note, [request.id]: e.target.value })} placeholder="Motivo o información para el cliente" className="mt-3 w-full rounded-lg border p-2.5 text-sm" />}{request.acceptance && <div className="mt-3 rounded-xl bg-emerald-50 p-4 text-sm"><b>Respuesta de aceptación enviada</b><p>{request.acceptance.agencyName} · {request.acceptance.agencyAddress}, {request.acceptance.agencyCity}</p><p>{request.acceptance.requirements.length} requisitos indicados</p></div>}</article>)}</div>}</section>

    {accepting && <div className="fixed inset-0 z-[80] grid place-items-center bg-slate-950/50 p-3"><section className="max-h-[94vh] w-full max-w-2xl overflow-y-auto rounded-2xl bg-white p-5 shadow-2xl sm:p-7"><div className="flex items-start justify-between gap-3"><div><p className="text-xs font-bold uppercase tracking-widest text-emerald-700">Respuesta a la solicitud</p><h3 className="mt-1 text-xl font-extrabold">Aceptar inversión</h3><p className="text-sm text-slate-500">{accepting.clientName} · {accepting.productName} · ${accepting.amount.toLocaleString("es-EC")}</p></div><button onClick={() => setAccepting(null)} className="rounded-lg border px-3 py-2">Cerrar</button></div><div className="mt-5 space-y-4"><label className="block text-sm font-semibold">Mensaje de aceptación<textarea value={acceptanceMessage} onChange={(e) => setAcceptanceMessage(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label><div className="grid gap-3 sm:grid-cols-2"><Field label="Nombre de agencia" value={agencyName} onChange={setAgencyName} required /><Field label="Dirección" value={agencyAddress} onChange={setAgencyAddress} required /><Field label="Ciudad" value={agencyCity} onChange={setAgencyCity} required /><Field label="Tasa anual confirmada (%)" value={confirmedRate} onChange={setConfirmedRate} type="number" /><Field label="Teléfono de contacto" value={contactPhone} onChange={setContactPhone} /><Field label="Área o persona de contacto" value={contactDepartment} onChange={setContactDepartment} /><Field label="Horario de atención" value={openingHours} onChange={setOpeningHours} /><Field label="Fecha límite (opcional)" value={responseDeadline} onChange={setResponseDeadline} type="date" /></div><Field label="Enlace Google Maps HTTPS (opcional)" value={mapsUrl} onChange={setMapsUrl} /><label className="block text-sm font-semibold">Instrucciones adicionales<textarea value={instructions} onChange={(e) => setInstructions(e.target.value)} className="mt-1 w-full rounded-lg border p-3" /></label><div><div className="mb-2 flex items-center justify-between"><b className="text-sm">Requisitos (opcional)</b><button onClick={() => setRequirements((items) => [...items, { description: "", mandatory: true }])} className="rounded-lg border px-3 py-2 text-xs font-bold">Agregar requisito</button></div><div className="space-y-2">{requirements.map((item, index) => <div key={index} className="flex flex-wrap items-center gap-2"><input value={item.description} onChange={(e) => setRequirements((items) => items.map((r, i) => i === index ? { ...r, description: e.target.value } : r))} placeholder="Descripción del requisito" className="min-w-48 flex-1 rounded-lg border p-2.5 text-sm" /><label className="flex items-center gap-1 text-xs"><input type="checkbox" checked={item.mandatory} onChange={(e) => setRequirements((items) => items.map((r, i) => i === index ? { ...r, mandatory: e.target.checked } : r))} />Obligatorio</label><button onClick={() => setRequirements((items) => items.filter((_, i) => i !== index))} className="px-2 text-sm font-bold text-rose-700">Eliminar</button></div>)}</div></div><div className="rounded-lg bg-amber-50 p-3 text-xs leading-5 text-amber-900">Aceptar la solicitud no constituye el depósito. El cliente todavía debe completar el proceso directamente con la cooperativa.</div><div className="flex justify-end gap-2"><button onClick={() => setAccepting(null)} className="rounded-lg border px-4 py-2.5 font-bold">Cancelar</button><button disabled={busy || !acceptanceMessage.trim() || !agencyName.trim() || !agencyAddress.trim() || !agencyCity.trim() || requirements.some((r) => !r.description.trim()) || !canOpenMap()} onClick={() => void submitAcceptance()} className="rounded-lg bg-emerald-700 px-4 py-2.5 font-bold text-white disabled:opacity-50">{busy ? "Enviando…" : "Confirmar y enviar"}</button></div></div></section></div>}
  </section>;
}
function Field({ label, value, onChange, type = "text", required = false }: { label: string; value: string; onChange: (value: string) => void; type?: string; required?: boolean }) { return <label className="block text-sm font-semibold">{label}<input required={required} type={type} value={value} onChange={(e) => onChange(e.target.value)} className="mt-1 w-full rounded-lg border p-2.5 font-normal" /></label>; }
function statusLabel(status: string) { return ({ SUBMITTED: "Enviada", IN_REVIEW: "En revisión", INFORMATION_REQUIRED: "Requiere información", CONDITIONS_CONFIRMED: "Aceptada · formalización pendiente", DECLINED: "Rechazada" } as Record<string, string>)[status] ?? status; }
