import { useEffect, useState } from "react";

import type { InviteUserRequest } from "../types/user";
import { getCooperatives } from "@/modules/cooperatives/api/cooperatives.api";
import type { CooperativeListItem } from "@/modules/cooperatives/types/cooperative";

interface InviteUserFormProps {

  loading?: boolean;

  onSubmit: (request: InviteUserRequest) => Promise<void>;

}

export function InviteUserForm({

  loading = false,

  onSubmit,

}: InviteUserFormProps) {

  const [email, setEmail] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [phone, setPhone] = useState("");

  const [role, setRole] =
    useState<InviteUserRequest["role"]>("CLIENT");

  const [cooperativaId, setCooperativaId] =
    useState("");
  const [cooperatives, setCooperatives] = useState<CooperativeListItem[]>([]);
  const [coopError, setCoopError] = useState("");

  useEffect(() => {
    if (role !== "COOPERATIVE") return;
    void getCooperatives(0, 1000).then((response) => setCooperatives(response.content))
      .catch(() => setCoopError("No se pudieron cargar las cooperativas."));
  }, [role]);

  async function handleSubmit(
    e: React.FormEvent
  ) {

    e.preventDefault();

    await onSubmit({

      email,
      firstName,
      lastName,
      phone: phone || undefined,

      role,

      cooperativaId:
        role === "COOPERATIVE"
          ? Number(cooperativaId)
          : null,

    });

    setEmail("");
    setFirstName("");
    setLastName("");
    setPhone("");

    setRole("CLIENT");

    setCooperativaId("");

  }

  return (

    <form
      onSubmit={handleSubmit}
      className="space-y-6"
    >

      <div className="grid gap-4 sm:grid-cols-2">
        <label className="block text-sm text-slate-300">Nombres<input required value={firstName} onChange={(e) => setFirstName(e.target.value)} className="mt-2 w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-white" /></label>
        <label className="block text-sm text-slate-300">Apellidos<input required value={lastName} onChange={(e) => setLastName(e.target.value)} className="mt-2 w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-white" /></label>
      </div>

      <div>

        <label className="mb-2 block text-sm text-slate-300">

          Correo electrónico

        </label>

        <input
          required
          type="email"
          value={email}
          onChange={(e)=>setEmail(e.target.value)}
          className="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-white outline-none focus:border-cyan-500"
        />

      </div>

      <div>
        <label className="mb-2 block text-sm text-slate-300">Teléfono (opcional)</label>
        <input type="tel" value={phone} onChange={(e) => setPhone(e.target.value)} className="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-white" />
      </div>

      {/* ROL */}

      <div>

        <label className="mb-2 block text-sm text-slate-300">

          Tipo de usuario

        </label>

        <select
          value={role}
          onChange={(e)=>
            setRole(
              e.target.value as InviteUserRequest["role"]
            )
          }
          className="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-white"
        >

          <option value="CLIENT">

            Cliente

          </option>

          <option value="COOPERATIVE">

            Cooperativa

          </option>

          <option value="ADMIN">

            Administrador

          </option>

        </select>

      </div>

      {/* COOPERATIVA */}

      {role === "COOPERATIVE" && (

        <div>

          <label className="mb-2 block text-sm text-slate-300">

            Cooperativa

          </label>

          <select
            required
            value={cooperativaId}
            onChange={(e)=>
              setCooperativaId(e.target.value)
            }
            className="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-white"
          >
            <option value="">Selecciona una cooperativa</option>
            {cooperatives.map((cooperative) => <option key={cooperative.id} value={cooperative.id}>{cooperative.nombre} · {cooperative.ciudad}</option>)}
          </select>
          {coopError && <p className="mt-2 text-sm text-red-300">{coopError}</p>}

        </div>

      )}

      {/* BOTONES */}

      <div className="flex justify-end">

        <button
          disabled={loading}
          className="rounded-2xl bg-cyan-500 px-6 py-3 font-semibold text-slate-950 transition hover:bg-cyan-400 disabled:opacity-50"
        >

          {loading
            ? "Invitando..."
            : "Invitar usuario"}

        </button>

      </div>

    </form>

  );

}
