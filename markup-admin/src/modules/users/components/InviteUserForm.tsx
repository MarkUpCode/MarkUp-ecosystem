import { useState } from "react";

import type { InviteUserRequest } from "../types/user";

interface InviteUserFormProps {

  loading?: boolean;

  onSubmit: (request: InviteUserRequest) => Promise<void>;

}

export function InviteUserForm({

  loading = false,

  onSubmit,

}: InviteUserFormProps) {

  const [email, setEmail] = useState("");

  const [role, setRole] =
    useState<InviteUserRequest["role"]>("CLIENT");

  const [cooperativaId, setCooperativaId] =
    useState("");

  async function handleSubmit(
    e: React.FormEvent
  ) {

    e.preventDefault();

    await onSubmit({

      email,

      role,

      cooperativaId:
        role === "COOPERATIVE"
          ? Number(cooperativaId)
          : null,

    });

    setEmail("");

    setRole("CLIENT");

    setCooperativaId("");

  }

  return (

    <form
      onSubmit={handleSubmit}
      className="space-y-6"
    >

      {/* EMAIL */}

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

            ID Cooperativa

          </label>

          <input
            required
            value={cooperativaId}
            onChange={(e)=>
              setCooperativaId(e.target.value)
            }
            className="w-full rounded-2xl border border-white/10 bg-slate-950 px-4 py-3 text-white"
          />

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