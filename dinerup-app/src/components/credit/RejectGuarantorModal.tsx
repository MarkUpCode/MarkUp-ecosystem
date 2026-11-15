import { useEffect, useState } from "react";
import { AlertTriangle, Check, X } from "lucide-react";

const reasons = [
  { value: "CAPACIDAD_DE_PAGO", label: "El crédito sobrepasa su capacidad de pago" },
  { value: "TIEMPO_DE_NEGOCIO", label: "Tiempo de negocio mínimo no alcanzado" },
  { value: "BURO_DEL_CREDITO", label: "Buró del crédito" },
  { value: "OTROS", label: "Otros motivos" },
] as const;

interface RejectGuarantorModalProps {
  open: boolean;
  loading: boolean;
  onClose: () => void;
  onConfirm: (reasons: string[], otherReason: string) => void;
}

export default function RejectGuarantorModal({ open, loading, onClose, onConfirm }: RejectGuarantorModalProps) {
  const [selected, setSelected] = useState<string[]>([]);
  const [otherReason, setOtherReason] = useState("");

  useEffect(() => {
    if (open) {
      setSelected([]);
      setOtherReason("");
    }
  }, [open]);

  if (!open) return null;
  const toggle = (value: string) => setSelected((current) =>
    current.includes(value) ? current.filter((item) => item !== value) : [...current, value],
  );
  const otherSelected = selected.includes("OTROS");

  return <div className="fixed inset-0 z-[130] flex items-center justify-center bg-slate-950/60 p-4">
    <div role="dialog" aria-modal="true" aria-labelledby="reject-guarantor-title" className="w-full max-w-lg rounded-3xl bg-white p-6 shadow-2xl">
      <div className="flex items-start gap-3">
        <div className="grid h-11 w-11 place-items-center rounded-2xl bg-amber-50 text-amber-700"><AlertTriangle /></div>
        <div className="flex-1"><h2 id="reject-guarantor-title" className="text-xl font-extrabold text-[#173b57]">Solicitar corrección del garante</h2><p className="mt-1 text-sm text-slate-500">Selecciona los motivos para que el usuario pueda corregir la información o registrar otro garante.</p></div>
        <button type="button" onClick={onClose} disabled={loading} className="rounded-lg p-2 text-slate-400 hover:bg-slate-100" aria-label="Cerrar"><X className="h-5 w-5" /></button>
      </div>
      <div className="mt-6 space-y-3">
        {reasons.map((reason) => {
          const checked = selected.includes(reason.value);
          return <button type="button" key={reason.value} onClick={() => toggle(reason.value)} className={`flex w-full items-center gap-3 rounded-2xl border p-4 text-left text-sm font-semibold transition ${checked ? "border-amber-300 bg-amber-50 text-amber-900" : "border-slate-200 text-slate-700 hover:border-slate-300"}`}>
            <span className={`grid h-5 w-5 place-items-center rounded-md border ${checked ? "border-amber-700 bg-amber-700 text-white" : "border-slate-300"}`}>{checked && <Check className="h-3.5 w-3.5" />}</span>{reason.label}
          </button>;
        })}
      </div>
      {otherSelected && <div className="mt-4">
        <label htmlFor="other-guarantor-reason" className="mb-2 block text-sm font-bold text-slate-700">Describe el motivo</label>
        <textarea id="other-guarantor-reason" value={otherReason} onChange={(event) => setOtherReason(event.target.value)} maxLength={250} rows={3} placeholder="Indica qué debe corregir el usuario…" className="w-full resize-y rounded-xl border border-slate-300 p-3 text-sm outline-none focus:border-amber-500 focus:ring-4 focus:ring-amber-100" />
        <p className="mt-1 text-right text-xs text-slate-400">{otherReason.length}/250</p>
      </div>}
      <div className="mt-6 flex justify-end gap-3">
        <button type="button" onClick={onClose} disabled={loading} className="rounded-xl border border-slate-200 px-4 py-2.5 text-sm font-bold text-slate-600">Cancelar</button>
        <button type="button" disabled={!selected.length || (otherSelected && !otherReason.trim()) || loading} onClick={() => onConfirm(selected, otherSelected ? otherReason.trim() : "")} className="rounded-xl bg-amber-700 px-4 py-2.5 text-sm font-bold text-white disabled:cursor-not-allowed disabled:opacity-50">{loading ? "Enviando…" : "Solicitar corrección"}</button>
      </div>
    </div>
  </div>;
}
