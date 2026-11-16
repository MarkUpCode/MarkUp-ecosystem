import { useEffect, useState } from "react";
import { X, CheckCircle, AlertCircle } from "lucide-react";
import Step1Identity from "../../pages/steps/Step1Identity";
import Step2PersonalDetails from "../../pages/steps/Step2PersonalDetails";
import Step3Address from "../../pages/steps/Step3Address";
import Step4Economic from "../../pages/steps/Step4Economic";
import Step4Review from "../../pages/steps/Step4Review";
import { getMyGuarantorProfiles, submitGuaranteeOnboarding, type GuarantorProfileResponse, type OnboardingPayload, type SolicitanteData } from "../../api/onboarding.api";

interface GuaranteeOnboardingModalProps {
  open: boolean;
  solicitudId: number;
  cooperativaId: number;
  onClose: () => void;
  onSuccess?: () => void;
}

const EMPTY_SOLICITANTE: SolicitanteData = {
  nombres: "",
  apellidos: "",
  cedula: "",
  fechaNacimiento: "",
  estadoCivil: "",
  ocupacion: "",
  empresaTrabajo: "",
  telefono: "",
  email: "",
  tieneConyuge: false,
  direccion: {
    provincia: "",
    canton: "",
    barrio: "",
    callePrincipal: "",
    numero: "",
    referenciaUbicacion: "",
    tipoVivienda: "PROPIA",
  },
  actividadEconomica: {
    nombreNegocio: "",
    direccionNegocio: "",
    tiempoActividad: "",
    telefonoNegocio: "",
  },
  ingresoEgreso: {
    ingresoMensual: 0,
    egresoMensual: 0,
  },
  referencias: [
    {
      nombreCompleto: "",
      tipo: "PERSONAL",
      parentesco: "",
      telefono: "",
    },
  ],
};

export default function GuaranteeOnboardingModal({ open, solicitudId, cooperativaId, onClose, onSuccess }: GuaranteeOnboardingModalProps) {
  const [step, setStep] = useState(1);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");
  const [showSuccessModal, setShowSuccessModal] = useState(false);
  const [profiles, setProfiles] = useState<GuarantorProfileResponse[]>([]);
  const [selectedProfileId, setSelectedProfileId] = useState<number | null>(null);

  const [formData, setFormDataRaw] = useState({
    destinoCredito: "CREDITO",
    solicitante: { ...EMPTY_SOLICITANTE },
    conyuge: null as SolicitanteData | null,
  });

  // Wrapper para garantizar que tieneConyuge siempre sea false en el flujo de garante
  const setFormData = (data: typeof formData | ((prev: typeof formData) => typeof formData)) => {
    if (typeof data === "function") {
      setFormDataRaw((prev) => {
        const updated = data(prev);
        return {
          ...updated,
          solicitante: {
            ...updated.solicitante,
            tieneConyuge: false,
          },
          conyuge: null,
        };
      });
    } else {
      setFormDataRaw({
        ...data,
        solicitante: {
          ...data.solicitante,
          tieneConyuge: false,
        },
        conyuge: null,
      });
    }
  };

  useEffect(() => {
    if (!open) return;
    setStep(1);
    setSelectedProfileId(null);
    setFormDataRaw({ destinoCredito: "CREDITO", solicitante: { ...EMPTY_SOLICITANTE }, conyuge: null });
    getMyGuarantorProfiles().then(setProfiles).catch(() => setProfiles([]));
  }, [open]);

  const selectProfile = (value: string) => {
    const profileId = value ? Number(value) : null;
    setSelectedProfileId(profileId);
    setStep(1);
    if (profileId == null) {
      setFormDataRaw({ destinoCredito: "CREDITO", solicitante: { ...EMPTY_SOLICITANTE }, conyuge: null });
      return;
    }
    const profile = profiles.find((item) => item.id === profileId)?.persona;
    if (!profile) return;
    setFormDataRaw({
      destinoCredito: "CREDITO",
      conyuge: null,
      solicitante: {
        ...EMPTY_SOLICITANTE,
        ...profile,
        fechaNacimiento: profile.fechaNacimiento ?? "",
        estadoCivil: profile.estadoCivil ?? "",
        ocupacion: profile.ocupacion ?? "",
        empresaTrabajo: profile.empresaTrabajo ?? "",
        telefono: profile.telefono ?? "",
        email: "",
        tieneConyuge: false,
        direccion: { ...EMPTY_SOLICITANTE.direccion, ...profile.direccion },
        actividadEconomica: { ...EMPTY_SOLICITANTE.actividadEconomica, ...profile.actividadEconomica },
        ingresoEgreso: { ...EMPTY_SOLICITANTE.ingresoEgreso, ...profile.ingresoEgreso },
        referencias: profile.referencias?.map((item) => ({ ...item, tipo: item.tipo as SolicitanteData["referencias"][number]["tipo"] })) ?? [],
      } as SolicitanteData,
    });
  };

  const nextStep = () => setStep((s) => s + 1);
  const prevStep = () => setStep((s) => s - 1);

  // El garante nunca tiene cónyuge en este flujo, así que siempre son 5 pasos
  const totalSteps = 5;
  const progress = (step / totalSteps) * 100;

  const handleSubmit = async () => {
    try {
      setIsLoading(true);
      setError("");

      const payload: OnboardingPayload = {
        destinoCredito: formData.destinoCredito || "CREDITO",
        solicitante: formData.solicitante,
      };

      const response = await submitGuaranteeOnboarding(payload, solicitudId, cooperativaId, selectedProfileId);

      if (response && response.id) {
        setShowSuccessModal(true);
      } else {
        throw new Error("No se completó correctamente el onboarding del garante");
      }
    } catch (err) {
      const errorMsg = err instanceof Error ? err.message : String(err);
      setError(errorMsg || "Ocurrió un error al guardar la información. Intenta de nuevo.");
    } finally {
      setIsLoading(false);
    }
  };

  const handleSuccessClose = () => {
    setShowSuccessModal(false);
    onClose();
    if (onSuccess) {
      onSuccess();
    }
  };

  if (!open) return null;

  return (
    <>
      {/* Modal principal de onboarding */}
      <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
        <div className="bg-white w-full max-w-3xl p-10 rounded-2xl shadow-xl border border-gray-100 max-h-[90vh] overflow-y-auto">
          {/* Header */}
          <div className="flex items-center justify-between mb-8">
            <div className="flex-1">
              {/* PROGRESS */}
              <div className="mb-6">
                <div className="flex justify-between text-sm font-medium text-gray-600 mb-2">
                  <span>Identidad</span>
                  <span>Otros Datos</span>
                  <span>Domicilio</span>
                  <span>Economía</span>
                  <span>Confirmación</span>
                </div>

                <div className="w-full bg-gray-200 h-2 rounded-full">
                  <div
                    className="h-full bg-primary-600 rounded-full transition-all duration-500"
                    style={{ width: `${progress}%` }}
                  />
                </div>
              </div>

              <h1 className="text-3xl font-bold text-gray-800 mb-2">Completar Información del Garante</h1>
              <p className="text-gray-600 mb-4">
                Puedes reutilizar un garante registrado o agregar uno nuevo. Revisa los datos antes de enviarlos para este crédito.
              </p>
            </div>

            {/* Close button */}
            <button
              onClick={onClose}
              disabled={isLoading}
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors disabled:opacity-50 ml-4"
            >
              <X className="w-6 h-6 text-gray-600" />
            </button>
          </div>

          <div className="mb-6 rounded-xl border border-blue-100 bg-blue-50/70 p-4">
            <label htmlFor="guarantor-profile" className="mb-2 block text-sm font-bold text-slate-800">Garante registrado</label>
            <select id="guarantor-profile" value={selectedProfileId ?? ""} onChange={(event) => selectProfile(event.target.value)} className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2.5 text-sm text-slate-800 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100">
              <option value="">Registrar un garante nuevo</option>
              {profiles.map((profile) => <option key={profile.id} value={profile.id}>{profile.persona.nombres} {profile.persona.apellidos} · {profile.persona.cedula}</option>)}
            </select>
            <p className="mt-2 text-xs leading-5 text-slate-600">Al elegir uno, sus datos se precargan. Puedes corregirlos; cada envío crea una evaluación independiente para este crédito.</p>
          </div>

          {error && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700 flex items-start gap-2">
              <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
              <span>{error}</span>
            </div>
          )}

          {/* Pasos */}
          {step === 1 && (
            <Step1Identity
              data={formData}
              setData={setFormData}
              nextStep={nextStep}
            />
          )}

          {step === 2 && (
            <Step2PersonalDetails
              data={formData}
              setData={setFormData}
              nextStep={nextStep}
              prevStep={prevStep}
            />
          )}

          {step === 3 && (
            <Step3Address
              data={formData}
              setData={setFormData}
              nextStep={nextStep}
              prevStep={prevStep}
            />
          )}

          {step === 4 && (
            <Step4Economic
              data={formData}
              setData={setFormData}
              nextStep={nextStep}
              prevStep={prevStep}
            />
          )}

          {step === 5 && (
            <Step4Review
              data={formData}
              prevStep={prevStep}
              onSubmit={handleSubmit}
              isLoading={isLoading}
            />
          )}
        </div>
      </div>

      {/* Modal de éxito */}
      {showSuccessModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-[60]">
          <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-8">
            <div className="text-center mb-6">
              <div className="inline-flex items-center justify-center w-16 h-16 bg-green-100 rounded-full mb-4">
                <CheckCircle className="w-10 h-10 text-green-600" />
              </div>
              <h2 className="text-2xl font-bold text-gray-900 mb-3">¡Formulario Completado!</h2>
              <p className="text-gray-600 mb-6">
                Tu información como garante ha sido registrada exitosamente.
              </p>
            </div>

            <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-6">
              <h3 className="font-semibold text-green-900 mb-3">Próximos pasos:</h3>
              <ul className="space-y-2 text-sm text-green-800">
                <li className="flex items-start gap-2">
                  <span className="font-bold">•</span>
                  <span>La cooperativa revisará tu información</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="font-bold">•</span>
                  <span>Recibirás notificaciones sobre el estado</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="font-bold">•</span>
                  <span>Podrás monitorear el progreso aquí</span>
                </li>
              </ul>
            </div>

            <button
              onClick={handleSuccessClose}
              className="w-full bg-primary-600 hover:bg-primary-700 text-white px-6 py-3 rounded-xl font-semibold transition-all"
            >
              Entendido
            </button>
          </div>
        </div>
      )}
    </>
  );
}
