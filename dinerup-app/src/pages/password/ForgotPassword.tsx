import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { forgotPassword } from "../../api/auth/auth.api";
import { getErrorMessage } from "../../api/errors";

export default function ForgotPassword() {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const submit = async () => {
    setError(null);
    const normalizedEmail = email.trim().toLowerCase();
    if (!/^\S+@\S+\.\S+$/.test(normalizedEmail)) {
      setError("Ingresa un correo electrónico válido.");
      return;
    }

    try {
      setLoading(true);
      await forgotPassword(normalizedEmail);
      navigate(`/reset-password?email=${encodeURIComponent(normalizedEmail)}`);
    } catch (e) {
      setError(getErrorMessage(e, "No se pudo procesar la solicitud."));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-neutral-50 px-4">
      <div className="w-full max-w-md rounded-2xl bg-white shadow-xl p-6 border border-neutral-100">
        <h1 className="text-2xl font-bold mb-2">Recuperar contrasena</h1>
        <p className="text-sm text-neutral-600 mb-4">
          Si el correo está registrado, te enviaremos un código para restablecer tu contraseña.
        </p>

        <label className="block text-sm font-semibold text-neutral-700 mb-1">
          Correo electronico
        </label>
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full px-4 py-2.5 border-2 border-neutral-200 rounded-xl focus:ring-2 focus:ring-brand-primary transition-all"
          placeholder="tu@email.com"
        />

        {error && (
          <div className="mt-4 p-3 bg-red-50 border-l-4 border-red-500 rounded-r-lg">
            <p className="text-red-700 text-sm font-medium">{error}</p>
          </div>
        )}

        <button
          onClick={submit}
          disabled={loading}
          className="mt-4 w-full bg-gradient-to-r from-brand-secondary to-brand-dark text-white py-3 rounded-xl font-semibold hover:opacity-90 transition-all shadow-lg disabled:opacity-60"
        >
          {loading ? "Enviando..." : "Enviar código"}
        </button>

        <div className="mt-4 text-center">
          <Link
            to="/"
            className="text-sm font-semibold text-brand-primary hover:underline"
          >
            Volver al login
          </Link>
        </div>
      </div>
    </div>
  );
}
