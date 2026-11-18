import { useState, type FormEvent } from "react";
import type { CreateCooperativeRequest } from "../types/cooperative";

const input = "mt-1 w-full rounded-xl border border-white/10 bg-slate-950 px-3 py-2.5 text-white";
const initialForm: CreateCooperativeRequest = {
  nombre: "", ciudad: "", provincia: "", direccion: "", telefono: "", paginaWeb: "", logoUrl: "",
  calificacion: null, montoMaximoCredito: 0,
};

export function CooperativeWizard({ open, onClose, onCreate }: {
  open: boolean; onClose: () => void;
  onCreate: (request: CreateCooperativeRequest) => Promise<{ id: number } | undefined>;
}) {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [form, setForm] = useState<CreateCooperativeRequest>(initialForm);
  if (!open) return null;

  async function submit(event: FormEvent) {
    event.preventDefault();
    setBusy(true);
    setError("");
    try {
      const cooperative = await onCreate(form);
      if (!cooperative) throw new Error("No se recibió la cooperativa creada.");
      setForm(initialForm);
      onClose();
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "No se pudo crear la cooperativa.");
    } finally {
      setBusy(false);
    }
  }

  return <div className="fixed inset-0 z-50 grid place-items-center overflow-y-auto bg-black/70 p-4">
    <form onSubmit={submit} className="my-6 max-h-[92vh] w-full max-w-2xl overflow-y-auto rounded-3xl border border-white/10 bg-slate-900 p-6 text-white">
      <div className="flex items-start justify-between gap-4">
        <div><p className="text-xs uppercase tracking-widest text-cyan-300">Información institucional</p><h2 className="mt-1 text-2xl font-bold">Crear cooperativa</h2><p className="mt-2 text-sm text-slate-400">Los productos financieros se configuran después desde su catálogo, con condiciones confirmadas por la cooperativa.</p></div>
        <button type="button" onClick={onClose} className="text-slate-400">Cerrar</button>
      </div>
      <div className="mt-6 grid gap-4 sm:grid-cols-2">
        {([ ["nombre", "Nombre", true], ["ciudad", "Ciudad", true], ["provincia", "Provincia", true], ["direccion", "Dirección", false], ["telefono", "Teléfono", false], ["paginaWeb", "Página web", false], ["logoUrl", "URL del logo", false] ] as const).map(([key, label, required]) => <label key={key} className="text-sm text-slate-300">{label}<input required={required} className={input} value={form[key]} onChange={(event) => setForm((current) => ({ ...current, [key]: event.target.value }))} /></label>)}
        <label className="text-sm text-slate-300">Calificación registrada (opcional)<input type="number" min="0" max="5" step="0.1" className={input} value={form.calificacion ?? ""} onChange={(event) => setForm((current) => ({ ...current, calificacion: event.target.value ? Number(event.target.value) : null }))} /></label>
      </div>
      {error && <p role="alert" className="mt-4 rounded-xl bg-red-500/10 p-3 text-sm text-red-200">{error}</p>}
      <div className="mt-7 flex justify-end gap-3"><button type="button" onClick={onClose} className="rounded-xl border border-white/10 px-4 py-2">Cancelar</button><button disabled={busy} className="rounded-xl bg-cyan-400 px-5 py-2 font-semibold text-slate-950 disabled:opacity-50">{busy ? "Guardando…" : "Crear cooperativa"}</button></div>
    </form>
  </div>;
}
