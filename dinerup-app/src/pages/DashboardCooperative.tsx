import { useEffect, useMemo, useRef, useState, type ReactNode } from "react";
import {
  Activity, AlertCircle, BarChart3, Bell, CheckCircle2, ChevronRight,
  Clock3, FileCheck2, FileText, LayoutDashboard, LogOut, Menu, Search,
  Settings2, ShieldCheck, SlidersHorizontal, TrendingUp, User, Users, X,
} from "lucide-react";
import type { CooperativeCreditRequest, CooperativeOfferDefaults, CreditRequirement } from "../types/credit";
import { decideCreditRequest, decideGuaranteeForCreditRequest, getCooperativeOfferDefaults, getCreditRequestTimeline, getGuarantorHistoryForCooperative, requestGuaranteeForCreditRequest, type CreditGuarantorHistoryItem, type CreditTimelineEvent, type GuaranteeDecision } from "../api/creditRequests.api";
import { getErrorMessage } from "../api/errors";
import { getOnboardingForCooperative, type OnboardingCooperativeDetail } from "../api/onboarding.api";
import { useAuth } from "../context/useAuth";
import { CreditDecision } from "../types/creditDecision";
import { CreditEstado } from "../types/creditEstado";
import PreApprovalModal from "../components/credit/PreApprovalModal";
import RejectCreditModal from "../components/credit/RejectCreditModal";
import RejectGuarantorModal from "../components/credit/RejectGuarantorModal";
import CooperativeNotificationCenter from "../components/cooperative/CooperativeNotificationCenter";
import { useCooperativeLiveUpdates, type CooperativeNotification } from "../hooks/useCooperativeLiveUpdates";

type Filter = "all" | CreditEstado;
type Section = "overview" | "requests" | "analytics" | "settings";
type Stats = { total: number; pending: number; approved: number; rejected: number };

const navItems: { id: Section; label: string; icon: typeof LayoutDashboard }[] = [
  { id: "overview", label: "Resumen", icon: LayoutDashboard },
  { id: "requests", label: "Solicitudes", icon: FileText },
  { id: "analytics", label: "Rendimiento", icon: BarChart3 },
  { id: "settings", label: "Configuración", icon: Settings2 },
];

export default function DashboardCooperative() {
  const { user, logout } = useAuth();
  const { requests, isLoading, connectionError, lastUpdatedAt, notifications, unreadCount, markRead, markAllRead, refresh } = useCooperativeLiveUpdates();
  const [section, setSection] = useState<Section>("overview");
  const [filter, setFilter] = useState<Filter>("all");
  const [search, setSearch] = useState("");
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [processingId, setProcessingId] = useState<number | null>(null);
  const [actionError, setActionError] = useState("");
  const [selectedRequest, setSelectedRequest] = useState<CooperativeCreditRequest | null>(null);
  const [offerDefaults, setOfferDefaults] = useState<CooperativeOfferDefaults | null>(null);
  const [showPreApproval, setShowPreApproval] = useState(false);
  const [rejectingId, setRejectingId] = useState<number | null>(null);
  const [rejectingGuaranteeId, setRejectingGuaranteeId] = useState<number | null>(null);
  const [guaranteeDecisionAfterReasons, setGuaranteeDecisionAfterReasons] = useState<"SOLICITAR_CORRECCION" | "RECHAZAR_GARANTE">("SOLICITAR_CORRECCION");
  const [rejectingCreditDuringGuaranteeId, setRejectingCreditDuringGuaranteeId] = useState<number | null>(null);
  const [loadingOffer, setLoadingOffer] = useState(false);
  const [applicantDetail, setApplicantDetail] = useState<OnboardingCooperativeDetail | null>(null);
  const [timeline, setTimeline] = useState<CreditTimelineEvent[]>([]);
  const [guarantorHistory, setGuarantorHistory] = useState<CreditGuarantorHistoryItem[]>([]);
  const [showTimeline, setShowTimeline] = useState(false);
  const seenToastIds = useRef(new Set<string>());
  const [toasts, setToasts] = useState<CooperativeNotification[]>([]);

  useEffect(() => {
    const newNotifications = notifications.filter((notification) => !seenToastIds.current.has(notification.id));
    if (!newNotifications.length) return;
    for (const notification of newNotifications) seenToastIds.current.add(notification.id);
    setToasts((current) => [...newNotifications, ...current].slice(0, 4));
    for (const notification of newNotifications) {
      window.setTimeout(() => setToasts((current) => current.filter((item) => item.id !== notification.id)), 7000);
    }
  }, [notifications]);

  const stats = useMemo<Stats>(() => ({
    total: requests.length,
    pending: requests.filter((request) => request.estado === CreditEstado.ENVIADA).length,
    approved: requests.filter((request) => request.estado === CreditEstado.PRE_APROBADA).length,
    rejected: requests.filter((request) => request.estado === CreditEstado.RECHAZADA).length,
  }), [requests]);

  const filteredRequests = useMemo(() => requests.filter((request) => {
    const matchesStatus = filter === "all" || request.estado === filter;
    const haystack = `${request.solicitudId} ${request.nombreSolicitante ?? ""} ${request.tipo}`.toLowerCase();
    return matchesStatus && haystack.includes(search.toLowerCase());
  }), [filter, requests, search]);

  const openSection = (next: Section) => { setSection(next); setSidebarOpen(false); };
  const handleDecision = async (id: number, decision: CreditDecision, offer?: { tasaAnual: number; plazoMeses: number }, requirements?: CreditRequirement[], motivosRechazo?: string[], motivoRechazoOtro?: string) => {
    try { setProcessingId(id); setActionError(""); await decideCreditRequest(id, decision, offer, requirements, motivosRechazo, motivoRechazoOtro); await refresh(); }
    catch (error) { setActionError(getErrorMessage(error, "No se pudo registrar la decisión.")); throw error; }
    finally { setProcessingId(null); }
  };
  const openPreApproval = async (request: CooperativeCreditRequest) => {
    setSelectedRequest(request); setShowPreApproval(true); setLoadingOffer(true); setOfferDefaults(null);
    try { setOfferDefaults(await getCooperativeOfferDefaults(request.solicitudId)); }
    catch (error) { setActionError(getErrorMessage(error, "No se pudo cargar la tasa estándar.")); }
    finally { setLoadingOffer(false); }
  };
  const viewApplicant = async (id: number) => {
    try {
      const onboarding = await getOnboardingForCooperative(id);
      // This route receives the credit request ID. The onboarding response's
      // solicitudId can be the onboarding record ID, so keep the route ID for
      // all guarantee decisions made from this modal.
      setApplicantDetail({ ...onboarding, solicitudId: id });
      const [events, history] = await Promise.all([
        getCreditRequestTimeline(id),
        getGuarantorHistoryForCooperative(id),
      ]);
      setTimeline(events);
      setGuarantorHistory(history);
      setShowTimeline(true);
    }
    catch (error) { setActionError(getErrorMessage(error, "No se pudo cargar la información del solicitante.")); }
  };
  const requestGuarantee = async (id: number, requirements: CreditRequirement[]) => {
    try { setProcessingId(id); await requestGuaranteeForCreditRequest(id, requirements); await refresh(); }
    catch (error) { setActionError(getErrorMessage(error, "No se pudo solicitar el garante.")); throw error; }
    finally { setProcessingId(null); }
  };
  const decideGuarantee = async (id: number, decision: GuaranteeDecision, reasons: string[] = [], otherReason = "", observation = "") => {
    try { setProcessingId(id); await decideGuaranteeForCreditRequest(id, decision, reasons, otherReason, observation); setApplicantDetail(null); setRejectingGuaranteeId(null); setRejectingCreditDuringGuaranteeId(null); await refresh(); }
    catch (error) { setActionError(getErrorMessage(error, "No se pudo registrar la decisión del garante.")); }
    finally { setProcessingId(null); }
  };
  const rejectRequest = async (reasons: string[], otherReason: string) => {
    if (rejectingId == null) return;
    try { await handleDecision(rejectingId, CreditDecision.RECHAZAR, undefined, undefined, reasons, otherReason); setRejectingId(null); }
    catch (error) { setActionError(getErrorMessage(error, "No se pudo registrar el rechazo.")); }
  };

  return <div className="coop-dashboard min-h-screen bg-[#f5f7f8] text-slate-900">
    <div className="flex min-h-screen">
      <aside className={`fixed inset-y-0 left-0 z-50 flex w-[272px] -translate-x-full flex-col bg-[#10283f] text-white transition-transform duration-300 lg:static lg:translate-x-0 ${sidebarOpen ? "translate-x-0" : ""}`}>
        <div className="flex h-24 items-center gap-3 border-b border-white/10 px-7"><div className="grid h-11 w-11 place-items-center rounded-2xl bg-[#d6ad61] text-xl font-black text-[#10283f]">D</div><div><p className="text-lg font-extrabold">DINEROP</p><p className="text-[10px] font-bold uppercase tracking-[0.2em] text-slate-300">Panel cooperativo</p></div><button onClick={() => setSidebarOpen(false)} className="ml-auto lg:hidden" aria-label="Cerrar menú"><X /></button></div>
        <div className="px-5 py-7"><p className="mb-3 px-3 text-[10px] font-bold uppercase tracking-[0.2em] text-[#b8cbd2]">Centro de operaciones</p><nav className="space-y-1">{navItems.map(({ id, label, icon: Icon }) => <button key={id} onClick={() => openSection(id)} className={`flex w-full items-center gap-3 rounded-xl px-3 py-3 text-left text-sm font-semibold transition ${section === id ? "bg-[#f7f9fa] text-[#173b57]" : "text-slate-200 hover:bg-white/10"}`}><Icon className="h-[18px] w-[18px]" />{label}{id === "requests" && stats.pending > 0 && <span className="ml-auto rounded-full bg-[#d6ad61] px-2 py-0.5 text-[10px] font-black text-[#10283f]">{stats.pending}</span>}</button>)}</nav></div>
        <div className="mt-auto p-5"><div className="rounded-2xl border border-white/10 bg-white/5 p-4"><div className="flex items-center gap-2 text-xs font-semibold text-slate-200"><ShieldCheck className="h-4 w-4 text-[#d6ad61]" />Entorno seguro</div><p className="mt-3 text-xs leading-5 text-slate-300/80">Gestiona solicitudes y acompaña cada decisión con información clara.</p></div><button onClick={logout} className="mt-5 flex items-center gap-3 px-3 py-3 text-sm font-semibold text-slate-200 hover:text-white"><LogOut className="h-4 w-4" />Cerrar sesión</button></div>
      </aside>
      {sidebarOpen && <button className="fixed inset-0 z-40 bg-slate-950/50 lg:hidden" onClick={() => setSidebarOpen(false)} aria-label="Cerrar menú" />}
      <div className="min-w-0 flex-1">
        <header className="sticky top-0 z-30 flex h-20 items-center justify-between border-b border-slate-200/80 bg-white/90 px-4 backdrop-blur-xl sm:px-7"><div className="flex items-center gap-3"><button onClick={() => setSidebarOpen(true)} className="grid h-10 w-10 place-items-center rounded-xl border border-slate-200 text-slate-600 lg:hidden" aria-label="Abrir menú"><Menu className="h-5 w-5" /></button><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">{navItems.find((item) => item.id === section)?.label}</p><h1 className="text-xl font-extrabold tracking-tight text-[#173b57] sm:text-2xl">Hola, {String(user?.name ?? "equipo").split(" ")[0]}</h1></div></div><div className="flex items-center gap-3"><div className="hidden text-right sm:block"><p className={`text-[11px] font-semibold ${connectionError ? "text-amber-700" : "text-emerald-700"}`}>{connectionError ? "Sin conexión con el servidor" : "Actualización automática activa"}</p><p className="text-[10px] text-slate-400">{lastUpdatedAt ? `Actualizado ${new Date(lastUpdatedAt).toLocaleTimeString("es-EC", { hour: "2-digit", minute: "2-digit" })}` : "Conectando…"}</p></div><CooperativeNotificationCenter notifications={notifications} unreadCount={unreadCount} onMarkRead={markRead} onMarkAllRead={markAllRead} onOpenNotification={(notification) => { setFilter("all"); setSearch(String(notification.requestId)); openSection("requests"); }} /><div className="hidden items-center gap-3 border-l border-slate-200 pl-4 sm:flex"><div className="grid h-10 w-10 place-items-center rounded-xl bg-[#edf3f4] text-[#1f6577]"><Users className="h-5 w-5" /></div><div><p className="max-w-[150px] truncate text-sm font-bold">{String(user?.name ?? "Cooperativa")}</p><p className="text-xs text-slate-500">Cuenta cooperativa</p></div></div></div></header>
        <main className="mx-auto w-full max-w-[1500px] px-4 py-6 sm:px-7 sm:py-8">{actionError && <div className="mb-6 flex items-center gap-3 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-700"><AlertCircle className="h-5 w-5" />{actionError}</div>}{section === "overview" && <Overview requests={requests} stats={stats} isLoading={isLoading} onOpenRequests={() => openSection("requests")} onViewApplicant={viewApplicant} onPreApprove={openPreApproval} />}{section === "requests" && <RequestsView requests={filteredRequests} stats={stats} isLoading={isLoading} filter={filter} search={search} setFilter={setFilter} setSearch={setSearch} processingId={processingId} onViewApplicant={viewApplicant} onPreApprove={openPreApproval} onReject={setRejectingId} />}{section === "analytics" && <Analytics stats={stats} />}{section === "settings" && <SettingsView name={String(user?.name ?? "Cooperativa")} />}</main>
      </div>
    </div>
    {selectedRequest && <PreApprovalModal open={showPreApproval} onClose={() => { setShowPreApproval(false); setSelectedRequest(null); }} solicitudId={selectedRequest.solicitudId} monto={selectedRequest.montoSolicitado} tipo={selectedRequest.tipo} defaults={offerDefaults} loadingDefaults={loadingOffer} onApproveWithoutGuarantee={(id, offer, requirements) => handleDecision(id, CreditDecision.PRE_APROBAR, offer, requirements)} onApproveWithGuarantee={requestGuarantee} isLoading={processingId === selectedRequest.solicitudId} />}
    <RejectCreditModal open={rejectingId !== null} loading={processingId === rejectingId} onClose={() => setRejectingId(null)} onConfirm={rejectRequest} />
    {applicantDetail && <ApplicantModal detail={applicantDetail} history={guarantorHistory} onClose={() => { setApplicantDetail(null); setTimeline([]); setGuarantorHistory([]); }} onDecision={(decision) => { if (decision === "SOLICITAR_NUEVO" || decision === "SOLICITAR_CORRECCION" || decision === "RECHAZAR_GARANTE") { setGuaranteeDecisionAfterReasons(decision === "RECHAZAR_GARANTE" ? "RECHAZAR_GARANTE" : "SOLICITAR_CORRECCION"); setRejectingGuaranteeId(applicantDetail.solicitudId); } else if (decision === "RECHAZAR_CREDITO" || decision === "RECHAZAR_SOLICITUD") setRejectingCreditDuringGuaranteeId(applicantDetail.solicitudId); else void decideGuarantee(applicantDetail.solicitudId, decision); }} processing={processingId === applicantDetail.solicitudId} />}
    <RejectGuarantorModal open={rejectingGuaranteeId !== null} loading={processingId === rejectingGuaranteeId} mode={guaranteeDecisionAfterReasons} onClose={() => setRejectingGuaranteeId(null)} onConfirm={(reasons, otherReason, observation) => { if (rejectingGuaranteeId !== null) void decideGuarantee(rejectingGuaranteeId, guaranteeDecisionAfterReasons, reasons, otherReason, observation); }} />
    <RejectCreditModal open={rejectingCreditDuringGuaranteeId !== null} loading={processingId === rejectingCreditDuringGuaranteeId} onClose={() => setRejectingCreditDuringGuaranteeId(null)} onConfirm={(reasons, otherReason) => { if (rejectingCreditDuringGuaranteeId !== null) void decideGuarantee(rejectingCreditDuringGuaranteeId, "RECHAZAR_CREDITO", reasons, otherReason); }} />
    {applicantDetail && showTimeline && <TimelinePanel events={timeline} onClose={() => setShowTimeline(false)} />}
    <div className="fixed right-4 top-24 z-[100] flex w-[min(92vw,390px)] flex-col gap-3 sm:right-6">{toasts.map((toast) => <div key={toast.id} className="flex items-start gap-3 rounded-2xl border border-slate-200 bg-white p-4 shadow-xl transition hover:-translate-y-0.5"><span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[#e8f4fb] text-[#1261a0]"><Bell className="h-5 w-5" /></span><button type="button" onClick={() => { markRead(toast.id); setFilter("all"); setSearch(String(toast.requestId)); openSection("requests"); setToasts((current) => current.filter((item) => item.id !== toast.id)); }} className="min-w-0 flex-1 text-left"><span className="block text-sm font-extrabold text-[#173b57]">{toast.title}</span><span className="mt-1 block text-xs leading-5 text-slate-600">{toast.message}</span><span className="mt-2 block text-[10px] font-bold text-[#1f6577]">Ver solicitud #{toast.requestId}</span></button><button type="button" onClick={() => setToasts((current) => current.filter((item) => item.id !== toast.id))} className="rounded-md p-1 text-slate-400 hover:bg-slate-100" aria-label="Cerrar aviso"><X className="h-4 w-4" /></button></div>)}</div>
  </div>;
}

function Overview({ requests, stats, isLoading, onOpenRequests, onViewApplicant, onPreApprove }: { requests: CooperativeCreditRequest[]; stats: Stats; isLoading: boolean; onOpenRequests: () => void; onViewApplicant: (id: number) => void; onPreApprove: (request: CooperativeCreditRequest) => void }) { return <><section className="relative mb-7 overflow-hidden rounded-[1.75rem] bg-[#173b57] p-6 text-white shadow-xl sm:p-8"><div className="absolute -right-16 -top-32 h-80 w-80 rounded-full border-[34px] border-white/[0.07]" /><div className="relative max-w-2xl"><p className="mb-3 flex items-center gap-2 text-xs font-bold uppercase tracking-[0.2em] text-[#d9e5e9]"><Activity className="h-4 w-4" />Operación financiera</p><h2 className="text-2xl font-extrabold sm:text-3xl">Tu bandeja, más clara y accionable.</h2><p className="mt-3 max-w-xl text-sm leading-6 text-slate-200">Evalúa perfiles, revisa expedientes y responde a las personas que buscan una opción de crédito compatible.</p><button onClick={onOpenRequests} className="mt-6 inline-flex items-center gap-2 rounded-xl bg-[#d6ad61] px-4 py-3 text-sm font-extrabold text-[#173b57]">Ver solicitudes pendientes<ChevronRight className="h-4 w-4" /></button></div></section><div className="mb-5 flex flex-wrap items-center justify-between gap-3"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Centro de control</p><p className="mt-1 text-sm text-slate-500">Elige qué quieres revisar primero.</p></div><div className="inline-flex rounded-xl border border-slate-200 bg-white p-1 shadow-sm"><button onClick={onOpenRequests} className="rounded-lg bg-[#edf3f4] px-3 py-2 text-xs font-bold text-[#1f6577]">Solicitudes</button><button className="rounded-lg px-3 py-2 text-xs font-semibold text-slate-500">Resumen</button></div></div><div className="mb-7 grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><Metric label="Solicitudes recibidas" value={stats.total} icon={<FileText />} tone="blue" /><Metric label="Requieren atención" value={stats.pending} icon={<Clock3 />} tone="amber" /><Metric label="Pre aprobadas" value={stats.approved} icon={<CheckCircle2 />} tone="green" /><Metric label="Rechazadas" value={stats.rejected} icon={<TrendingUp />} tone="rose" /></div><div className="grid gap-6 xl:grid-cols-[1.4fr_0.8fr]"><section className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm sm:p-6"><div className="mb-5 flex items-center justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Actividad reciente</p><h3 className="mt-1 text-lg font-extrabold text-[#173b57]">Últimas solicitudes</h3></div><button onClick={onOpenRequests} className="text-sm font-bold text-[#1f6577]">Ver todas</button></div>{isLoading ? <Loading /> : requests.length === 0 ? <Empty /> : <div className="divide-y divide-slate-100">{requests.slice(0, 4).map((request) => <RequestRow key={request.solicitudId} request={request} onViewApplicant={onViewApplicant} onPreApprove={onPreApprove} />)}</div>}</section><section className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm sm:p-6"><p className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Estado de respuestas</p><h3 className="mt-1 text-lg font-extrabold text-[#173b57]">Cartera actual</h3><div className="my-7 flex justify-center"><Donut stats={stats} /></div><div className="space-y-3"><Legend color="bg-[#5f9f73]" label="Pre aprobadas" value={stats.approved} /><Legend color="bg-[#d6ad61]" label="En revisión" value={stats.pending} /><Legend color="bg-[#b96b6b]" label="Rechazadas" value={stats.rejected} /></div></section></div></>; }

function RequestsView({ requests, stats, isLoading, filter, search, setFilter, setSearch, processingId, onViewApplicant, onPreApprove, onReject }: { requests: CooperativeCreditRequest[]; stats: Stats; isLoading: boolean; filter: Filter; search: string; setFilter: (filter: Filter) => void; setSearch: (search: string) => void; processingId: number | null; onViewApplicant: (id: number) => void; onPreApprove: (request: CooperativeCreditRequest) => void; onReject: (id: number) => void }) { const filters: Filter[] = ["all", CreditEstado.ENVIADA, CreditEstado.PRE_APROBADA, CreditEstado.RECHAZADA]; return <section><div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Expedientes</p><h2 className="mt-1 text-2xl font-extrabold text-[#0b214c]">Solicitudes de crédito</h2><p className="mt-1 text-sm text-slate-500">Revisa cada caso y toma una decisión informada.</p></div><div className="relative w-full lg:max-w-sm"><Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" /><input value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Buscar solicitante o número" className="w-full rounded-xl border border-slate-200 bg-white py-3 pl-10 pr-4 text-sm outline-none focus:border-sky-400 focus:ring-4 focus:ring-sky-100" /></div></div><div className="mb-5 flex flex-wrap items-center gap-2"><SlidersHorizontal className="mr-1 h-4 w-4 text-slate-400" />{filters.map((value) => <button key={value} onClick={() => setFilter(value)} className={`rounded-lg px-3 py-2 text-xs font-bold ${filter === value ? "bg-[#123f77] text-white" : "border border-slate-200 bg-white text-slate-600"}`}>{filterLabel(value, stats)}</button>)}</div>{isLoading ? <Loading /> : requests.length === 0 ? <Empty /> : <div className="space-y-4">{requests.map((request) => <RequestCard key={request.solicitudId} request={request} processingId={processingId} onViewApplicant={onViewApplicant} onPreApprove={onPreApprove} onReject={onReject} />)}</div>}</section>; }

function RequestCard({ request, processingId, onViewApplicant, onPreApprove, onReject }: { request: CooperativeCreditRequest; processingId: number | null; onViewApplicant: (id: number) => void; onPreApprove: (request: CooperativeCreditRequest) => void; onReject: (id: number) => void }) { const pending = request.estado === CreditEstado.ENVIADA; return <article className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm sm:p-6"><div className="flex flex-col gap-5 xl:flex-row xl:items-center"><div className="flex min-w-0 flex-1 items-start gap-4"><div className="grid h-12 w-12 shrink-0 place-items-center rounded-xl bg-[#e8f4fb] text-sm font-extrabold text-[#1261a0]">#{request.solicitudId}</div><div className="min-w-0 flex-1"><div className="flex flex-wrap items-center gap-2"><h3 className="font-extrabold text-slate-800">{request.nombreSolicitante || "Solicitante pendiente"}</h3><StatusBadge status={request.estado} /></div><p className="mt-1 text-sm text-slate-500">{request.tipo} · {new Date(request.fechaSolicitud).toLocaleDateString("es-EC")}</p><div className="mt-4 flex flex-wrap gap-6"><div><p className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Monto solicitado</p><p className="mt-1 text-lg font-extrabold text-[#0b214c]">${request.montoSolicitado.toLocaleString("es-EC")}</p></div><div><p className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Identificación</p><p className="mt-1 text-sm font-semibold text-slate-700">{request.cedulaSolicitante || "Pendiente"}</p></div></div></div></div><div className="flex flex-wrap items-center gap-2 xl:justify-end"><button onClick={() => onViewApplicant(request.solicitudId)} className="rounded-xl border border-slate-200 px-3 py-2.5 text-xs font-bold text-slate-700">Ver expediente</button><button onClick={() => onPreApprove(request)} disabled={!pending || processingId === request.solicitudId} className={`rounded-xl px-3 py-2.5 text-xs font-bold ${pending ? "bg-[#75d858] text-[#0b2b2f]" : "cursor-not-allowed bg-slate-100 text-slate-400"}`}>Pre aprobar</button><button onClick={() => onReject(request.solicitudId)} disabled={!pending || processingId === request.solicitudId} className={`rounded-xl px-3 py-2.5 text-xs font-bold ${pending ? "border border-red-200 text-red-600" : "cursor-not-allowed bg-slate-100 text-slate-400"}`}>Rechazar</button></div></div></article>; }

function RequestRow({ request, onViewApplicant, onPreApprove }: { request: CooperativeCreditRequest; onViewApplicant: (id: number) => void; onPreApprove: (request: CooperativeCreditRequest) => void }) { return <div className="flex flex-wrap items-center gap-3 py-4"><div className="grid h-9 w-9 place-items-center rounded-lg bg-slate-100 text-xs font-bold text-slate-600">#{request.solicitudId}</div><div className="min-w-[140px] flex-1"><p className="text-sm font-bold text-slate-800">{request.nombreSolicitante || "Solicitante pendiente"}</p><p className="text-xs text-slate-500">{request.tipo}</p></div><p className="text-sm font-extrabold text-[#0b214c]">${request.montoSolicitado.toLocaleString("es-EC")}</p><StatusBadge status={request.estado} /><button onClick={() => request.estado === CreditEstado.ENVIADA ? onPreApprove(request) : onViewApplicant(request.solicitudId)} className="grid h-8 w-8 place-items-center rounded-lg text-slate-400 hover:bg-slate-100" aria-label="Abrir solicitud"><ChevronRight className="h-4 w-4" /></button></div>; }

function Analytics({ stats }: { stats: Stats }) { const total = Math.max(stats.total, 1); return <section><p className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Rendimiento</p><h2 className="mt-1 text-2xl font-extrabold text-[#0b214c]">Lectura de tu operación</h2><div className="mt-6 grid gap-6 lg:grid-cols-2"><section className="rounded-2xl border border-slate-200/80 bg-white p-6 shadow-sm"><h3 className="font-extrabold">Distribución de solicitudes</h3><div className="mt-6 space-y-5"><Progress label="Pendientes de revisión" value={stats.pending} total={total} color="bg-[#f5b84b]" /><Progress label="Pre aprobadas" value={stats.approved} total={total} color="bg-[#75d858]" /><Progress label="Rechazadas" value={stats.rejected} total={total} color="bg-[#f17878]" /></div></section><section className="rounded-2xl bg-[#0b2b61] p-6 text-white shadow-sm"><p className="text-xs font-bold uppercase tracking-[0.16em] text-blue-200">Indicador principal</p><p className="mt-8 text-5xl font-extrabold">{Math.round((stats.approved / total) * 100)}%</p><p className="mt-2 text-sm text-blue-100">de las solicitudes actuales cuentan con una pre aprobación.</p><div className="mt-8 flex items-center gap-2 text-sm font-semibold text-[#9be985]"><TrendingUp className="h-4 w-4" />Datos calculados desde tu bandeja real</div></section></div></section>; }
function SettingsView({ name }: { name: string }) { return <section><p className="text-xs font-bold uppercase tracking-[0.16em] text-slate-400">Cuenta</p><h2 className="mt-1 text-2xl font-extrabold text-[#0b214c]">Configuración</h2><div className="mt-6 max-w-2xl rounded-2xl border border-slate-200/80 bg-white p-6 shadow-sm"><div className="flex items-center gap-4 border-b border-slate-100 pb-5"><div className="grid h-12 w-12 place-items-center rounded-xl bg-[#e8f4fb] text-[#1261a0]"><User className="h-5 w-5" /></div><div><h3 className="font-extrabold">{name}</h3><p className="text-sm text-slate-500">Perfil de cooperativa</p></div></div><div className="mt-5 grid gap-3 sm:grid-cols-2"><Info label="Acceso" value="Cuenta cooperativa" /><Info label="Seguridad" value="Sesión protegida" /></div></div></section>; }
function Metric({ label, value, icon, tone }: { label: string; value: number; icon: ReactNode; tone: string }) { const colors: Record<string, string> = { blue: "bg-[#edf3f4] text-[#1f6577]", amber: "bg-[#fbf4e7] text-[#a27832]", green: "bg-[#edf5ef] text-[#5f9f73]", rose: "bg-[#faeeee] text-[#b96b6b]" }; return <div className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm"><div className="flex items-start justify-between"><div><p className="text-xs font-bold uppercase tracking-wide text-slate-400">{label}</p><p className="mt-3 text-3xl font-extrabold text-[#173b57]">{value}</p></div><div className={`grid h-10 w-10 place-items-center rounded-xl ${colors[tone]}`}>{icon}</div></div></div>; }
function filterLabel(filter: Filter, stats: Stats) { if (filter === "all") return `Todas (${stats.total})`; if (filter === CreditEstado.ENVIADA) return `Pendientes (${stats.pending})`; if (filter === CreditEstado.PRE_APROBADA) return `Pre aprobadas (${stats.approved})`; return `Rechazadas (${stats.rejected})`; }
function StatusBadge({ status }: { status: CreditEstado }) { const color = status === CreditEstado.PRE_APROBADA ? "bg-emerald-50 text-emerald-700" : status === CreditEstado.RECHAZADA ? "bg-rose-50 text-rose-700" : status === CreditEstado.SOLICITANDO_GARANTE ? "bg-violet-50 text-violet-700" : "bg-amber-50 text-amber-700"; return <span className={`rounded-full px-2.5 py-1 text-[10px] font-extrabold uppercase tracking-wide ${color}`}>{status.replace(/_/g, " ")}</span>; }
function Donut({ stats }: { stats: Stats }) { const total = Math.max(stats.approved + stats.pending + stats.rejected, 1); const approved = stats.approved / total * 360; const pending = stats.pending / total * 360; return <div className="grid h-40 w-40 place-items-center rounded-full" style={{ background: `conic-gradient(#5f9f73 0deg ${approved}deg, #d6ad61 ${approved}deg ${approved + pending}deg, #b96b6b ${approved + pending}deg 360deg)` }}><div className="grid h-28 w-28 place-items-center rounded-full bg-white"><span className="text-2xl font-extrabold text-[#173b57]">{stats.total}</span></div></div>; }
function Legend({ color, label, value }: { color: string; label: string; value: number }) { return <div className="flex items-center justify-between text-sm"><span className="flex items-center gap-2 text-slate-600"><span className={`h-2.5 w-2.5 rounded-full ${color}`} />{label}</span><b>{value}</b></div>; }
function Progress({ label, value, total, color }: { label: string; value: number; total: number; color: string }) { const percent = Math.round(value / total * 100); return <div><div className="mb-2 flex justify-between text-sm"><span className="font-semibold text-slate-600">{label}</span><b>{percent}%</b></div><div className="h-2 overflow-hidden rounded-full bg-slate-100"><div className={`h-full rounded-full ${color}`} style={{ width: `${percent}%` }} /></div></div>; }
function Info({ label, value }: { label: string; value: string }) { return <div className="rounded-xl bg-slate-50 p-4"><p className="text-xs text-slate-400">{label}</p><p className="mt-1 text-sm font-bold text-slate-700">{value}</p></div>; }
function Loading() { return <div className="py-10 text-center text-sm font-medium text-slate-500"><div className="mx-auto h-8 w-8 animate-spin rounded-full border-4 border-sky-100 border-t-sky-600" /><p className="mt-3">Cargando solicitudes...</p></div>; }
function Empty() { return <div className="py-12 text-center"><FileCheck2 className="mx-auto h-10 w-10 text-slate-300" /><p className="mt-3 font-bold text-slate-600">No hay solicitudes para mostrar</p><p className="mt-1 text-sm text-slate-400">Cuando llegue una nueva solicitud aparecerá aquí.</p></div>; }
function TimelinePanel({ events, onClose }: { events: CreditTimelineEvent[]; onClose: () => void }) {
  const chronologicalEvents = [...events].reverse();
  return <div className="fixed inset-0 z-[90] flex justify-end bg-slate-950/35 backdrop-blur-[2px]" onMouseDown={(event) => { if (event.target === event.currentTarget) onClose(); }}>
    <aside className="flex h-full w-full max-w-[460px] flex-col border-l border-slate-200 bg-[#f8fafc] shadow-2xl" aria-label="Historial de la solicitud">
      <header className="flex items-start justify-between border-b border-slate-200 bg-white px-5 py-5 sm:px-7">
        <div><p className="text-[11px] font-extrabold uppercase tracking-[0.16em] text-[#1f6577]">Seguimiento</p><h2 className="mt-1 text-xl font-extrabold text-[#173b57]">Historial del proceso</h2><p className="mt-1 text-sm text-slate-500">Cada paso registrado en esta solicitud.</p></div>
        <button type="button" onClick={onClose} className="grid h-10 w-10 shrink-0 place-items-center rounded-xl border border-slate-200 text-slate-500 transition hover:bg-slate-50 hover:text-slate-800" aria-label="Cerrar historial"><X className="h-5 w-5" /></button>
      </header>
      <div className="flex-1 overflow-y-auto px-5 py-6 sm:px-7">
        {!chronologicalEvents.length ? <div className="rounded-2xl border border-dashed border-slate-300 bg-white p-6 text-center"><Clock3 className="mx-auto h-8 w-8 text-slate-300" /><p className="mt-3 font-bold text-slate-700">Aún no hay movimientos</p><p className="mt-1 text-sm text-slate-500">Cuando la solicitud avance, verás aquí cada actualización.</p></div> : <ol className="relative space-y-0 before:absolute before:bottom-5 before:left-[17px] before:top-5 before:w-px before:bg-slate-200">
          {chronologicalEvents.map((event, index) => {
            const title = timelineTitle(event.tipo);
            const accent = timelineAccent(event.tipo);
            const timestamp = new Date(event.fecha);
            const dateLabel = Number.isNaN(timestamp.getTime()) ? event.fecha : timestamp.toLocaleString("es-EC", { day: "numeric", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" });
            return <li key={`${event.fecha}-${index}`} className="relative flex gap-4 pb-7 last:pb-0">
              <span className={`relative z-10 mt-0.5 grid h-9 w-9 shrink-0 place-items-center rounded-full border-4 border-[#f8fafc] text-[11px] font-black ${accent}`}>{index === 0 ? <CheckCircle2 className="h-4 w-4" /> : index + 1}</span>
              <article className={`min-w-0 flex-1 rounded-2xl border bg-white p-4 shadow-sm ${index === 0 ? "border-[#b9d9d7] ring-1 ring-[#d9eceb]" : "border-slate-200"}`}>
                <div className="flex flex-wrap items-center justify-between gap-2"><h3 className="text-sm font-extrabold text-[#173b57]">{title}</h3>{index === 0 && <span className="rounded-full bg-[#e8f4f1] px-2 py-1 text-[10px] font-extrabold uppercase tracking-wide text-[#1f6b5d]">Más reciente</span>}</div>
                <p className="mt-2 text-sm leading-6 text-slate-600">{event.detalle}</p>
                <p className="mt-3 flex items-center gap-1.5 text-xs font-semibold text-slate-400"><Clock3 className="h-3.5 w-3.5" />{dateLabel}</p>
              </article>
            </li>;
          })}
        </ol>}
      </div>
    </aside>
  </div>;
}
function timelineTitle(type: string) {
  const titles: Record<string, string> = {
    SOLICITUD_CREADA: "Solicitud recibida",
    SOLICITUD_ENVIADA: "Solicitud enviada a la cooperativa",
    GARANTE_SOLICITADO: "Se solicitó un garante",
    GARANTE_ENVIADO: "Información del garante recibida",
    NUEVO_GARANTE_SOLICITADO: "Se solicitaron ajustes al garante",
    GARANTE_ACEPTADO: "Garante aprobado",
    CREDITO_RECHAZADO_DURANTE_REVISION_GARANTE: "Crédito rechazado",
  };
  return titles[type] ?? type.toLowerCase().replace(/_/g, " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
}
function timelineAccent(type: string) {
  if (type.includes("RECHAZ")) return "bg-rose-100 text-rose-700";
  if (type.includes("ACEPT")) return "bg-emerald-100 text-emerald-700";
  if (type.includes("GARANTE")) return "bg-amber-100 text-amber-700";
  return "bg-sky-100 text-sky-700";
}
function ApplicantModal({ detail, history, onClose, onDecision, processing }: { detail: OnboardingCooperativeDetail; history: CreditGuarantorHistoryItem[]; onClose: () => void; onDecision: (decision: GuaranteeDecision) => void; processing: boolean }) {
  const money = (value?: number) => value == null ? "—" : `$${value.toLocaleString("es-EC", { minimumFractionDigits: 2 })}`;
  const applicant = detail.personas.find((person) => person.rol !== "GARANTE");
  const latest = history[0];
  const formatDate = (value?: string) => {
    if (!value) return "Fecha no disponible";
    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? value : date.toLocaleString("es-EC", { dateStyle: "medium", timeStyle: "short" });
  };
  return <div className="fixed inset-0 z-[80] flex items-center justify-center bg-slate-950/60 p-4"><div className="max-h-[90vh] w-full max-w-4xl overflow-y-auto rounded-2xl bg-white p-6 shadow-2xl">
    <div className="mb-6 flex justify-between"><div><p className="text-xs font-bold uppercase tracking-wider text-slate-400">Expediente financiero</p><h2 className="mt-1 text-2xl font-extrabold text-[#0b214c]">Información de la solicitud</h2><p className="text-sm text-slate-500">Solicitud #{detail.solicitudId}</p></div><button onClick={onClose} className="rounded-xl px-3 py-2 text-sm font-bold text-slate-500 hover:bg-slate-100">Cerrar</button></div>
    {applicant && <div className="mb-6"><h3 className="mb-3 text-lg font-extrabold">Información del solicitante</h3><div className="grid gap-4 md:grid-cols-2"><DetailSection title="Datos personales"><Detail label="Nombre" value={`${applicant.nombres} ${applicant.apellidos}`} /><Detail label="Cédula" value={applicant.cedula} /><Detail label="Fecha de nacimiento" value={applicant.fechaNacimiento} /><Detail label="Estado civil" value={applicant.estadoCivil} /><Detail label="Teléfono" value={applicant.telefono} /></DetailSection><DetailSection title="Trabajo"><Detail label="Ocupación" value={applicant.ocupacion} /><Detail label="Empresa" value={applicant.empresaTrabajo} /><Detail label="Negocio" value={applicant.actividadEconomica?.nombreNegocio} /></DetailSection><DetailSection title="Dirección"><Detail label="Provincia" value={applicant.direccion?.provincia} /><Detail label="Cantón" value={applicant.direccion?.canton} /><Detail label="Barrio" value={applicant.direccion?.barrio} /><Detail label="Dirección" value={[applicant.direccion?.callePrincipal, applicant.direccion?.numero].filter(Boolean).join(" ")} /><Detail label="Calle secundaria" value={applicant.direccion?.calleSecundaria} /><Detail label="Vivienda" value={applicant.direccion?.tipoVivienda} /></DetailSection><DetailSection title="Situación económica"><Detail label="Ingreso mensual" value={money(applicant.ingresoEgreso?.ingresoMensual)} /><Detail label="Egreso mensual" value={money(applicant.ingresoEgreso?.egresoMensual)} /></DetailSection></div></div>}
    <section className="rounded-2xl border border-slate-200 bg-slate-50 p-5"><div className="flex items-start justify-between gap-4"><div><p className="text-xs font-bold uppercase tracking-wider text-slate-500">Revisión por crédito</p><h3 className="mt-1 text-lg font-extrabold text-[#173b57]">Historial del garante</h3></div><span className="rounded-full bg-white px-3 py-1 text-xs font-bold text-slate-600">{history.length} {history.length === 1 ? "envío" : "envíos"}</span></div>
      {!latest ? <div className="mt-4 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm leading-6 text-amber-900">Este crédito no tiene un envío de garante vinculado. Los datos antiguos se conservan como legado, pero no se pueden usar para aprobar una evaluación. Solicita al cliente que envíe los datos del garante para este crédito.</div> : <div className="mt-4 space-y-4">{history.map((item) => <article key={item.id} className="rounded-xl border border-slate-200 bg-white p-4"><div className="flex flex-wrap items-center justify-between gap-2"><div><p className="font-bold text-slate-800">Intento {item.intento} · {item.fotografia.nombres} {item.fotografia.apellidos}</p><p className="text-xs text-slate-500">Cédula {item.fotografia.cedula} · Enviado {formatDate(item.enviadoEn)}</p></div><span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-bold text-slate-600">{item.estado.replaceAll("_", " ")}</span></div><div className="mt-3 grid gap-2 text-sm text-slate-600 sm:grid-cols-2"><p>Teléfono: {item.fotografia.telefono ?? "—"}</p><p>Ocupación: {item.fotografia.ocupacion ?? "—"}</p></div>{item.evaluaciones.map((evaluation) => <div key={evaluation.id} className="mt-3 rounded-lg bg-slate-50 p-3"><p className="text-sm font-bold text-[#173b57]">{evaluation.decision.replaceAll("_", " ")} · {formatDate(evaluation.fecha)}</p><p className="text-xs text-slate-500">Responsable: {evaluation.actorRole} · ID {evaluation.actorId}</p>{(evaluation.motivosRechazo ?? []).length > 0 && <p className="mt-1 text-sm text-slate-600">Motivos: {evaluation.motivosRechazo.join(", ")}{evaluation.motivoRechazoOtro ? ` · ${evaluation.motivoRechazoOtro}` : ""}</p>}{evaluation.observacion && <p className="mt-1 text-sm text-slate-600">Observación: {evaluation.observacion}</p>}</div>)}</article>)}</div>}
    </section>
    {latest && latest.estado !== "ACEPTADO" && <div className="mt-5 flex flex-wrap gap-3 border-t border-slate-200 pt-5"><button onClick={() => onDecision("SOLICITAR_CORRECCION")} disabled={processing} className="rounded-xl bg-amber-600 px-4 py-2.5 text-sm font-bold text-white disabled:opacity-50">Solicitar corrección o nuevo garante</button><button onClick={() => onDecision("RECHAZAR_GARANTE")} disabled={processing} className="rounded-xl border border-rose-200 px-4 py-2.5 text-sm font-bold text-rose-700 disabled:opacity-50">Rechazar garante</button><button onClick={() => onDecision("RECHAZAR_SOLICITUD")} disabled={processing} className="rounded-xl border border-rose-200 px-4 py-2.5 text-sm font-bold text-rose-700 disabled:opacity-50">Rechazar crédito</button><button onClick={() => onDecision("ACEPTAR")} disabled={processing} className="rounded-xl bg-emerald-600 px-4 py-2.5 text-sm font-bold text-white disabled:opacity-50">Aceptar garante</button></div>}
    {!latest && <div className="mt-5 flex justify-end border-t border-slate-200 pt-5"><button onClick={() => onDecision("SOLICITAR_CORRECCION")} disabled={processing} className="rounded-xl bg-amber-600 px-4 py-2.5 text-sm font-bold text-white disabled:opacity-50">Solicitar envío de garante</button></div>}
  </div></div>;
}
function DetailSection({ title, children }: { title: string; children: ReactNode }) { return <section className="rounded-xl border border-slate-200 p-4"><h3 className="mb-3 text-sm font-extrabold">{title}</h3>{children}</section>; }
function Detail({ label, value }: { label: string; value?: string }) { return <p className="mb-2 text-sm"><span className="text-slate-400">{label}: </span><span className="font-semibold text-slate-700">{value || "—"}</span></p>; }
