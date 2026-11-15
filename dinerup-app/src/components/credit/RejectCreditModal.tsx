import { useEffect, useState } from "react";
import { AlertTriangle, Check, X } from "lucide-react";

const rejectionReasons = [
  { value: "CAPACIDAD_DE_PAGO", label: "El crédito sobrepasa su capacidad de pago" },
  { value: "TIEMPO_DE_NEGOCIO", label: "Tiempo de negocio mínimo no alcanzado" },
  { value: "BURO_DEL_CREDITO", label: "Buro del crédito" },
  { value: "OTROS", label: "Otros motivos" },
] as const;

interface RejectCreditModalProps {
  open: boolean;
  loading: boolean;
  onClose: () => void;
  onConfirm: (reasons: string[], otherReason: string) => void;
}

export default function RejectCreditModal({ open, loading, onClose, onConfirm }: RejectCreditModalProps) {
  const [selected, setSelected] = useState<string[]>([]);
  const [otherReason, setOtherReason] = useState("");
  useEffect(() => {
    if (open) {
      setSelected([]);
      setOtherReason("");
    }
  }, [open]);
  if (!open) return null;

  const toggle = (value: string) => {
    setSelected((current) =>
      current.includes(value) ? current.filter((item) => item !== value) : [...current, value],
    );
  };
  const otherSelected = selected.includes("OTROS");
  const otherReasonMissing = otherSelected && !otherReason.trim();

  return (
    <div className="fixed inset-0 z-[120] flex items-center justify-center bg-slate-950/60 p-4">
      <div className="w-full max-w-lg rounded-3xl bg-white p-6 shadow-2xl">
        <div className="flex items-start gap-3">
          <div className="grid h-11 w-11 place-items-center rounded-2xl bg-rose-50 text-rose-600"><AlertTriangle /></div>
          <div className="flex-1"><h2 className="text-xl font-extrabold text-[#173b57]">Rechazar solicitud</h2><p className="mt-1 text-sm text-slate-500">Selecciona uno o más motivos para informar claramente al solicitante.</p></div>
          <button type="button" onClick={onClose} className="rounded-lg p-2 text-slate-400 hover:bg-slate-100" aria-label="Cerrar"><X className="h-5 w-5" /></button>
        </div>
        <div className="mt-6 space-y-3">
          {rejectionReasons.map((reason) => {
            const checked = selected.includes(reason.value);
            return <button type="button" key={reason.value} onClick={() => toggle(reason.value)} className={`flex w-full items-center gap-3 rounded-2xl border p-4 text-left text-sm font-semibold transition ${checked ? "border-rose-300 bg-rose-50 text-rose-800" : "border-slate-200 text-slate-700 hover:border-slate-300"}`}><span className={`grid h-5 w-5 place-items-center rounded-md border ${checked ? "border-rose-600 bg-rose-600 text-white" : "border-slate-300"}`}>{checked && <Check className="h-3.5 w-3.5" />}</span>{reason.label}</button>;
          })}
        </div>
        {otherSelected && <div className="mt-4">
          <label htmlFor="other-rejection-reason" className="mb-2 block text-sm font-bold text-slate-700">Describe el otro motivo</label>
          <textarea
            id="other-rejection-reason"
            value={otherReason}
            onChange={(event) => setOtherReason(event.target.value)}
            maxLength={500}
            rows={4}
            placeholder="Escribe el motivo del rechazo…"
            className="w-full resize-y rounded-xl border border-slate-300 p-3 text-sm outline-none focus:border-rose-400 focus:ring-4 focus:ring-rose-100"
          />
          <p className="mt-1 text-right text-xs text-slate-400">{otherReason.length}/500</p>
        </div>}
        <div className="mt-6 flex justify-end gap-3"><button type="button" onClick={onClose} className="rounded-xl border border-slate-200 px-4 py-2.5 text-sm font-bold text-slate-600">Cancelar</button><button type="button" disabled={!selected.length || otherReasonMissing || loading} onClick={() => onConfirm(selected, otherSelected ? otherReason.trim() : "")} className="rounded-xl bg-rose-600 px-4 py-2.5 text-sm font-bold text-white disabled:cursor-not-allowed disabled:opacity-50">{loading ? "Registrando..." : "Confirmar rechazo"}</button></div>
      </div>
    </div>
  );
}
