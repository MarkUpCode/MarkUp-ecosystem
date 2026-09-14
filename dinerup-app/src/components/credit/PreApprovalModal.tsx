import { AlertCircle, CheckCircle, Shield, X } from "lucide-react";
import { useEffect, useState } from "react";
import type { CooperativeOfferDefaults } from "../../types/credit";

interface PreApprovalModalProps {
  open: boolean;
  onClose: () => void;
  solicitudId: number;
  monto: number;
  tipo: string;
  defaults: CooperativeOfferDefaults | null;
  loadingDefaults: boolean;
  onApproveWithoutGuarantee: (
    solicitudId: number,
    offer: { tasaAnual: number; plazoMeses: number },
  ) => Promise<void>;
  onApproveWithGuarantee: (solicitudId: number) => Promise<void>;
  isLoading: boolean;
}

export default function PreApprovalModal({
  open,
  onClose,
  solicitudId,
  monto,
  tipo,
  defaults,
  loadingDefaults,
  onApproveWithoutGuarantee,
  onApproveWithGuarantee,
  isLoading,
}: PreApprovalModalProps) {
  const [tasaAnual, setTasaAnual] = useState("");
  const [plazoMeses, setPlazoMeses] = useState("");
  const [formError, setFormError] = useState("");

  useEffect(() => {
    if (open && defaults) {
      setTasaAnual(String(defaults.tasaAnual));
      setPlazoMeses(String(defaults.plazoMeses));
      setFormError("");
    }
  }, [open, defaults]);

  if (!open) return null;

  const handleWithoutGuarantee = async () => {
    const tasa = Number(tasaAnual);
    const plazo = Number(plazoMeses);
    if (
      !Number.isFinite(tasa) || tasa <= 0 || tasa > 100 ||
      !Number.isInteger(plazo) || plazo < 1 || plazo > 360
    ) {
      setFormError("Ingresa una tasa entre 0.001% y 100%, y un plazo entre 1 y 360 meses.");
      return;
    }
    try {
      await onApproveWithoutGuarantee(solicitudId, {
        tasaAnual: tasa,
        plazoMeses: plazo,
      });
      onClose();
    } catch {
      return;
    }
  };

  const handleWithGuarantee = async () => {
    try {
      await onApproveWithGuarantee(solicitudId);
      onClose();
    } catch {
      return;
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-[70]">
      <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full">
        <div className="bg-gradient-to-r from-green-50 to-emerald-50 border-b border-green-200 p-6 flex items-start justify-between">
          <div className="flex items-start gap-4 flex-1">
            <div className="flex-shrink-0 p-3 bg-green-100 rounded-full">
              <CheckCircle className="w-8 h-8 text-green-600" />
            </div>
            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-1">
                Pre-aprobacion de Solicitud
              </h2>
              <p className="text-gray-600 text-sm">
                Selecciona si requiere garante para esta aprobacion
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            disabled={isLoading}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors disabled:opacity-50"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
        </div>

        <div className="p-8">
          <div className="mb-8 p-5 bg-blue-50 border border-blue-200 rounded-lg">
            <div className="grid grid-cols-3 gap-4">
              <div>
                <p className="text-xs text-blue-700 font-medium mb-1">
                  Solicitud #
                </p>
                <p className="text-lg font-bold text-gray-900">
                  {solicitudId}
                </p>
              </div>
              <div>
                <p className="text-xs text-blue-700 font-medium mb-1">
                  Monto Solicitado
                </p>
                <p className="text-lg font-bold text-gray-900">
                  ${monto.toLocaleString("es-EC")}
                </p>
              </div>
              <div>
                <p className="text-xs text-blue-700 font-medium mb-1">Tipo</p>
                <p className="text-lg font-bold text-gray-900">{tipo}</p>
              </div>
            </div>
          </div>

          <div className="mb-6 rounded-xl border border-gray-200 p-5">
            <h3 className="font-semibold text-gray-900">Oferta para el cliente</h3>
            <p className="mt-1 text-sm text-gray-600">
              Se precarga la tasa estándar de tu cooperativa. Puedes cambiar tasa y plazo solo para esta solicitud.
            </p>
            {loadingDefaults ? (
              <p className="mt-4 text-sm text-gray-600">Cargando tasa estándar...</p>
            ) : (
              <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-2">
                <label className="text-sm font-medium text-gray-700">
                  Tasa anual (%)
                  <input type="number" min="0.001" max="100" step="0.001" value={tasaAnual} onChange={(event) => setTasaAnual(event.target.value)} className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2" />
                </label>
                <label className="text-sm font-medium text-gray-700">
                  Plazo (meses)
                  <input type="number" min="1" max="360" step="1" value={plazoMeses} onChange={(event) => setPlazoMeses(event.target.value)} className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2" />
                </label>
              </div>
            )}
            {formError && <p className="mt-3 text-sm text-red-600">{formError}</p>}
          </div>

          <div className="mb-8">
            <p className="text-sm font-semibold text-gray-700 mb-4">
              Requiere garante para esta aprobacion?
            </p>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <button
                onClick={handleWithoutGuarantee}
                disabled={isLoading || loadingDefaults || !defaults}
                className="relative group p-6 rounded-xl border-2 border-gray-200 hover:border-green-400 transition-all hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed text-left"
              >
                <div className="absolute -top-3 -right-3">
                  <span className="inline-block px-3 py-1 bg-green-600 text-white text-xs font-bold rounded-full">
                    RECOMENDADO
                  </span>
                </div>

                <div className="flex items-start gap-3 mb-3">
                  <div className="flex-shrink-0 p-3 bg-green-100 rounded-lg group-hover:bg-green-200 transition">
                    <CheckCircle className="w-6 h-6 text-green-600" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-bold text-gray-900 text-lg mb-1">
                      Sin Garante
                    </h3>
                    <p className="text-sm text-gray-600 leading-relaxed">
                      Aprobacion directa sin requisito de garante.
                    </p>
                  </div>
                </div>

                {isLoading && (
                  <div className="mt-4 text-xs text-blue-600 font-medium">
                    Procesando...
                  </div>
                )}
              </button>

              <button
                onClick={handleWithGuarantee}
                disabled={isLoading}
                className="relative group p-6 rounded-xl border-2 border-gray-200 hover:border-blue-400 transition-all hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed text-left"
              >
                <div className="flex items-start gap-3 mb-3">
                  <div className="flex-shrink-0 p-3 bg-blue-100 rounded-lg group-hover:bg-blue-200 transition">
                    <Shield className="w-6 h-6 text-blue-600" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-bold text-gray-900 text-lg mb-1">
                      Con Garante
                    </h3>
                    <p className="text-sm text-gray-600 leading-relaxed">
                      Aprobacion que requiere un garante.
                    </p>
                  </div>
                </div>

                {isLoading && (
                  <div className="mt-4 text-xs text-blue-600 font-medium">
                    Procesando...
                  </div>
                )}
              </button>
            </div>
          </div>

          <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 flex gap-3 mb-6">
            <AlertCircle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
            <p className="text-sm text-amber-900">
              <span className="font-semibold">Nota:</span> Esta decision sera
              notificada al cliente para que complete su formulario de garante.
            </p>
          </div>

          <div className="flex gap-3">
            <button
              onClick={onClose}
              disabled={isLoading}
              className="flex-1 px-4 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition font-semibold disabled:opacity-50"
            >
              Cancelar
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
