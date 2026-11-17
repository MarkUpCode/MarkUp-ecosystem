import { useEffect, useState, type FormEvent } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { activateInvitation, getInvitationDetails, type InvitationDetails } from "../api/auth/auth.api";
import { getErrorMessage } from "../api/errors";

export default function ActivateInvitation() {
  const [params] = useSearchParams();
  const token = params.get("token") ?? "";
  const [details, setDetails] = useState<InvitationDetails | null>(null);
  const [password, setPassword] = useState("");
  const [confirmation, setConfirmation] = useState("");
  const [busy, setBusy] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);

  useEffect(() => {
    if (!token) { setError("El enlace de invitación no contiene un token válido."); setLoading(false); return; }
    void getInvitationDetails(token).then(setDetails).catch((cause) => setError(getErrorMessage(cause, "La invitación no es válida o venció."))).finally(() => setLoading(false));
  }, [token]);

  async function submit(event: FormEvent) {
    event.preventDefault(); setError("");
    if (password !== confirmation) { setError("Las contraseñas no coinciden."); return; }
    setBusy(true);
    try { await activateInvitation(token, password); setSuccess(true); }
    catch (cause) { setError(getErrorMessage(cause, "No se pudo activar la cuenta. Solicita una nueva invitación.")); }
    finally { setBusy(false); }
  }

  return <main className="flex min-h-screen items-center justify-center bg-slate-950 px-4 py-10 text-slate-900"><section className="w-full max-w-lg rounded-3xl bg-white p-8 shadow-2xl"><p className="text-xs font-bold uppercase tracking-[0.2em] text-cyan-700">DINEROP</p><h1 className="mt-2 text-2xl font-extrabold">Activa tu cuenta</h1>
    {loading ? <p className="mt-5 text-slate-500">Validando invitación…</p> : success ? <div className="mt-5 space-y-4"><p className="rounded-xl bg-emerald-50 p-4 text-emerald-800">Cuenta activada correctamente. Ya puedes iniciar sesión.</p><Link className="block rounded-xl bg-cyan-700 px-4 py-3 text-center font-semibold text-white" to="/login">Ir al inicio de sesión</Link></div> : details ? <><div className="mt-5 rounded-2xl bg-slate-50 p-4 text-sm"><p><strong>Invitado:</strong> {details.firstName} {details.lastName}</p><p className="mt-1"><strong>Correo:</strong> {details.email}</p><p className="mt-1"><strong>Rol:</strong> {details.role}</p>{details.cooperativeName && <p className="mt-1"><strong>Cooperativa:</strong> {details.cooperativeName}</p>}<p className="mt-2 text-xs text-slate-500">Invitación válida hasta {new Date(details.expiresAt).toLocaleString("es-EC")}.</p></div><form onSubmit={submit} className="mt-5 space-y-4"><label className="block text-sm font-medium">Crear contraseña<input required minLength={10} maxLength={128} type="password" autoComplete="new-password" value={password} onChange={(e) => setPassword(e.target.value)} className="mt-1 w-full rounded-xl border border-slate-300 px-4 py-3" /></label><label className="block text-sm font-medium">Confirmar contraseña<input required minLength={10} maxLength={128} type="password" autoComplete="new-password" value={confirmation} onChange={(e) => setConfirmation(e.target.value)} className="mt-1 w-full rounded-xl border border-slate-300 px-4 py-3" /></label><p className="text-xs text-slate-500">El correo, rol y cooperativa de la invitación no se pueden cambiar aquí.</p><button disabled={busy} className="w-full rounded-xl bg-cyan-700 px-4 py-3 font-semibold text-white disabled:opacity-50">{busy ? "Activando…" : "Crear contraseña y activar"}</button></form></> : <p className="mt-5 text-slate-500">No pudimos validar esta invitación. Solicita que te envíen un nuevo enlace.</p>}
    {error && <p role="alert" className="mt-4 rounded-xl bg-red-50 p-3 text-sm text-red-700">{error}</p>}
  </section></main>;
}
