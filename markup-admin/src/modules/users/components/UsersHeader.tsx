import { Plus } from "lucide-react";

interface UsersHeaderProps {
  onInvite: () => void;
}

export function UsersHeader({
  onInvite,
}: UsersHeaderProps) {
  return (
    <div className="mb-8 flex flex-col gap-4 md:flex-row md:items-center md:justify-between">

      <div>
        <h1 className="text-3xl font-bold text-white">
          Usuarios
        </h1>

        <p className="mt-2 text-sm text-slate-400">
          Administra los usuarios del sistema e invita nuevos administradores,
          cooperativas y clientes.
        </p>
      </div>

      <button
        onClick={onInvite}
        className="inline-flex items-center gap-2 rounded-2xl bg-cyan-500 px-5 py-3 font-semibold text-slate-950 transition hover:bg-cyan-400"
      >
        <Plus className="h-5 w-5" />

        Invitar usuario
      </button>

    </div>
  );
}