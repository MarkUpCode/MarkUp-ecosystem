import { useState } from "react";
import { X, AlertCircle, DollarSign, Tag, Clock, MapPin, CreditCard, ChevronDown } from "lucide-react";
import { ecuadorProvinces } from "../../data/ecuadorProvinces";

export interface CreditModalSubmitData {
  amount: number;
  creditType: string;
  plazoMeses: number;
  cedula: string;
  provincia: string;
  ciudad: string;
}

interface NewCreditModalProps {
  open: boolean;
  onClose: () => void;
  onSubmit: (data: CreditModalSubmitData) => void;
}

const creditTypes = [
  { id: "CONSUMO",     label: "Consumo" },
  { id: "MICROCREDITO", label: "Microcrédito" },
];

const plazosOptions = [6, 12, 18, 24, 36, 48, 60];

const EMPTY_ERRORS = {
  amount:   "",
  cedula:   "",
  provincia: "",
  ciudad:   "",
};

export default function NewCreditModal({ open, onClose, onSubmit }: NewCreditModalProps) {
  const [amount,     setAmount]     = useState("");
  const [creditType, setCreditType] = useState("CONSUMO");
  const [plazoMeses, setPlazoMeses] = useState(12);
  const [cedula,     setCedula]     = useState("");
  const [provincia,  setProvincia]  = useState("");
  const [ciudad,     setCiudad]     = useState("");
  const [errors,     setErrors]     = useState({ ...EMPTY_ERRORS });

  const provinciaData = ecuadorProvinces.Ecuador.find((p) => p.provincia === provincia);
  const cantones = provinciaData?.cantones.map((c) => c.nombre) ?? [];

  const handleProvinciaChange = (val: string) => {
    setProvincia(val);
    setCiudad("");
    setErrors((e) => ({ ...e, provincia: "", ciudad: "" }));
  };

  const validate = () => {
    const next = { ...EMPTY_ERRORS };
    if (!amount || parseFloat(amount) <= 0)   next.amount   = "Ingresa un monto válido";
    if (!cedula.trim() || cedula.length !== 10) next.cedula = "Ingresa una cédula válida (10 dígitos)";
    if (!provincia)                            next.provincia = "Selecciona una provincia";
    if (!ciudad)                               next.ciudad   = "Selecciona un cantón";
    setErrors(next);
    return Object.values(next).every((v) => v === "");
  };

  const handleSubmit = () => {
    if (!validate()) return;

    onSubmit({
      amount: parseFloat(amount),
      creditType,
      plazoMeses,
      cedula: cedula.trim(),
      provincia,
      ciudad,
    });

    // Reset
    setAmount("");
    setCreditType("CONSUMO");
    setPlazoMeses(12);
    setCedula("");
    setProvincia("");
    setCiudad("");
    setErrors({ ...EMPTY_ERRORS });
    onClose();
  };

  if (!open) return null;

  const inputClass = (err: string) =>
    `w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none transition ${
      err ? "border-red-500 focus:ring-red-500" : "border-gray-300"
    }`;

  const selectClass = (err = "") =>
    `w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none transition appearance-none bg-white disabled:bg-gray-50 disabled:text-gray-400 disabled:cursor-not-allowed ${
      err ? "border-red-500 focus:ring-red-500" : "border-gray-300"
    }`;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full max-h-[90vh] overflow-y-auto">

        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-gray-200">
          <h2 className="text-2xl font-bold text-gray-800">Solicitar Crédito</h2>
          <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
            <X className="w-6 h-6 text-gray-600" />
          </button>
        </div>

        <div className="p-6 space-y-5">

          {/* Banner */}
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 flex gap-3">
            <AlertCircle className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
            <div className="text-sm text-blue-800">
              <p className="font-semibold mb-1">Tu solicitud será enviada a:</p>
              <p>Todas las cooperativas de tu ciudad que puedan atenderte según tu ubicación.</p>
            </div>
          </div>

          {/* Cédula */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <div className="flex items-center gap-2"><CreditCard className="w-4 h-4 text-gray-600" /> Cédula de identidad</div>
            </label>
            <input
              type="text"
              value={cedula}
              maxLength={10}
              onChange={(e) => { setCedula(e.target.value.replace(/\D/g, "")); setErrors((er) => ({ ...er, cedula: "" })); }}
              placeholder="Ej: 1234567890"
              className={inputClass(errors.cedula)}
            />
            {errors.cedula && <p className="text-red-600 text-xs mt-1">{errors.cedula}</p>}
          </div>

          {/* Monto */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <div className="flex items-center gap-2"><DollarSign className="w-4 h-4 text-gray-600" /> Monto que deseas solicitar</div>
            </label>
            <input
              type="number"
              value={amount}
              min="0"
              step="100"
              onChange={(e) => { setAmount(e.target.value); setErrors((er) => ({ ...er, amount: "" })); }}
              placeholder="Ej: 5000"
              className={inputClass(errors.amount)}
            />
            {errors.amount && <p className="text-red-600 text-xs mt-1">{errors.amount}</p>}
            {amount && parseFloat(amount) > 0 && (
              <p className="text-xs text-gray-500 mt-1">
                Monto: ${parseFloat(amount).toLocaleString("es-EC", { minimumFractionDigits: 2 })}
              </p>
            )}
          </div>

          {/* Tipo de crédito */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <div className="flex items-center gap-2"><Tag className="w-4 h-4 text-gray-600" /> Tipo de crédito</div>
            </label>
            <div className="relative">
              <select value={creditType} onChange={(e) => setCreditType(e.target.value)} className={selectClass()}>
                {creditTypes.map((t) => <option key={t.id} value={t.id}>{t.label}</option>)}
              </select>
              <ChevronDown className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            </div>
          </div>

          {/* Plazo */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <div className="flex items-center gap-2"><Clock className="w-4 h-4 text-gray-600" /> Plazo</div>
            </label>
            <div className="relative">
              <select value={plazoMeses} onChange={(e) => setPlazoMeses(Number(e.target.value))} className={selectClass()}>
                {plazosOptions.map((p) => <option key={p} value={p}>{p} meses</option>)}
              </select>
              <ChevronDown className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            </div>
          </div>

          {/* Ubicación */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <div className="flex items-center gap-2"><MapPin className="w-4 h-4 text-gray-600" /> Ubicación</div>
            </label>
            <div className="space-y-3">

              {/* Provincia */}
              <div className="relative">
                <select
                  value={provincia}
                  onChange={(e) => handleProvinciaChange(e.target.value)}
                  className={selectClass(errors.provincia)}
                >
                  <option value="">Selecciona una provincia</option>
                  {ecuadorProvinces.Ecuador.map((p) => (
                    <option key={p.provincia} value={p.provincia}>{p.provincia}</option>
                  ))}
                </select>
                <ChevronDown className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                {errors.provincia && <p className="text-red-600 text-xs mt-1">{errors.provincia}</p>}
              </div>

              {/* Cantón / Ciudad */}
              <div className="relative">
                <select
                  value={ciudad}
                  onChange={(e) => { setCiudad(e.target.value); setErrors((er) => ({ ...er, ciudad: "" })); }}
                  disabled={!provincia}
                  className={selectClass(errors.ciudad)}
                >
                  <option value="">
                    {provincia ? "Selecciona un cantón" : "Primero elige una provincia"}
                  </option>
                  {cantones.map((c) => <option key={c} value={c}>{c}</option>)}
                </select>
                <ChevronDown className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                {errors.ciudad && <p className="text-red-600 text-xs mt-1">{errors.ciudad}</p>}
              </div>

            </div>
          </div>

          {/* Aviso */}
          <div className="bg-amber-50 border border-amber-200 rounded-lg p-4">
            <p className="text-xs text-amber-800">
              <strong>Importante:</strong> Una vez envíes esta solicitud no podrás modificarla.
              Verifica que todos los datos sean correctos.
            </p>
          </div>

        </div>

        {/* Footer */}
        <div className="border-t border-gray-200 p-6 bg-gray-50 flex gap-3">
          <button
            onClick={onClose}
            className="flex-1 px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 rounded-lg font-medium transition-colors"
          >
            Cancelar
          </button>
          <button
            onClick={handleSubmit}
            className="flex-1 px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg font-medium transition-colors"
          >
            Enviar Solicitud
          </button>
        </div>

      </div>
    </div>
  );
}
