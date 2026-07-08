import { Building2, Plus } from "lucide-react";

interface CooperativesHeaderProps {

  onCreate: () => void;

}

export function CooperativesHeader({

  onCreate,

}: CooperativesHeaderProps) {

  return (

    <div className="flex items-center justify-between">

      <div>

        <h1 className="flex items-center gap-3 text-3xl font-bold text-white">

          <Building2 className="h-8 w-8 text-cyan-400" />

          Cooperativas

        </h1>

        <p className="mt-2 text-slate-400">

          Administra las cooperativas registradas en Dinerop.

        </p>

      </div>

      <button
        onClick={onCreate}
        className="
          flex
          items-center
          gap-2
          rounded-2xl
          bg-cyan-500
          px-5
          py-3
          font-semibold
          text-slate-950
          transition
          hover:bg-cyan-400
        "
      >

        <Plus className="h-5 w-5" />

        Nueva cooperativa

      </button>

    </div>

  );

}