import { useEffect, useState } from "react";
import { FileText, TrendingUp, Clock, User } from "lucide-react";
import type { ReactNode } from "react";

import Navbar from "../components/layout/Navbar";
import Footer from "../components/layout/Footer";
import PreApprovalModal from "../components/credit/PreApprovalModal";

import {
  getMyCooperativeRequests,
  decideCreditRequest,
  requestGuaranteeForCreditRequest,
  getCooperativeOfferDefaults,
} from "../api/creditRequests.api";
import { getOnboardingForCooperative, type OnboardingCooperativeDetail } from "../api/onboarding.api";
import { getErrorMessage } from "../api/errors";

import type { CooperativeCreditRequest, CooperativeOfferDefaults } from "../types/credit";
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
  ) => {
    try {
      setProcessingId(solicitudId);
      setActionError("");
      await decideCreditRequest(solicitudId, decision, offer);
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
  ) => {
    await handleDecision(solicitudId, CreditDecision.PRE_APROBAR, offer);
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

  const handleApproveWithGuarantee = async (solicitudId: number) => {
    try {
      setProcessingId(solicitudId);
      setActionError("");
      await requestGuaranteeForCreditRequest(solicitudId);
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

  const filteredRequests = requests.filter((r) =>
    filter === "all" ? true : r.estado === filter,
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
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 flex flex-col">
      <Navbar />

      <main className="flex-1 max-w-7xl mx-auto px-4 py-8 w-full">
        <div className="mb-10">
          <h1 className="text-4xl font-bold bg-gradient-to-r from-gray-900 to-gray-600 bg-clip-text text-transparent mb-3">
            Bienvenid@ a tu panel de cooperativa
          </h1>
          <p className="text-gray-600 text-lg">
            Solicitudes de credito o inversiones recibidas
          </p>
        </div>

        {actionError && (
          <div className="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
            {actionError}
          </div>
        )}

        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <StatCard label="Total" value={stats.total} icon={<FileText />} />
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

        <div className="mb-6 bg-white rounded-xl shadow-sm p-4 border border-gray-200">
          <div className="flex gap-3 flex-wrap">
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

        {isLoading ? (
          <Loading />
        ) : filteredRequests.length === 0 ? (
          <Empty />
        ) : (
          <div className="flex flex-col gap-4">
            {filteredRequests.map((r) => (
              <div
                key={r.solicitudId}
                className="bg-white rounded-xl shadow-md p-6 border border-gray-100"
              >
                <div className="flex flex-col lg:flex-row gap-6">
                  <div className="flex-1 space-y-4">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center text-white font-bold">
                          {r.solicitudId}
                        </div>
                        <h3 className="text-xl font-bold text-gray-800">
                          Solicitud #{r.solicitudId}
                        </h3>
                      </div>

                      <span
                        className={`px-4 py-1.5 rounded-full text-xs font-semibold ${
                          r.estado === CreditEstado.ENVIADA ||
                          r.estado === CreditEstado.SOLICITANDO_GARANTE
                            ? "bg-yellow-100 text-yellow-700"
                            : r.estado === CreditEstado.PRE_APROBADA
                              ? "bg-green-100 text-green-700"
                              : "bg-red-100 text-red-700"
                        }`}
                      >
                        {r.estado}
                      </span>
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                      <div className="bg-blue-50 rounded-lg p-4">
                        <p className="text-xs text-blue-700 font-medium mb-1">
                          Monto solicitado
                        </p>
                        <p className="text-2xl font-bold text-gray-900">
                          ${r.montoSolicitado.toLocaleString("es-EC")}
                        </p>
                      </div>

                      <div className="bg-gray-50 rounded-lg p-4">
                        <p className="text-xs text-gray-600 font-medium mb-1">
                          Tipo de credito
                        </p>
                        <p className="text-lg font-semibold text-gray-900">
                          {r.tipo}
                        </p>
                      </div>
                    </div>

                    <div className="bg-gray-50 rounded-lg p-3">
                      <p className="text-xs text-gray-600 font-medium">
                        Fecha de solicitud
                      </p>
                      <p className="text-sm text-gray-800 font-medium mt-1">
                        {new Date(r.fechaSolicitud).toLocaleString("es-EC")}
                      </p>
                    </div>

                    <div className="bg-gray-50 rounded-lg p-4 flex gap-4">
                      <User className="w-10 h-10 text-gray-400" />
                      <div className="flex-1">
                        <p className="font-semibold text-gray-800 text-sm mb-2">
                          Informacion del solicitante
                        </p>
                        <p className="text-gray-600 text-sm">
                          Nombre:{" "}
                          <span className="italic text-gray-400">
                            No disponible
                          </span>
                        </p>
                        <button
                          onClick={() => void handleViewApplicant(r.solicitudId)}
                          disabled={loadingApplicant}
                          className="text-blue-600 text-sm mt-2 hover:underline disabled:cursor-wait disabled:opacity-50"
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
                      className={`w-full py-3 rounded-xl text-sm font-semibold ${
                        r.estado === CreditEstado.ENVIADA
                          ? "bg-green-600 text-white hover:bg-green-700 transition"
                          : "bg-gray-200 text-gray-400"
                      }`}
                    >
                      {processingId === r.solicitudId
                        ? "Procesando..."
                        : "Pre-aprobar"}
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
                          ? "bg-red-600 text-white hover:bg-red-700 transition"
                          : "bg-gray-200 text-gray-400"
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
        <ApplicantDetailModal detail={applicantDetail} onClose={() => setApplicantDetail(null)} />
      )}

      <Footer />
    </div>
  );
}

function ApplicantDetailModal({
  detail,
  onClose,
}: {
  detail: OnboardingCooperativeDetail;
  onClose: () => void;
}) {
  const applicant = detail.personas.find((person) => person.rol === "SOLICITANTE") ?? detail.personas[0];
  if (!applicant) return null;
  const money = (value?: number) => value == null ? "—" : `$${value.toLocaleString("es-EC", { minimumFractionDigits: 2 })}`;

  return (
    <div className="fixed inset-0 z-[80] flex items-center justify-center bg-black/50 p-4">
      <div className="max-h-[90vh] w-full max-w-3xl overflow-y-auto rounded-2xl bg-white p-6 shadow-2xl">
        <div className="mb-6 flex items-start justify-between"><div><h2 className="text-2xl font-bold text-gray-900">Información del solicitante</h2><p className="text-sm text-gray-600">Solicitud #{detail.solicitudId}</p></div><button onClick={onClose} className="rounded-lg px-3 py-2 text-gray-600 hover:bg-gray-100">Cerrar</button></div>
        <div className="grid gap-4 md:grid-cols-2">
          <DetailSection title="Datos personales"><Detail label="Nombre" value={`${applicant.nombres} ${applicant.apellidos}`} /><Detail label="Cédula" value={applicant.cedula} /><Detail label="Fecha de nacimiento" value={applicant.fechaNacimiento} /><Detail label="Estado civil" value={applicant.estadoCivil} /><Detail label="Teléfono" value={applicant.telefono} /></DetailSection>
          <DetailSection title="Trabajo"><Detail label="Ocupación" value={applicant.ocupacion} /><Detail label="Empresa" value={applicant.empresaTrabajo} /><Detail label="Negocio" value={applicant.actividadEconomica?.nombreNegocio} /><Detail label="Tiempo de actividad" value={applicant.actividadEconomica?.tiempoActividad} /></DetailSection>
          <DetailSection title="Dirección"><Detail label="Provincia" value={applicant.direccion?.provincia} /><Detail label="Cantón" value={applicant.direccion?.canton} /><Detail label="Barrio" value={applicant.direccion?.barrio} /><Detail label="Dirección" value={[applicant.direccion?.callePrincipal, applicant.direccion?.numero].filter(Boolean).join(" ")} /><Detail label="Vivienda" value={applicant.direccion?.tipoVivienda} /></DetailSection>
          <DetailSection title="Situación económica"><Detail label="Ingreso mensual" value={money(applicant.ingresoEgreso?.ingresoMensual)} /><Detail label="Egreso mensual" value={money(applicant.ingresoEgreso?.egresoMensual)} /><Detail label="Teléfono del negocio" value={applicant.actividadEconomica?.telefonoNegocio} /></DetailSection>
        </div>
        {applicant.referencias && applicant.referencias.length > 0 && <DetailSection title="Referencias"><div className="space-y-2">{applicant.referencias.map((reference, index) => <p key={`${reference.telefono}-${index}`} className="text-sm text-gray-700">{reference.nombreCompleto} · {reference.tipo} · {reference.telefono}</p>)}</div></DetailSection>}
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
    <div className="bg-white rounded-xl shadow-md p-6 border">
      <div className="flex justify-between items-start">
        <div>
          <p className="text-sm text-gray-600 font-medium mb-2">{label}</p>
          <p className="text-4xl font-bold text-gray-900">{value}</p>
        </div>
        <div className="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center text-white">
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
        active ? "bg-primary-600 text-white" : "bg-white border"
      }`}
    >
      {label}
    </button>
  );
}

function Loading() {
  return (
    <div className="bg-white rounded-xl shadow-md p-16 text-center">
      <div className="animate-spin rounded-full h-16 w-16 border-4 border-blue-100 border-t-blue-600 mx-auto" />
      <p className="mt-6 text-gray-600 font-medium text-lg">
        Cargando solicitudes...
      </p>
    </div>
  );
}

function Empty() {
  return (
    <div className="bg-white rounded-xl shadow-md p-16 text-center">
      <FileText className="w-10 h-10 text-gray-400 mx-auto mb-4" />
      <p className="text-xl font-semibold text-gray-700">No hay solicitudes</p>
    </div>
  );
}
