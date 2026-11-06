import type { CooperativeCreditRequest, CooperativeOfferDefaults, CreditRequirement } from "../types/credit";
import { useEffect, useState } from "react";
import { FileText, TrendingUp, Clock, User, ArrowUpRight, Search, SlidersHorizontal, CheckCircle2 } from "lucide-react";
import type { ReactNode } from "react";

import Navbar from "../components/layout/Navbar";
import Footer from "../components/layout/Footer";
import PreApprovalModal from "../components/credit/PreApprovalModal";

import {
  getMyCooperativeRequests,
  decideCreditRequest,
  requestGuaranteeForCreditRequest,
  decideGuaranteeForCreditRequest,
  type GuaranteeDecision,
  getCooperativeOfferDefaults,
} from "../api/creditRequests.api";
import { getOnboardingForCooperative, type OnboardingCooperativeDetail } from "../api/onboarding.api";
import { getErrorMessage } from "../api/errors";

import { CreditEstado } from "../types/creditEstado";
import { CreditDecision } from "../types/creditDecision";

type Filter = "all" | CreditEstado;

interface StatCardProps {
  label: string;
  value: number;
  icon: ReactNode;
}

interface FilterButtonProps {
  label: string;
  active: boolean;
  onClick: () => void;
}

export default function DashboardCooperative() {
  const [requests, setRequests] = useState<CooperativeCreditRequest[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [filter, setFilter] = useState<Filter>("all");
  const [processingId, setProcessingId] = useState<number | null>(null);
  const [actionError, setActionError] = useState("");
  const [showPreApprovalModal, setShowPreApprovalModal] = useState(false);
  const [selectedRequest, setSelectedRequest] =
    useState<CooperativeCreditRequest | null>(null);
  const [offerDefaults, setOfferDefaults] = useState<CooperativeOfferDefaults | null>(null);
  const [loadingOfferDefaults, setLoadingOfferDefaults] = useState(false);
  const [applicantDetail, setApplicantDetail] = useState<OnboardingCooperativeDetail | null>(null);
  const [loadingApplicant, setLoadingApplicant] = useState(false);
  const [search, setSearch] = useState("");

  useEffect(() => {
    void loadRequests();
  }, []);

  const loadRequests = async () => {
    setIsLoading(true);
    setActionError("");
    try {
      const data = await getMyCooperativeRequests();
      setRequests(data);
    } catch (error) {
      setActionError(
        getErrorMessage(error, "No se pudieron cargar las solicitudes."),
      );
    } finally {
      setIsLoading(false);
    }
  };

  const handleDecision = async (
    solicitudId: number,
    decision: CreditDecision,
    offer?: { tasaAnual: number; plazoMeses: number },
    requirements?: CreditRequirement[],
  ) => {
    try {
      setProcessingId(solicitudId);
      setActionError("");
      await decideCreditRequest(solicitudId, decision, offer, requirements);
      await loadRequests();
    } catch (error) {
      setActionError(
        getErrorMessage(error, "No se pudo registrar la decision."),
      );
      throw error;
    } finally {
      setProcessingId(null);
    }
  };

  const handleOpenPreApprovalModal = async (request: CooperativeCreditRequest) => {
    setSelectedRequest(request);
    setShowPreApprovalModal(true);
    setOfferDefaults(null);
    setLoadingOfferDefaults(true);
    try {
      setOfferDefaults(await getCooperativeOfferDefaults(request.solicitudId));
    } catch (error) {
      setActionError(getErrorMessage(error, "No se pudo cargar la tasa estándar de la cooperativa."));
    } finally {
      setLoadingOfferDefaults(false);
    }
  };

  const handleClosePreApprovalModal = () => {
    setShowPreApprovalModal(false);
    setSelectedRequest(null);
    setOfferDefaults(null);
  };

  const handleApproveWithoutGuarantee = async (
    solicitudId: number,
    offer: { tasaAnual: number; plazoMeses: number },
    requirements: CreditRequirement[],
  ) => {
    await handleDecision(solicitudId, CreditDecision.PRE_APROBAR, offer, requirements);
  };

  const handleViewApplicant = async (solicitudId: number) => {
    setLoadingApplicant(true);
    setActionError("");
    try {
      setApplicantDetail(await getOnboardingForCooperative(solicitudId));
    } catch (error) {
      setActionError(getErrorMessage(error, "No se pudo cargar la información del solicitante."));
    } finally {
      setLoadingApplicant(false);
    }
  };

  const handleApproveWithGuarantee = async (solicitudId: number, requirements: CreditRequirement[]) => {
    try {
      setProcessingId(solicitudId);
      setActionError("");
      await requestGuaranteeForCreditRequest(solicitudId, requirements);
      await loadRequests();
    } catch (error) {
      setActionError(
        getErrorMessage(error, "No se pudo registrar la solicitud de garante."),
      );
      throw error;
    } finally {
      setProcessingId(null);
    }
  };

  const handleGuaranteeDecision = async (
    solicitudId: number,
    decision: GuaranteeDecision,
  ) => {
    try {
      setProcessingId(solicitudId);
      setActionError("");
      await decideGuaranteeForCreditRequest(solicitudId, decision);
      setApplicantDetail(null);
      await loadRequests();
    } catch (error) {
      setActionError(
        getErrorMessage(error, "No se pudo registrar la decisión del garante."),
      );
    } finally {
      setProcessingId(null);
    }
  };

  const filteredRequests = requests.filter((r) =>
    (filter === "all" || r.estado === filter) &&
    `${r.solicitudId} ${r.nombreSolicitante ?? ""} ${r.tipo}`.toLowerCase().includes(search.toLowerCase()),
  );

  const stats = {
    total: requests.length,
    enviada: requests.filter((r) => r.estado === CreditEstado.ENVIADA).length,
    preAprobada: requests.filter(
      (r) => r.estado === CreditEstado.PRE_APROBADA,
    ).length,
    rechazada: requests.filter((r) => r.estado === CreditEstado.RECHAZADA)
      .length,
  };

  return (
    <div className="portal-shell flex min-h-screen flex-col bg-[#f5f8fc]">
      <Navbar />

      <main className="flex-1 max-w-7xl mx-auto px-4 py-8 w-full">
        <div className="relative mb-8 overflow-hidden rounded-[2rem] bg-gradient-to-br from-[#0b1d42] via-[#123f77] to-[#0ea5a4] p-6 text-white shadow-2xl shadow-cyan-950/20 sm:p-10">
          <div className="absolute -right-20 -top-32 h-80 w-80 rounded-full border-[34px] border-white/10" />
          <p className="mb-2 text-sm font-semibold uppercase tracking-[0.18em] text-cyan-100">Centro de operaciones</p>
          <div className="flex flex-col justify-between gap-5 sm:flex-row sm:items-end">
            <div>
              <h1 className="text-3xl font-extrabold tracking-tight sm:text-4xl">Panel de cooperativa</h1>
              <p className="mt-2 text-blue-100">Gestiona solicitudes, evalúa perfiles y toma decisiones con claridad.</p>
            </div>
            <div className="rounded-2xl border border-white/20 bg-white/10 px-4 py-3 text-sm backdrop-blur">
              <span className="block text-blue-100">Bandeja actualizada</span>
              <span className="font-semibold">{requests.length} solicitudes registradas</span>
            </div>
          </div>
        </div>

        {actionError && (
          <div className="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {actionError}
          </div>
        )}

        <div className="mb-8 grid grid-cols-2 gap-3 lg:grid-cols-4">
          <StatCard label="Total recibidas" value={stats.total} icon={<FileText />} />
          <StatCard label="Enviadas" value={stats.enviada} icon={<Clock />} />
          <StatCard
            label="Pre aprobadas"
            value={stats.preAprobada}
            icon={<TrendingUp />}
          />
          <StatCard
            label="Rechazadas"
            value={stats.rechazada}
            icon={<TrendingUp />}
          />
        </div>

        <div className="portal-panel mb-6 p-4 sm:p-5">
          <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div className="relative w-full lg:max-w-sm">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
              <input value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Buscar por solicitante o número" className="w-full rounded-xl border border-slate-200 bg-slate-50 py-2.5 pl-10 pr-4 text-sm outline-none transition focus:border-cyan-400 focus:bg-white focus:ring-4 focus:ring-cyan-100" />
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <SlidersHorizontal className="mr-1 h-4 w-4 text-slate-400" />
            <FilterButton
              label="Todas"
              active={filter === "all"}
              onClick={() => setFilter("all")}
            />
            <FilterButton
              label="Enviadas"
              active={filter === CreditEstado.ENVIADA}
              onClick={() => setFilter(CreditEstado.ENVIADA)}
            />
            <FilterButton
              label="Pre aprobadas"
              active={filter === CreditEstado.PRE_APROBADA}
              onClick={() => setFilter(CreditEstado.PRE_APROBADA)}
            />
            <FilterButton
              label="Rechazadas"
              active={filter === CreditEstado.RECHAZADA}
              onClick={() => setFilter(CreditEstado.RECHAZADA)}
            />
            </div>
          </div>
        </div>

        {isLoading ? (
          <Loading />
        ) : filteredRequests.length === 0 ? (
          <Empty />
        ) : (
          <div className="flex flex-col gap-4">
            {filteredRequests.map((r) => (
              <div
                key={r.solicitudId}
                className="portal-panel p-5 transition hover:-translate-y-0.5 hover:border-cyan-200 hover:shadow-xl sm:p-6"
              >
                <div className="flex flex-col lg:flex-row gap-6">
                  <div className="flex-1 space-y-4">
                    <div className="flex items-center justify-between gap-3">
                      <div className="flex items-center gap-3">
                        <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-[#123f77] font-bold text-white shadow-lg shadow-blue-900/20">
                          {r.solicitudId}
                        </div>
                        <div>
                          <p className="text-xs font-bold uppercase tracking-[0.14em] text-slate-400">Expediente financiero</p>
                          <h3 className="text-xl font-bold text-slate-900">Solicitud #{r.solicitudId}</h3>
                        </div>
                      </div>

                      <span
                        className={`px-4 py-1.5 rounded-full text-xs font-semibold ${
                          r.estado === CreditEstado.ENVIADA ||
                          r.estado === CreditEstado.SOLICITANDO_GARANTE
                            ? "bg-amber-50 text-amber-700 ring-1 ring-amber-200"
                            : r.estado === CreditEstado.PRE_APROBADA
                              ? "bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200"
                              : "bg-red-50 text-red-700 ring-1 ring-red-200"
                        }`}
                      >
                        {r.estado}
                      </span>
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                      <div className="rounded-xl border border-cyan-100 bg-cyan-50 p-4">
                        <p className="mb-1 text-xs font-medium text-cyan-700">
                          Monto solicitado
                        </p>
                        <p className="text-2xl font-bold text-slate-900">
                          ${r.montoSolicitado.toLocaleString("es-EC")}
                        </p>
                      </div>

                      <div className="rounded-xl border border-slate-100 bg-slate-50 p-4">
                        <p className="mb-1 text-xs font-medium text-slate-500">
                          Tipo de credito
                        </p>
                        <p className="text-lg font-semibold text-slate-900">
                          {r.tipo}
                        </p>
                      </div>
                    </div>

                    <div className="flex items-center justify-between rounded-xl bg-slate-50 p-3">
                      <div>
                      <p className="text-xs text-gray-600 font-medium">
                        Fecha de solicitud
                      </p>
                      <p className="text-sm text-gray-800 font-medium mt-1">
                        {new Date(r.fechaSolicitud).toLocaleString("es-EC")}
                      </p>
                      </div>
                      <CheckCircle2 className="h-5 w-5 text-emerald-500" />
                    </div>

                    <div className="flex gap-4 rounded-xl border border-cyan-100 bg-cyan-50 p-4">
                      <User className="h-10 w-10 text-cyan-700" />
                      <div className="flex-1">
                        <p className="font-semibold text-gray-800 text-sm mb-2">
                          Datos del solicitante
                        </p>
                        <p className="text-base font-bold text-slate-900">
                          {r.nombreSolicitante || "Nombre pendiente de onboarding"}
                        </p>
                        <p className="mt-1 text-sm text-slate-600">
                          Cédula: <span className="font-bold tracking-wide">{r.cedulaSolicitante || "Pendiente"}</span>
                        </p>
                        <button
                          onClick={() => void handleViewApplicant(r.solicitudId)}
                          disabled={loadingApplicant}
                          className="mt-2 text-sm font-semibold text-[#123f77] hover:underline disabled:cursor-wait disabled:opacity-50"
                        >
                          {loadingApplicant ? "Cargando información..." : "Ver información completa"}
                        </button>
                      </div>
                    </div>
                  </div>

                  <div className="lg:w-64 flex flex-col justify-center gap-3">
                    <button
                      onClick={() => void handleOpenPreApprovalModal(r)}
                      disabled={
                        r.estado !== CreditEstado.ENVIADA ||
                        processingId === r.solicitudId
                      }
                      className={`flex w-full items-center justify-center gap-2 rounded-xl py-3 text-sm font-semibold ${
                        r.estado === CreditEstado.ENVIADA
                          ? "bg-emerald-600 text-white transition hover:bg-emerald-700"
                          : "bg-slate-100 text-slate-400"
                      }`}
                    >
                      {processingId === r.solicitudId
                        ? "Procesando..."
                        : "Pre-aprobar"}
                      {r.estado === CreditEstado.ENVIADA && <ArrowUpRight className="h-4 w-4" />}
                    </button>

                    <button
                      onClick={() =>
                        void handleDecision(
                          r.solicitudId,
                          CreditDecision.RECHAZAR,
                        )
                      }
                      disabled={
                        r.estado !== CreditEstado.ENVIADA ||
                        processingId === r.solicitudId
                      }
                      className={`w-full py-3 rounded-xl text-sm font-semibold ${
                        r.estado === CreditEstado.ENVIADA
                          ? "bg-red-600 text-white transition hover:bg-red-700"
                          : "bg-slate-100 text-slate-400"
                      }`}
                    >
                      {processingId === r.solicitudId
                        ? "Procesando..."
                        : "Rechazar"}
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>

      {selectedRequest && (
        <PreApprovalModal
          open={showPreApprovalModal}
          onClose={handleClosePreApprovalModal}
          solicitudId={selectedRequest.solicitudId}
          monto={selectedRequest.montoSolicitado}
          tipo={selectedRequest.tipo}
          defaults={offerDefaults}
          loadingDefaults={loadingOfferDefaults}
          onApproveWithoutGuarantee={handleApproveWithoutGuarantee}
          onApproveWithGuarantee={handleApproveWithGuarantee}
          isLoading={processingId === selectedRequest.solicitudId}
        />
      )}

      {applicantDetail && (
        <ApplicantDetailModal
          detail={applicantDetail}
          onClose={() => setApplicantDetail(null)}
          onGuaranteeDecision={(decision) =>
            void handleGuaranteeDecision(applicantDetail.solicitudId, decision)
          }
          isProcessing={processingId === applicantDetail.solicitudId}
        />
      )}

      <Footer />
    </div>
  );
}

function ApplicantDetailModal({
  detail,
  onClose,
  onGuaranteeDecision,
  isProcessing,
}: {
  detail: OnboardingCooperativeDetail;
  onClose: () => void;
  onGuaranteeDecision?: (decision: GuaranteeDecision) => void;
  isProcessing?: boolean;
}) {
  if (detail.personas.length === 0) return null;
  const money = (value?: number) => value == null ? "—" : `$${value.toLocaleString("es-EC", { minimumFractionDigits: 2 })}`;
  const guarantee = detail.personas.find((person) => person.rol === "GARANTE");

  return (
    <div className="fixed inset-0 z-[80] flex items-center justify-center bg-black/50 p-4">
      <div className="max-h-[90vh] w-full max-w-3xl overflow-y-auto rounded-2xl bg-white p-6 shadow-2xl">
        <div className="mb-6 flex items-start justify-between"><div><h2 className="text-2xl font-bold text-gray-900">Información de la solicitud</h2><p className="text-sm text-gray-600">Solicitud #{detail.solicitudId}</p></div><button onClick={onClose} className="rounded-lg px-3 py-2 text-gray-600 hover:bg-gray-100">Cerrar</button></div>
        {detail.personas.map((person) => (
          <div key={`${person.rol}-${person.cedula}`} className="mb-6">
            <h3 className="mb-3 text-lg font-bold text-gray-800">
              {person.rol === "GARANTE" ? "Información del garante" : "Información del solicitante"}
            </h3>
            <div className="grid gap-4 md:grid-cols-2">
              <DetailSection title="Datos personales"><Detail label="Nombre" value={`${person.nombres} ${person.apellidos}`} /><Detail label="Cédula" value={person.cedula} /><Detail label="Fecha de nacimiento" value={person.fechaNacimiento} /><Detail label="Estado civil" value={person.estadoCivil} /><Detail label="Teléfono" value={person.telefono} /></DetailSection>
              <DetailSection title="Trabajo"><Detail label="Ocupación" value={person.ocupacion} /><Detail label="Empresa" value={person.empresaTrabajo} /><Detail label="Negocio" value={person.actividadEconomica?.nombreNegocio} /><Detail label="Tiempo de actividad" value={person.actividadEconomica?.tiempoActividad} /></DetailSection>
              <DetailSection title="Dirección"><Detail label="Provincia" value={person.direccion?.provincia} /><Detail label="Cantón" value={person.direccion?.canton} /><Detail label="Barrio" value={person.direccion?.barrio} /><Detail label="Dirección" value={[person.direccion?.callePrincipal, person.direccion?.numero].filter(Boolean).join(" ")} /><Detail label="Vivienda" value={person.direccion?.tipoVivienda} /></DetailSection>
              <DetailSection title="Situación económica"><Detail label="Ingreso mensual" value={money(person.ingresoEgreso?.ingresoMensual)} /><Detail label="Egreso mensual" value={money(person.ingresoEgreso?.egresoMensual)} /><Detail label="Teléfono del negocio" value={person.actividadEconomica?.telefonoNegocio} /></DetailSection>
            </div>
            {person.referencias && person.referencias.length > 0 && <DetailSection title="Referencias"><div className="space-y-2">{person.referencias.map((reference, index) => <p key={`${reference.telefono}-${index}`} className="text-sm text-gray-700">{reference.nombreCompleto} · {reference.tipo} · {reference.telefono}</p>)}</div></DetailSection>}
          </div>
        ))}
        {guarantee && onGuaranteeDecision && (
          <div className="flex flex-col gap-3 border-t border-gray-200 pt-5 sm:flex-row sm:justify-end">
            <button
              onClick={() => onGuaranteeDecision("SOLICITAR_NUEVO")}
              disabled={isProcessing}
              className="rounded-lg bg-amber-600 px-4 py-2 font-semibold text-white hover:bg-amber-700 disabled:opacity-50"
            >
              Solicitar nuevo garante
            </button>
            <button
              onClick={() => onGuaranteeDecision("ACEPTAR")}
              disabled={isProcessing}
              className="rounded-lg bg-green-600 px-4 py-2 font-semibold text-white hover:bg-green-700 disabled:opacity-50"
            >
              Aceptar garante
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

function DetailSection({ title, children }: { title: string; children: ReactNode }) {
  return <section className="rounded-xl border border-gray-200 p-4"><h3 className="mb-3 font-semibold text-gray-900">{title}</h3>{children}</section>;
}

function Detail({ label, value }: { label: string; value?: string }) {
  return <p className="mb-2 text-sm"><span className="text-gray-500">{label}: </span><span className="font-medium text-gray-800">{value || "—"}</span></p>;
}

function StatCard({ label, value, icon }: StatCardProps) {
  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
      <div className="flex justify-between items-start">
        <div>
          <p className="mb-2 text-sm font-medium text-slate-500">{label}</p>
          <p className="text-4xl font-extrabold text-slate-900">{value}</p>
        </div>
        <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-cyan-50 text-cyan-700">
          {icon}
        </div>
      </div>
    </div>
  );
}

function FilterButton({ label, active, onClick }: FilterButtonProps) {
  return (
    <button
      onClick={onClick}
      className={`px-5 py-2.5 rounded-xl font-medium ${
        active ? "bg-[#123f77] text-white shadow-md" : "border border-slate-200 bg-white text-slate-600 hover:bg-slate-50"
      }`}
    >
      {label}
    </button>
  );
}

function Loading() {
  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-16 text-center shadow-sm">
      <div className="mx-auto h-16 w-16 animate-spin rounded-full border-4 border-cyan-100 border-t-cyan-600" />
      <p className="mt-6 text-lg font-medium text-slate-600">
        Cargando solicitudes...
      </p>
    </div>
  );
}

function Empty() {
  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-16 text-center shadow-sm">
      <FileText className="mx-auto mb-4 h-10 w-10 text-slate-400" />
      <p className="text-xl font-semibold text-slate-700">No hay solicitudes</p>
    </div>
  );
}
