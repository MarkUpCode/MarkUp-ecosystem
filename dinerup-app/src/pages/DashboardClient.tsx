import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Plus,
  FileText,
  AlertCircle,
  CheckCircle,
  TrendingUp,
  Wallet,
  ArrowUpRight,
  Sparkles,
  Menu,
  X,
  LayoutDashboard,
  ClipboardList,
  Landmark,
  UserRound,
  ChevronLeft,
  ShieldCheck,
} from "lucide-react";
import { useAuth } from "../context/useAuth";

import { getCooperatives } from "../api/cooperatives.api";
import {
  getMyCreditRequests,
  createCreditRequest,
} from "../api/creditRequests.api";
import { getErrorMessage } from "../api/errors";
import { getFormularioClienteStatus } from "../api/onboarding.api";

import type { Cooperative } from "../types/cooperative";
import type { CreditRequest } from "../types/credit";

import CooperativeCard from "../components/cooperative/CooperativeCard";
import CreditCard from "../components/credit/CreditCard";
import Navbar from "../components/layout/Navbar";
import OnboardingPopup from "../components/onboarding/OnboardingPopup";
import NewCreditModal from "../components/credit/NewCreditModal";
import NewInvestmentModal from "../components/investment/NewInvestmentModal";
import CooperativeLogoMarquee from "../components/cooperative/CooperativeLogoMarquee";

export default function DashboardClient() {
  const { user } = useAuth();
  const navigate = useNavigate();

  const [cooperatives, setCooperatives] = useState<Cooperative[]>([]);
  const [creditRequests, setCreditRequests] = useState<CreditRequest[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [pageError, setPageError] = useState("");
  const [activeSection, setActiveSection] = useState<
    "overview" | "requests" | "cooperatives"
  >("overview");
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const [needsOnboarding, setNeedsOnboarding] = useState(true);
  const [checkingOnboarding, setCheckingOnboarding] = useState(false);
  const [showOnboardingCompletedPopup, setShowOnboardingCompletedPopup] =
    useState(false);

  const [showCreditModal, setShowCreditModal] = useState(false);
  const [showInvestmentModal, setShowInvestmentModal] = useState(false);
  const [creditSuccess, setCreditSuccess] = useState(false);
  const [investmentSuccess, setInvestmentSuccess] = useState(false);

  useEffect(() => {
    if (user) {
      void loadData();
      void syncOnboardingStatus();
    }
  }, [user]);

  const loadData = async () => {
    setIsLoading(true);
    setPageError("");
    try {
      const [coopsData, requestsData] = await Promise.all([
        getCooperatives(),
        getMyCreditRequests(),
      ]);

      setCooperatives(coopsData ?? []);
      setCreditRequests(requestsData ?? []);
    } catch (error) {
      setPageError(getErrorMessage(error, "No se pudieron cargar tus datos."));
    } finally {
      setIsLoading(false);
    }
  };

  const syncOnboardingStatus = async () => {
    try {
      setCheckingOnboarding(true);
      setPageError("");
      const status = await getFormularioClienteStatus();
      setNeedsOnboarding(!status.formularioCompleto);
    } catch (error) {
      setPageError(
        getErrorMessage(error, "No se pudo verificar el estado de onboarding."),
      );
      setNeedsOnboarding(true);
    } finally {
      setCheckingOnboarding(false);
    }
  };

  const handleGoToOnboarding = async () => {
    try {
      setCheckingOnboarding(true);
      setPageError("");

      const status = await getFormularioClienteStatus();

      if (status.formularioCompleto) {
        setNeedsOnboarding(false);
        setShowOnboardingCompletedPopup(true);
        return;
      }

      navigate("/onboarding");
    } catch (error) {
      setPageError(
        getErrorMessage(error, "No se pudo verificar tu formulario actual."),
      );
      navigate("/onboarding");
    } finally {
      setCheckingOnboarding(false);
    }
  };

  const handleRequestCredit = () => {
    if (needsOnboarding) return;
    setShowCreditModal(true);
  };

  const handleRequestInvestment = () => {
    if (needsOnboarding) return;
    setShowInvestmentModal(true);
  };

  const selectSection = (
    section: "overview" | "requests" | "cooperatives",
  ) => {
    setActiveSection(section);
    setSidebarOpen(false);
  };

  const handleCreditSubmit = async (data: { amount: number; creditType: string; plazoMeses: number; cedula: string; provincia: string; ciudad: string }) => {
    try {
      await createCreditRequest({
        monto: data.amount,
        type: "CREDITO",
        creditType: data.creditType,
        plazoMeses: data.plazoMeses,
        city: data.ciudad,
        province: data.provincia,
      });
      setCreditSuccess(true);
      setTimeout(() => setCreditSuccess(false), 5000);
      void loadData();
    } catch (error) {
      setPageError(
        getErrorMessage(error, "No se pudo enviar la solicitud de crédito."),
      );
    }
  };

  const handleInvestmentSubmit = async (data: { amount: number }) => {
    try {
      await createCreditRequest({
        monto: data.amount,
        type: "INVERSION",
        creditType: null,
      });
      setInvestmentSuccess(true);
      setTimeout(() => setInvestmentSuccess(false), 5000);
      void loadData();
    } catch (error) {
      setPageError(
        getErrorMessage(error, "No se pudo registrar la inversión."),
      );
    }
  };

  return (
    <div className="portal-shell flex h-screen flex-col overflow-hidden bg-[#f5f8fc]">
      <Navbar />

      <div className="flex min-h-0 flex-1 overflow-hidden">
        {sidebarOpen && (
          <button
            aria-label="Cerrar menú"
            className="fixed inset-0 z-30 bg-slate-950/40 lg:hidden"
            onClick={() => setSidebarOpen(false)}
          />
        )}
        <aside
          className={`fixed inset-y-0 left-0 z-40 flex w-72 transform flex-col bg-[#0b1d42] px-5 py-6 text-white shadow-2xl transition-transform duration-300 lg:sticky lg:top-0 lg:z-20 lg:h-full lg:min-h-0 lg:translate-x-0 lg:shadow-none ${
            sidebarOpen ? "translate-x-0" : "-translate-x-full"
          }`}
        >
          <div className="mb-8 flex items-center justify-between lg:hidden">
            <span className="text-sm font-bold uppercase tracking-[0.16em] text-cyan-100">
              Menú principal
            </span>
            <button
              aria-label="Cerrar menú"
              onClick={() => setSidebarOpen(false)}
              className="rounded-xl p-2 text-blue-100 hover:bg-white/10"
            >
              <X className="h-5 w-5" />
            </button>
          </div>
          <div className="mb-8 hidden items-center gap-3 lg:flex">
            <div className="grid h-10 w-10 place-items-center rounded-xl bg-white/10">
              <ShieldCheck className="h-5 w-5 text-cyan-200" />
            </div>
            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.14em] text-cyan-200">
                Portal cliente
              </p>
              <p className="text-sm font-bold text-white">Mi espacio financiero</p>
            </div>
          </div>
          <p className="mb-3 px-3 text-[10px] font-bold uppercase tracking-[0.2em] text-blue-200/70">
            Navegación
          </p>
          <nav className="space-y-2">
            {[
              { id: "overview" as const, label: "Resumen", icon: LayoutDashboard },
              { id: "requests" as const, label: "Mis solicitudes", icon: ClipboardList },
              { id: "cooperatives" as const, label: "Cooperativas", icon: Landmark },
            ].map((item) => {
              const Icon = item.icon;
              const active = activeSection === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => selectSection(item.id)}
                  className={`flex w-full items-center gap-3 rounded-xl px-3 py-3 text-left text-sm font-semibold transition ${
                    active
                      ? "bg-white text-[#123f77] shadow-lg"
                      : "text-blue-100 hover:bg-white/10 hover:text-white"
                  }`}
                >
                  <Icon className="h-5 w-5" />
                  {item.label}
                  {item.id === "requests" && creditRequests.length > 0 && (
                    <span
                      className={`ml-auto rounded-full px-2 py-0.5 text-xs ${
                        active ? "bg-cyan-100 text-cyan-800" : "bg-white/15"
                      }`}
                    >
                      {creditRequests.length}
                    </span>
                  )}
                </button>
              );
            })}
            <button
              onClick={() => {
                setSidebarOpen(false);
                void handleGoToOnboarding();
              }}
              className="flex w-full items-center gap-3 rounded-xl px-3 py-3 text-left text-sm font-semibold text-blue-100 transition hover:bg-white/10 hover:text-white"
            >
              <UserRound className="h-5 w-5" />
              Mi perfil
            </button>
          </nav>
          <div className="mt-auto hidden rounded-2xl border border-white/10 bg-white/5 p-4 lg:block">
            <p className="text-xs font-semibold text-cyan-100">Tu seguridad es prioridad</p>
            <p className="mt-2 text-xs leading-5 text-blue-100/70">
              Información protegida para que gestiones tus productos con tranquilidad.
            </p>
          </div>
        </aside>

        <main className="min-h-0 min-w-0 flex-1 overflow-y-auto px-4 py-6 sm:px-6 lg:px-8 lg:py-8">
          <div className="mx-auto max-w-7xl">
            <div className="mb-4 flex items-center gap-3 lg:hidden">
              <button
                aria-label="Abrir menú"
                onClick={() => setSidebarOpen(true)}
                className="grid h-11 w-11 place-items-center rounded-xl bg-[#123f77] text-white shadow-lg"
              >
                <Menu className="h-5 w-5" />
              </button>
              <div>
                <p className="text-xs font-bold uppercase tracking-[0.15em] text-cyan-700">
                  Portal cliente
                </p>
                <p className="text-sm font-semibold text-slate-700">
                  {activeSection === "overview"
                    ? "Resumen"
                    : activeSection === "requests"
                      ? "Mis solicitudes"
                      : "Cooperativas"}
                </p>
              </div>
            </div>
        {activeSection === "overview" && <CooperativeLogoMarquee />}
        {activeSection === "overview" && <div className="relative mb-8 overflow-hidden rounded-[2rem] bg-gradient-to-br from-[#0b1d42] via-[#123f77] to-[#0ea5a4] p-6 text-white shadow-2xl shadow-cyan-950/20 sm:p-10">
          <div className="absolute -right-20 -top-32 h-80 w-80 rounded-full border-[34px] border-white/10" />
          <div className="absolute -bottom-28 right-28 h-56 w-56 rounded-full bg-cyan-300/10 blur-2xl" />
          <div className="relative z-10 flex flex-col justify-between gap-6 sm:flex-row sm:items-end">
            <div>
              <p className="mb-2 text-sm font-semibold uppercase tracking-[0.18em] text-cyan-100">Tu espacio financiero</p>
              <h1 className="text-3xl font-extrabold tracking-tight sm:text-4xl">Hola, {user?.name?.split(" ")[0] ?? "bienvenido"}</h1>
              <p className="mt-2 max-w-xl text-sm text-blue-100 sm:text-base">
                {needsOnboarding ? "Completa tu perfil para desbloquear todas las opciones." : "Administra tus solicitudes y encuentra oportunidades a tu medida."}
              </p>
            </div>
            <div className="rounded-2xl border border-white/20 bg-white/10 px-4 py-3 text-sm backdrop-blur">
              <span className="block text-blue-100">Sesión protegida</span>
              <span className="font-semibold">Datos cifrados y seguros</span>
            </div>
          </div>
        </div>}

        {activeSection === "overview" && needsOnboarding && (
          <div className="mb-8 overflow-hidden rounded-2xl border border-amber-200 bg-amber-50 p-6 shadow-sm sm:p-8">
            <div className="absolute top-0 right-0 w-64 h-64 bg-white opacity-10 rounded-full -mr-32 -mt-32" />
            <div className="relative z-10 flex flex-col sm:flex-row gap-4">
              <div className="h-fit rounded-xl bg-amber-100 p-3 text-amber-700">
                <AlertCircle className="w-6 h-6 sm:w-8 sm:h-8" />
              </div>
              <div className="flex-1">
                <h2 className="mb-2 text-xl font-bold text-slate-900 sm:text-2xl">
                  Completa tu formulario una sola vez para enviar solicitudes a
                  todas las cooperativas
                </h2>
                <p className="mb-4 text-sm text-slate-600 sm:mb-6 sm:text-base">
                  Para solicitar creditos o realizar inversiones necesitamos
                  conocer tus datos. Es un proceso rapido que solo haras una
                  vez.
                </p>
                <button
                  disabled={checkingOnboarding}
                  onClick={handleGoToOnboarding}
                  className="inline-flex items-center gap-2 rounded-xl bg-amber-500 px-6 py-2.5 font-semibold text-white shadow-lg transition-all hover:bg-amber-600 disabled:opacity-60 sm:px-8 sm:py-3"
                >
                  <CheckCircle className="w-5 h-5" />
                  {checkingOnboarding
                    ? "Verificando..."
                    : "Completar Formulario Ahora"}
                </button>
              </div>
            </div>
          </div>
        )}

        {pageError && (
          <div className="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-700">
            {pageError}
          </div>
        )}

        {activeSection === "overview" && <div className="mb-8 grid grid-cols-2 gap-3 lg:grid-cols-4">
          {[
            ["Solicitudes", creditRequests.length, "Tus procesos activos"],
            ["Cooperativas", cooperatives.length, "Entidades disponibles"],
            ["En revisión", creditRequests.filter((request) => request.estado === "ENVIADA").length, "Esperando respuesta"],
            ["Perfil", needsOnboarding ? "Pendiente" : "Completo", needsOnboarding ? "Te falta un paso" : "Listo para operar"],
          ].map(([label, value, caption]) => (
            <div key={label} className="portal-panel p-4 sm:p-5">
              <p className="text-xs font-semibold uppercase tracking-[0.12em] text-slate-400">{label}</p>
              <p className="mt-2 text-2xl font-extrabold tracking-tight text-slate-900 sm:text-3xl">{value}</p>
              <p className="mt-1 text-xs text-slate-500">{caption}</p>
            </div>
          ))}
        </div>}

        {activeSection === "overview" && (
          <div className="portal-panel mb-8 p-5 sm:p-6">
            <div className="mb-3 flex items-center justify-between gap-4">
              <div>
                <p className="text-xs font-bold uppercase tracking-[0.14em] text-cyan-700">
                  Progreso financiero
                </p>
                <h2 className="mt-1 text-lg font-bold text-slate-900">
                  {needsOnboarding ? "Completa tu perfil para comenzar" : "Tu perfil está listo para operar"}
                </h2>
              </div>
              <span className="rounded-full bg-cyan-50 px-3 py-1 text-sm font-bold text-cyan-700">
                {needsOnboarding ? "70%" : "100%"}
              </span>
            </div>
            <div className="h-3 overflow-hidden rounded-full bg-slate-100">
              <div
                className={`h-full rounded-full bg-gradient-to-r from-[#123f77] to-[#0ea5a4] transition-all ${
                  needsOnboarding ? "w-[70%]" : "w-full"
                }`}
              />
            </div>
            <p className="mt-3 text-sm text-slate-500">
              {needsOnboarding
                ? "Completa la información pendiente para enviar solicitudes a nuestras cooperativas aliadas."
                : "Puedes solicitar crédito y consultar el avance de tus procesos desde este portal."}
            </p>
          </div>
        )}

        {activeSection === "overview" && (
        <div className="mb-8 grid grid-cols-1 gap-4 sm:gap-6 lg:grid-cols-2">
          <div
            className={`rounded-2xl border bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:shadow-lg sm:p-6 ${
              needsOnboarding
                ? "border-slate-200 opacity-75"
                : "border-slate-200 hover:border-cyan-300"
            }`}
          >
            <div className="mb-4 w-fit rounded-xl bg-cyan-50 p-3">
              <TrendingUp className="h-6 w-6 text-cyan-700 sm:h-8 sm:w-8" />
            </div>
            <div className="mb-5 flex items-start justify-between">
              <div>
                <p className="mb-1 text-xs font-bold uppercase tracking-[0.14em] text-cyan-700">Financiamiento</p>
                <h3 className="text-lg font-bold text-slate-900 sm:text-xl">
              Solicitar Credito
                </h3>
              </div>
              <ArrowUpRight className="h-5 w-5 text-cyan-600" />
            </div>
            <p className="mb-4 text-xs text-slate-500 sm:text-sm">
              Accede a creditos de multiples cooperativas
            </p>
            <button
              disabled={needsOnboarding}
              onClick={handleRequestCredit}
              className={`w-full py-2.5 sm:py-3 rounded-xl font-medium flex items-center justify-center gap-2 ${
                needsOnboarding
                  ? "bg-gray-200 text-gray-500 cursor-not-allowed"
                  : "bg-[#123f77] text-white shadow-md hover:bg-[#0f2454]"
              }`}
            >
              <Plus className="w-5 h-5" />
              Nueva Solicitud
            </button>
          </div>

          <div
            className={`rounded-2xl border bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:shadow-lg sm:p-6 ${
              needsOnboarding
                ? "border-slate-200 opacity-75"
                : "border-slate-200 hover:border-emerald-300"
            }`}
          >
            <div className="mb-4 w-fit rounded-xl bg-emerald-50 p-3">
              <Wallet className="h-6 w-6 text-emerald-700 sm:h-8 sm:w-8" />
            </div>
            <div className="mb-5 flex items-start justify-between">
              <div>
                <p className="mb-1 text-xs font-bold uppercase tracking-[0.14em] text-emerald-700">Crecimiento</p>
                <h3 className="text-lg font-bold text-slate-900 sm:text-xl">
              Realizar Inversion
                </h3>
              </div>
              <Sparkles className="h-5 w-5 text-emerald-600" />
            </div>
            <p className="mb-4 text-xs text-slate-500 sm:text-sm">
              Invierte de forma segura con buenas tasas
            </p>
            <button
              disabled={needsOnboarding}
              onClick={handleRequestInvestment}
              className={`w-full py-2.5 sm:py-3 rounded-xl font-medium flex items-center justify-center gap-2 ${
                needsOnboarding
                  ? "bg-gray-200 text-gray-500 cursor-not-allowed"
                  : "bg-emerald-600 text-white hover:bg-emerald-700 shadow-md"
              }`}
            >
              <Plus className="w-5 h-5" />
              Nueva Inversion
            </button>
          </div>
        </div>
        )}

        {activeSection !== "overview" && <div className="portal-panel overflow-hidden">
          <div className="flex items-center justify-between border-b border-slate-200 bg-white px-2">
            <div className="flex items-center gap-3 px-5 py-4">
              {activeSection === "requests" ? (
                <ClipboardList className="h-5 w-5 text-cyan-700" />
              ) : (
                <Landmark className="h-5 w-5 text-cyan-700" />
              )}
              <span className="font-bold text-[#123f77]">
                {activeSection === "requests" ? "Mis solicitudes" : "Cooperativas aliadas"}
              </span>
            </div>
          </div>

          <div className="p-4 sm:p-7">
            <div className="mb-6 flex items-end justify-between gap-4">
              <div>
                <p className="text-xs font-bold uppercase tracking-[0.14em] text-slate-400">Actividad</p>
                <h2 className="mt-1 text-xl font-bold text-slate-900">{activeSection === "requests" ? "Seguimiento de tus solicitudes" : "Encuentra una cooperativa aliada"}</h2>
              </div>
              <span className="hidden rounded-full bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-500 sm:inline-flex">{activeSection === "requests" ? `${creditRequests.length} registros` : `${cooperatives.length} entidades`}</span>
            </div>
            {isLoading ? (
              <div className="text-center py-16">Cargando...</div>
            ) : (
              activeSection === "requests" ? (
              creditRequests.length === 0 ? (
                <div className="text-center py-16">
                  <FileText className="w-10 h-10 mx-auto mb-4 text-gray-400" />
                  <p className="mb-4 text-gray-600">
                    {needsOnboarding
                      ? "Completa tu perfil para crear solicitudes"
                      : "Crea tu primera solicitud"}
                  </p>
                  {needsOnboarding ? (
                    <button
                      onClick={handleGoToOnboarding}
                      className="rounded-xl bg-[#123f77] px-6 py-3 text-white"
                    >
                      Completar Perfil
                    </button>
                  ) : (
                    <button
                      onClick={handleRequestCredit}
                      className="rounded-xl bg-[#123f77] px-6 py-3 text-white"
                    >
                      Crear Solicitud
                    </button>
                  )}
                </div>
              ) : (
                <div className="grid md:grid-cols-2 gap-6">
                  {creditRequests.map((r) => (
                    <CreditCard key={`${r.solicitudId}`} request={r} />
                  ))}
                </div>
              )
            ) : (
              <div className="grid md:grid-cols-3 gap-6">
                {cooperatives.map((c) => (
                  <CooperativeCard key={c.id} cooperative={c} />
                ))}
              </div>
            ))}
          </div>
        </div>}
          </div>
        </main>
      </div>

      <OnboardingPopup
        open={showOnboardingCompletedPopup}
        title="Formulario completado"
        message="Tu informacion ya fue registrada correctamente. Ya puedes solicitar creditos y tus datos ya fueron enviados a las cooperativas."
        primaryText="Solicitar credito"
        onPrimary={() => {
          setShowOnboardingCompletedPopup(false);
          setShowCreditModal(true);
        }}
        onClose={() => setShowOnboardingCompletedPopup(false)}
      />

      <NewCreditModal
        open={showCreditModal}
        onClose={() => setShowCreditModal(false)}
        onSubmit={handleCreditSubmit}
      />

      <NewInvestmentModal
        open={showInvestmentModal}
        onClose={() => setShowInvestmentModal(false)}
        onSubmit={handleInvestmentSubmit}
      />

      {creditSuccess && (
        <div className="fixed bottom-6 right-6 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg flex items-center gap-2 z-40">
          <CheckCircle className="w-5 h-5" />
          Tu solicitud de credito fue enviada exitosamente
        </div>
      )}

      {investmentSuccess && (
        <div className="fixed bottom-6 right-6 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg flex items-center gap-2 z-40">
          <CheckCircle className="w-5 h-5" />
          Tu inversion fue registrada exitosamente
        </div>
      )}

    </div>
  );
}
