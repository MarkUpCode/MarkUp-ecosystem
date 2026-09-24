import { useEffect, useMemo, useState, type ReactNode } from "react";
import { X } from "lucide-react";
import {
  resendRegistrationOtp,
  setRegistrationPassword,
  startRegistrationOtp,
  verifyRegistrationOtp,
} from "../../api/auth/auth.api";
import { getErrorMessage } from "../../api/errors";

type Props = {
  defaultEmail?: string;
  initialStep?: "profile" | "verify" | "password";
  onCompleted: () => void;
  onClose: () => void;
};

export default function CompleteRegistrationModal({
  defaultEmail = "",
  initialStep = "profile",
  onCompleted,
  onClose,
}: Props) {
  const [step, setStep] = useState<"profile" | "verify" | "password">(initialStep);
  const [email, setEmail] = useState(defaultEmail);
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [identification, setIdentification] = useState("");
  const [phone, setPhone] = useState("");
  const [province, setProvince] = useState("");
  const [city, setCity] = useState("");
  const [code, setCode] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [countdown, setCountdown] = useState(45);

  useEffect(() => {
    if (step !== "verify" || countdown <= 0) return;

    const timer = window.setTimeout(() => {
      setCountdown((current) => current - 1);
    }, 1000);

    return () => window.clearTimeout(timer);
  }, [countdown, step]);

  const canResend = useMemo(() => countdown <= 0, [countdown]);

  const handleStart = async () => {
    setError(null);

    const trimmedEmail = email.trim();
    const trimmedFirstName = firstName.trim();
    const trimmedLastName = lastName.trim();
    const trimmedIdentification = identification.trim();

    if (!trimmedEmail || !trimmedFirstName || !trimmedLastName || !trimmedIdentification) {
      setError("Completa tu correo, nombres, apellidos y cédula para continuar.");
      return;
    }

    try {
      setLoading(true);
      await startRegistrationOtp({
        email: trimmedEmail,
        firstName: trimmedFirstName,
        lastName: trimmedLastName,
        identification: trimmedIdentification,
        phone: phone.trim(),
        province: province.trim(),
        city: city.trim(),
      });
      setStep("verify");
      setCode("");
      setCountdown(45);
    } catch (e) {
      setError(getErrorMessage(e, "No se pudo enviar el código de verificación."));
    } finally {
      setLoading(false);
    }
  };

  const handleVerify = async () => {
    setError(null);

    if (code.trim().length !== 6) {
      setError("Ingresa el código de 6 dígitos.");
      return;
    }

    try {
      setLoading(true);
      await verifyRegistrationOtp({ email: email.trim(), code: code.trim() });
      setStep("password");
      setError(null);
    } catch (e) {
      setError(getErrorMessage(e, "El código no es válido o ya expiró."));
    } finally {
      setLoading(false);
    }
  };

  const handleResend = async () => {
    if (!canResend) return;

    setError(null);
    try {
      setLoading(true);
      await resendRegistrationOtp(email.trim());
      setCountdown(45);
      setCode("");
    } catch (e) {
      setError(getErrorMessage(e, "No se pudo reenviar el código."));
    } finally {
      setLoading(false);
    }
  };

  const handlePasswordSubmit = async () => {
    setError(null);

    if (password.length < 8) {
      setError("La contraseña debe tener al menos 8 caracteres.");
      return;
    }

    if (password !== confirmPassword) {
      setError("Las contraseñas no coinciden.");
      return;
    }

    try {
      setLoading(true);
      await setRegistrationPassword({ email: email.trim(), password });
      onCompleted();
    } catch (e) {
      setError(getErrorMessage(e, "No se pudo crear la contraseña."));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4">
      <div className="w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl relative">
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition"
          aria-label="Cerrar"
        >
          <X className="w-5 h-5" />
        </button>

        <div className="mb-5">
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-indigo-600">
            Registro moderno
          </p>
          <h2 className="mt-2 text-2xl font-bold text-neutral-900">
            {step === "profile" && "Crea tu cuenta"}
            {step === "verify" && "Verifica tu correo"}
            {step === "password" && "Define tu contraseña"}
          </h2>
        </div>

        {error && (
          <div className="mb-4 rounded-xl border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
            {error}
          </div>
        )}

        {step === "profile" && (
          <div className="space-y-4">
            <div className="grid gap-4 md:grid-cols-2">
              <Field label="Nombres">
                <input value={firstName} onChange={(e) => setFirstName(e.target.value)} className="input-base" placeholder="Juan" />
              </Field>
              <Field label="Apellidos">
                <input value={lastName} onChange={(e) => setLastName(e.target.value)} className="input-base" placeholder="Pérez" />
              </Field>
            </div>

            <Field label="Correo electrónico">
              <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} className="input-base" placeholder="tu@email.com" />
            </Field>

            <div className="grid gap-4 md:grid-cols-2">
              <Field label="Cédula">
                <input value={identification} onChange={(e) => setIdentification(e.target.value)} className="input-base" placeholder="1712345678" />
              </Field>
              <Field label="Teléfono">
                <input value={phone} onChange={(e) => setPhone(e.target.value)} className="input-base" placeholder="0999999999" />
              </Field>
            </div>

            <div className="grid gap-4 md:grid-cols-2">
              <Field label="Provincia">
                <input value={province} onChange={(e) => setProvince(e.target.value)} className="input-base" placeholder="Pichincha" />
              </Field>
              <Field label="Ciudad">
                <input value={city} onChange={(e) => setCity(e.target.value)} className="input-base" placeholder="Quito" />
              </Field>
            </div>

            <button
              type="button"
              onClick={handleStart}
              disabled={loading}
              className="w-full rounded-xl bg-gradient-to-r from-indigo-600 to-indigo-800 px-4 py-3 font-semibold text-white shadow-lg transition hover:opacity-95 disabled:opacity-60"
            >
              {loading ? "Enviando código..." : "Enviar código de verificación"}
            </button>
          </div>
        )}

        {step === "verify" && (
          <div className="space-y-4">
            <p className="text-sm text-neutral-600">
              Te enviamos un código a <span className="font-semibold text-neutral-800">{email}</span>.
            </p>

            <Field label="Código de verificación">
              <input
                value={code}
                onChange={(e) => setCode(e.target.value.replace(/\D/g, "").slice(0, 6))}
                inputMode="numeric"
                maxLength={6}
                className="input-base text-center text-xl tracking-[0.5em]"
                placeholder="123456"
              />
            </Field>

            <div className="flex items-center justify-between gap-3 text-sm">
              <button
                type="button"
                onClick={() => setStep("profile")}
                className="font-medium text-indigo-600 hover:text-indigo-700"
              >
                Cambiar email
              </button>

              <button
                type="button"
                onClick={handleResend}
                disabled={!canResend || loading}
                className="font-medium text-neutral-700 disabled:text-neutral-400"
              >
                {canResend ? "Reenviar código" : `Reenviar en ${countdown}s`}
              </button>
            </div>

            <button
              type="button"
              onClick={handleVerify}
              disabled={loading}
              className="w-full rounded-xl bg-indigo-600 px-4 py-3 font-semibold text-white transition hover:bg-indigo-700 disabled:opacity-60"
            >
              {loading ? "Verificando..." : "Continuar"}
            </button>
          </div>
        )}

        {step === "password" && (
          <div className="space-y-4">
            <Field label="Nueva contraseña">
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="input-base"
                placeholder="Mínimo 8 caracteres"
              />
            </Field>

            <Field label="Confirmar contraseña">
              <input
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                className="input-base"
                placeholder="Repite tu contraseña"
              />
            </Field>

            <button
              type="button"
              onClick={handlePasswordSubmit}
              disabled={loading}
              className="w-full rounded-xl bg-gradient-to-r from-emerald-500 to-emerald-700 px-4 py-3 font-semibold text-white shadow-lg transition hover:opacity-95 disabled:opacity-60"
            >
              {loading ? "Guardando..." : "Crear cuenta"}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

function Field({ label, children }: { label: string; children: ReactNode }) {
  return (
    <label className="block">
      <span className="mb-1.5 block text-sm font-semibold text-neutral-700">{label}</span>
      {children}
    </label>
  );
}
