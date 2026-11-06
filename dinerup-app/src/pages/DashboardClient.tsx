import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Plus,
  FileText,
  AlertCircle,
  CheckCircle,
  TrendingUp,
  Wallet,
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
import Footer from "../components/layout/Footer";
import OnboardingPopup from "../components/onboarding/OnboardingPopup";
import NewCreditModal from "../components/credit/NewCreditModal";
import NewInvestmentModal from "../components/investment/NewInvestmentModal";

export default function DashboardClient() {
  const { user } = useAuth();
  const navigate = useNavigate();

  const [cooperatives, setCooperatives] = useState<Cooperative[]>([]);
  const [creditRequests, setCreditRequests] = useState<CreditRequest[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [pageError, setPageError] = useState("");
  const [activeTab, setActiveTab] = useState<"cooperatives" | "requests">(
    "requests",
  );

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
    <div className="flex min-h-screen flex-col bg-[#f5f8fc]">
      <Navbar />

      <main className="flex-1 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        <div className="mb-8 overflow-hidden rounded-[2rem] bg-gradient-to-br from-[#0f2454] via-[#123f77] to-[#0ea5a4] p-6 text-white shadow-xl shadow-slate-300/40 sm:p-9">
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
        </div>

        {needsOnboarding && (
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

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6 mb-6 sm:mb-8">
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
            <h3 className="mb-2 text-lg font-bold text-slate-900 sm:text-xl">
              Solicitar Credito
            </h3>
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
            <h3 className="mb-2 text-lg font-bold text-slate-900 sm:text-xl">
              Realizar Inversion
            </h3>
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

        <div className="bg-white rounded-2xl shadow-md overflow-hidden">
          <div className="flex border-b border-slate-200 bg-slate-50">
            {(["requests", "cooperatives"] as const).map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`flex-1 py-4 font-medium ${
                  activeTab === tab
                    ? "bg-white text-[#123f77] shadow-[inset_0_-2px_0_#06b6d4]"
                    : "text-slate-500 hover:text-slate-900"
                }`}
              >
                {tab === "requests" ? "Mis Solicitudes" : "Cooperativas"}
              </button>
            ))}
          </div>

          <div className="p-4 sm:p-6">
            {isLoading ? (
              <div className="text-center py-16">Cargando...</div>
            ) : activeTab === "requests" ? (
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
            )}
          </div>
        </div>
      </main>

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

      <Footer />
    </div>
  );
}
