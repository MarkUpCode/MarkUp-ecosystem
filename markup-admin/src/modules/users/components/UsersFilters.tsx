import { Search, RotateCcw } from "lucide-react";

interface UsersFiltersProps {

  search: string;

  role: string;

  status: string;

  onSearchChange: (value: string) => void;

  onRoleChange: (value: string) => void;

  onStatusChange: (value: string) => void;

  onReload: () => void;

}

export function UsersFilters({

  search,

  role,

  status,

  onSearchChange,

  onRoleChange,

  onStatusChange,

  onReload,

}: UsersFiltersProps) {

  return (

    <div className="mb-6 rounded-3xl border border-white/10 bg-slate-900 p-5">

      <div className="grid gap-4 lg:grid-cols-[1fr_180px_200px_auto]">

        {/* BUSCADOR */}

        <div className="relative">

          <Search className="absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-500" />

          <input
            value={search}
            onChange={(e) => onSearchChange(e.target.value)}
            placeholder="Buscar por correo..."
            className="
              w-full
              rounded-2xl
              border
              border-white/10
              bg-slate-950
              py-3
              pl-12
              pr-4
              text-white
              placeholder:text-slate-500
              outline-none
              transition
              focus:border-cyan-500
            "
          />

        </div>

        {/* ROL */}

        <select
          value={role}
          onChange={(e)=>onRoleChange(e.target.value)}
          className="rounded-2xl border border-white/10 bg-slate-950 px-4 text-white"
        >

          <option value="">Todos los roles</option>

          <option value="ADMIN">Administrador</option>

          <option value="CLIENT">Cliente</option>

          <option value="COOPERATIVE">Cooperativa</option>

        </select>

        {/* ESTADO */}

        <select
          value={status}
          onChange={(e)=>onStatusChange(e.target.value)}
          className="rounded-2xl border border-white/10 bg-slate-950 px-4 text-white"
        >

          <option value="">Todos los estados</option>

          <option value="ACTIVE">Activo</option>

          <option value="PENDING_ACTIVATION">Pendiente</option>

          <option value="DISABLED">Deshabilitado</option>

        </select>

        {/* BOTON */}

        <button
          onClick={onReload}
          className="inline-flex items-center justify-center gap-2 rounded-2xl border border-white/10 px-5 text-slate-300 transition hover:bg-white/5"
        >

          <RotateCcw className="h-4 w-4"/>

          Actualizar

        </button>

      </div>

    </div>

  );

}