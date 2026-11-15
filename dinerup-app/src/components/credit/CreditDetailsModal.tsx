import { useCallback, useEffect, useState } from "react";
import {
  AlertCircle,
  Building2,
  CheckCircle2,
  Clock3,
  FileText,
  Loader,
  RefreshCw,
  X,
} from "lucide-react";
import type { CreditRequest, CreditRequestCooperative } from "../../types/credit";
import { CreditEstado } from "../../types/creditEstado";
import {
  acceptCreditCooperative,
  getCreditRequestCooperatives,
} from "../../api/creditRequests.api";
import { getErrorMessage } from "../../api/errors";
import GuaranteeOnboardingModal from "../onboarding/GuaranteeOnboardingModal";

interface CreditDetailsModalProps {
  open: boolean;
  request: CreditRequest;
  onClose: () => void;
}

const cooperativeStatus: Record<string, { label: string; styles: string }> = {
  PRE_APROBADA: { label: "Oferta disponible", styles: "bg-emerald-50 text-emerald-700 ring-emerald-200" },
  ACEPTADA: { label: "Oferta aceptada", styles: "bg-blue-50 text-blue-700 ring-blue-200" },
  SOLICITANDO_GARANTE: { label: "Requiere garante", styles: "bg-amber-50 text-amber-700 ring-amber-200" },
  RECHAZADA: { label: "No aprobada", styles: "bg-rose-50 text-rose-700 ring-rose-200" },
  ENVIADA: { label: "En evaluación", styles: "bg-slate-100 text-slate-600 ring-slate-200" },
};

function formatCurrency(value: number | null | undefined) {
  if (value == null || !Number.isFinite(value)) return "—";
  return new Intl.NumberFormat("es-EC", {
    style: "currency",
    currency: "USD",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(value);
}

function formatDate(value?: string) {
  if (!value) return "Respuesta registrada";
  const date = new Date(value);
  return Number.isNaN(date.getTime())
    ? "Respuesta registrada"
    : date.toLocaleDateString("es-EC", { day: "numeric", month: "short", year: "numeric" });
}

export default function CreditDetailsModal({ open, request, onClose }: CreditDetailsModalProps) {
  const [cooperatives, setCooperatives] = useState<CreditRequestCooperative[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selectedCooperativeId, setSelectedCooperativeId] = useState<number | null>(null);
  const [confirmationCooperativeId, setConfirmationCooperativeId] = useState<number | null>(null);
  const [acceptingCooperativeId, setAcceptingCooperativeId] = useState<number | null>(null);
  const [acceptError, setAcceptError] = useState<string | null>(null);
  const [showGuaranteeModal, setShowGuaranteeModal] = useState(false);

  const loadCooperatives = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await getCreditRequestCooperatives(request.solicitudId);
      setCooperatives(data);
    } catch (loadError) {
      setError(getErrorMessage(loadError, "No pudimos cargar las respuestas de las cooperativas."));
    } finally {
      setIsLoading(false);
    }
  }, [request.solicitudId]);

  useEffect(() => {
    if (!open) return;
    setSelectedCooperativeId(null);
    setConfirmationCooperativeId(null);
    setAcceptError(null);
    void loadCooperatives();
  }, [open, loadCooperatives]);

  useEffect(() => {
    if (!open) return;
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === "Escape" && acceptingCooperativeId === null && !showGuaranteeModal) onClose();
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [open, acceptingCooperativeId, showGuaranteeModal, onClose]);

  const handleAcceptCooperative = async (cooperativaId: number) => {
    setAcceptingCooperativeId(cooperativaId);
    setAcceptError(null);
    try {
      await acceptCreditCooperative(request.solicitudId, cooperativaId);
      setSelectedCooperativeId(cooperativaId);
      setConfirmationCooperativeId(null);
      await loadCooperatives();
    } catch (acceptFailure) {
      setAcceptError(getErrorMessage(acceptFailure, "No se pudo aceptar la oferta. Inténtalo otra vez."));
    } finally {
      setAcceptingCooperativeId(null);
    }
  };

  if (!open) return null;

  const requestStatus = request.estado === CreditEstado.RECHAZADA
    ? { label: "Con respuestas de rechazo", styles: "bg-rose-50 text-rose-700" }
    : request.estado === CreditEstado.PRE_APROBADA
    ? { label: "Con oferta", styles: "bg-emerald-50 text-emerald-700" }
    : request.estado === CreditEstado.SOLICITANDO_GARANTE
    ? { label: "Requiere garante", styles: "bg-amber-50 text-amber-700" }
    : request.estado === CreditEstado.CREADA
    ? { label: "Procesando", styles: "bg-slate-100 text-slate-600" }
    : { label: "En evaluación", styles: "bg-blue-50 text-blue-700" };

  return (
    <>
      <div
        className="fixed inset-0 z-50 flex items-end justify-center bg-slate-950/55 p-0 backdrop-blur-sm sm:items-center sm:p-5"
        onMouseDown={(event) => { if (event.target === event.currentTarget && acceptingCooperativeId === null) onClose(); }}
      >
        <section
          role="dialog"
          aria-modal="true"
          aria-labelledby="credit-details-title"
          className="flex max-h-[94dvh] w-full max-w-3xl flex-col overflow-hidden rounded-t-3xl bg-slate-50 shadow-2xl sm:max-h-[90vh] sm:rounded-3xl"
        >
          <header className="shrink-0 border-b border-slate-200 bg-white px-5 py-4 sm:px-7 sm:py-5">
            <div className="flex items-start justify-between gap-4">
              <div className="flex min-w-0 items-start gap-3">
                <div className="grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-blue-50 text-blue-700">
                  <Building2 className="h-5 w-5" />
                </div>
                <div className="min-w-0">
                  <p className="text-xs font-semibold uppercase tracking-wider text-slate-400">Seguimiento de crédito · #{request.solicitudId}</p>
                  <h2 id="credit-details-title" className="mt-1 text-xl font-extrabold text-slate-900 sm:text-2xl">Respuestas de cooperativas</h2>
                </div>
              </div>
              <button type="button" onClick={onClose} disabled={acceptingCooperativeId !== null} aria-label="Cerrar detalle" className="rounded-xl p-2 text-slate-500 transition hover:bg-slate-100 disabled:opacity-50">
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3">
              <div className="rounded-xl bg-slate-50 p-3">
                <p className="text-xs text-slate-500">Monto solicitado</p>
                <p className="mt-1 font-bold text-slate-900">{formatCurrency(request.monto)}</p>
              </div>
              <div className="rounded-xl bg-slate-50 p-3">
                <p className="text-xs text-slate-500">Tipo</p>
                <p className="mt-1 font-bold text-slate-900">{request.tipo === "CREDITO" ? "Crédito" : request.tipo === "INVERSION" ? "Inversión" : request.tipo}</p>
              </div>
              <div className="col-span-2 flex items-center sm:col-span-1">
                <span className={`rounded-full px-3 py-1.5 text-xs font-bold ${requestStatus.styles}`}>{requestStatus.label}</span>
              </div>
            </div>
          </header>

          <div className="min-h-0 flex-1 overflow-y-auto overscroll-contain px-5 py-5 sm:px-7">
            <div className="mb-4 flex items-center justify-between gap-3">
              <div>
                <h3 className="font-bold text-slate-900">Ofertas y respuestas</h3>
                <p className="mt-1 text-sm text-slate-500">Revisa cada respuesta. Solo puedes aceptar una oferta.</p>
              </div>
              {!isLoading && cooperatives.length > 0 && <span className="shrink-0 rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-600 ring-1 ring-slate-200">{cooperatives.length} {cooperatives.length === 1 ? "respuesta" : "respuestas"}</span>}
            </div>

            {isLoading ? (
              <div className="flex min-h-48 flex-col items-center justify-center rounded-2xl border border-slate-200 bg-white text-slate-500">
                <Loader className="h-7 w-7 animate-spin text-blue-600" />
                <p className="mt-3 text-sm">Cargando respuestas…</p>
              </div>
            ) : error ? (
              <div className="rounded-2xl border border-rose-200 bg-white p-5 text-center">
                <AlertCircle className="mx-auto h-7 w-7 text-rose-600" />
                <p className="mt-2 text-sm font-semibold text-slate-800">No pudimos cargar las respuestas</p>
                <p className="mt-1 text-sm text-slate-500">{error}</p>
                <button type="button" onClick={() => void loadCooperatives()} className="mt-4 inline-flex items-center gap-2 rounded-xl bg-slate-900 px-4 py-2.5 text-sm font-semibold text-white hover:bg-slate-700">
                  <RefreshCw className="h-4 w-4" /> Reintentar
                </button>
              </div>
            ) : cooperatives.length === 0 ? (
              <div className="rounded-2xl border border-dashed border-slate-300 bg-white px-5 py-10 text-center">
                <Clock3 className="mx-auto h-8 w-8 text-slate-400" />
                <p className="mt-3 font-semibold text-slate-800">Aún no hay respuestas</p>
                <p className="mt-1 text-sm text-slate-500">Te avisaremos cuando una cooperativa revise tu solicitud.</p>
              </div>
            ) : (
              <div className="space-y-4">
                {cooperatives.map((coop) => {
                  const status = cooperativeStatus[coop.estado] ?? { label: coop.estado, styles: "bg-slate-100 text-slate-600 ring-slate-200" };
                  const rejected = coop.estado === "RECHAZADA";
                  const needsGuarantor = coop.estado === "SOLICITANDO_GARANTE";
                  const accepted = coop.estado === "ACEPTADA" || selectedCooperativeId === coop.cooperativaId;
                  const anotherAccepted = selectedCooperativeId !== null && selectedCooperativeId !== coop.cooperativaId;
                  const confirming = confirmationCooperativeId === coop.cooperativaId;

                  return (
                    <article key={coop.cooperativaId} className={`overflow-hidden rounded-2xl border bg-white shadow-sm ${rejected ? "border-rose-200" : accepted ? "border-emerald-200" : "border-slate-200"}`}>
                      <div className="flex flex-wrap items-start justify-between gap-3 border-b border-slate-100 px-4 py-4 sm:px-5">
                        <div className="flex min-w-0 items-center gap-3">
                          <div className={`grid h-10 w-10 shrink-0 place-items-center rounded-xl ${rejected ? "bg-rose-50 text-rose-600" : accepted ? "bg-emerald-50 text-emerald-700" : "bg-blue-50 text-blue-700"}`}>
                            {accepted ? <CheckCircle2 className="h-5 w-5" /> : <Building2 className="h-5 w-5" />}
                          </div>
                          <div className="min-w-0">
                            <h4 className="truncate font-bold text-slate-900">{coop.nombreCooperativa || "Cooperativa"}</h4>
                            <p className="mt-0.5 text-xs text-slate-500">{formatDate(coop.fechaActualizacion)}</p>
                          </div>
                        </div>
                        <span className={`rounded-full px-3 py-1 text-xs font-bold ring-1 ${status.styles}`}>{status.label}</span>
                      </div>

                      <div className="p-4 sm:p-5">
                        {rejected ? (
                          <div className="rounded-xl border border-rose-100 bg-rose-50/80 p-4">
                            <p className="text-sm font-bold text-rose-800">Motivos del rechazo</p>
                            {coop.motivosRechazo?.length ? (
                              <ul className="mt-2 space-y-1.5 text-sm text-rose-800">
                                {coop.motivosRechazo.map((reason, index) => <li key={`${index}-${reason}`} className="flex gap-2"><span aria-hidden="true">•</span><span>{reason}</span></li>)}
                              </ul>
                            ) : <p className="mt-1 text-sm text-rose-700">La cooperativa no indicó un motivo adicional.</p>}
                          </div>
                        ) : needsGuarantor ? (
                          <div className="flex flex-col gap-3 rounded-xl border border-amber-100 bg-amber-50 p-4 sm:flex-row sm:items-center sm:justify-between">
                            <p className="text-sm leading-5 text-amber-900">Esta cooperativa necesita información de un garante para continuar.</p>
                            <button type="button" onClick={() => setShowGuaranteeModal(true)} className="shrink-0 rounded-xl bg-amber-600 px-4 py-2.5 text-sm font-bold text-white transition hover:bg-amber-700">Completar garante</button>
                          </div>
                        ) : (
                          <>
                            <div className="grid grid-cols-2 gap-2 sm:grid-cols-4">
                              <FinancialMetric label="Cuota mensual" value={formatCurrency(coop.cuotaMensual)} highlight />
                              <FinancialMetric label="Plazo" value={coop.plazoMeses ? `${coop.plazoMeses} meses` : "—"} />
                              <FinancialMetric label="Tasa anual" value={coop.tasaAnual != null ? `${coop.tasaAnual}%` : "—"} />
                              <FinancialMetric label="Total a pagar" value={formatCurrency(coop.totalPagar)} />
                            </div>
                            {coop.interesTotal != null && <p className="mt-3 text-right text-xs text-slate-500">Interés total: <span className="font-semibold text-slate-700">{formatCurrency(coop.interesTotal)}</span></p>}
                            {coop.requisitos?.length ? (
                              <details className="mt-4 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3">
                                <summary className="flex cursor-pointer list-none items-center gap-2 text-sm font-semibold text-slate-700">
                                  <FileText className="h-4 w-4 text-slate-500" /> Requisitos de la oferta <span className="ml-auto text-xs text-slate-500">{coop.requisitos.length}</span>
                                </summary>
                                <ul className="mt-3 space-y-2 border-t border-slate-200 pt-3 text-sm text-slate-600">
                                  {coop.requisitos.map((requirement, index) => <li key={`${index}-${requirement.title}`} className="flex gap-2"><span className="mt-0.5 text-blue-600">•</span><span><strong className="text-slate-800">{requirement.title}</strong>{requirement.description && <span className="block text-xs text-slate-500">{requirement.description}</span>}</span></li>)}
                                </ul>
                              </details>
                            ) : null}

                            {coop.estado === "PRE_APROBADA" && (
                              <div className="mt-4 border-t border-slate-100 pt-4">
                                {accepted ? (
                                  <div className="flex items-center gap-2 rounded-xl bg-emerald-50 px-4 py-3 text-sm font-semibold text-emerald-800"><CheckCircle2 className="h-5 w-5" /> Oferta aceptada</div>
                                ) : confirming ? (
                                  <div className="rounded-xl border border-blue-100 bg-blue-50 p-4">
                                    <p className="text-sm font-semibold text-slate-800">¿Quieres continuar con esta cooperativa?</p>
                                    <p className="mt-1 text-xs text-slate-600">Al aceptar, no podrás elegir otra cooperativa para esta solicitud.</p>
                                    <div className="mt-3 flex gap-2">
                                      <button type="button" onClick={() => setConfirmationCooperativeId(null)} disabled={acceptingCooperativeId !== null} className="rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-50">Volver</button>
                                      <button type="button" onClick={() => void handleAcceptCooperative(coop.cooperativaId)} disabled={acceptingCooperativeId !== null} className="inline-flex items-center gap-2 rounded-lg bg-blue-700 px-4 py-2 text-sm font-bold text-white hover:bg-blue-800 disabled:opacity-60">
                                        {acceptingCooperativeId === coop.cooperativaId && <Loader className="h-4 w-4 animate-spin" />}
                                        {acceptingCooperativeId === coop.cooperativaId ? "Aceptando…" : "Confirmar oferta"}
                                      </button>
                                    </div>
                                  </div>
                                ) : (
                                  <button type="button" onClick={() => setConfirmationCooperativeId(coop.cooperativaId)} disabled={anotherAccepted || acceptingCooperativeId !== null} className="w-full rounded-xl bg-blue-700 px-4 py-3 text-sm font-bold text-white transition hover:bg-blue-800 disabled:cursor-not-allowed disabled:bg-slate-200 disabled:text-slate-500">
                                    {anotherAccepted ? "Ya aceptaste otra cooperativa" : "Continuar con esta oferta"}
                                  </button>
                                )}
                              </div>
                            )}
                            {coop.estado === "ACEPTADA" && <div className="mt-4 flex items-center gap-2 rounded-xl bg-emerald-50 px-4 py-3 text-sm font-semibold text-emerald-800"><CheckCircle2 className="h-5 w-5" /> Esta oferta ya fue aceptada</div>}
                          </>
                        )}
                      </div>
                    </article>
                  );
                })}
              </div>
            )}

            {acceptError && <div role="alert" className="mt-4 flex items-start gap-2 rounded-xl border border-rose-200 bg-rose-50 p-4 text-sm text-rose-800"><AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />{acceptError}</div>}
          </div>

          <footer className="shrink-0 border-t border-slate-200 bg-white px-5 py-3 text-right sm:px-7">
            <button type="button" onClick={onClose} disabled={acceptingCooperativeId !== null} className="rounded-xl border border-slate-200 px-4 py-2.5 text-sm font-semibold text-slate-700 hover:bg-slate-50 disabled:opacity-50">Cerrar</button>
          </footer>
        </section>
      </div>

      <GuaranteeOnboardingModal
        open={showGuaranteeModal}
        onClose={() => setShowGuaranteeModal(false)}
        onSuccess={() => { void loadCooperatives(); }}
      />
    </>
  );
}

function FinancialMetric({ label, value, highlight = false }: { label: string; value: string; highlight?: boolean }) {
  return (
    <div className={`rounded-xl p-3 ${highlight ? "bg-blue-50" : "bg-slate-50"}`}>
      <p className="text-[11px] font-medium text-slate-500">{label}</p>
      <p className={`mt-1 text-sm font-bold ${highlight ? "text-blue-800" : "text-slate-800"}`}>{value}</p>
    </div>
  );
}
