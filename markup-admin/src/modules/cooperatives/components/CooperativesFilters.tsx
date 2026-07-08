import { Search, RotateCw, MapPin } from "lucide-react";

interface CooperativesFiltersProps {

  search: string;

  city: string;

  province: string;

  onSearchChange: (value: string) => void;

  onCityChange: (value: string) => void;

  onProvinceChange: (value: string) => void;

  onReload: () => void;

}

export function CooperativesFilters({

  search,

  city,

  province,

  onSearchChange,

  onCityChange,

  onProvinceChange,

  onReload,

}: CooperativesFiltersProps) {

  return (

    <div className="rounded-3xl border border-white/10 bg-slate-900 p-5">

      <div className="grid gap-4 lg:grid-cols-4">

        <div className="relative lg:col-span-2">

          <Search
            className="
              absolute
              left-4
              top-1/2
              h-5
              w-5
              -translate-y-1/2
              text-slate-500
            "
          />

          <input
            value={search}
            onChange={(e) =>
              onSearchChange(e.target.value)
            }
            placeholder="Buscar cooperativa..."
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
              outline-none
              transition
              focus:border-cyan-500
            "
          />

        </div>

        <input
          value={city}
          onChange={(e) =>
            onCityChange(e.target.value)
          }
          placeholder="Ciudad"
          className="
            rounded-2xl
            border
            border-white/10
            bg-slate-950
            px-4
            py-3
            text-white
            outline-none
            transition
            focus:border-cyan-500
          "
        />

        <div className="flex gap-3">

          <input
            value={province}
            onChange={(e) =>
              onProvinceChange(e.target.value)
            }
            placeholder="Provincia"
            className="
              flex-1
              rounded-2xl
              border
              border-white/10
              bg-slate-950
              px-4
              py-3
              text-white
              outline-none
              transition
              focus:border-cyan-500
            "
          />

          <button
            onClick={onReload}
            className="
              rounded-2xl
              border
              border-white/10
              bg-slate-950
              px-4
              transition
              hover:bg-slate-800
            "
          >

            <RotateCw
              className="h-5 w-5 text-cyan-400"
            />

          </button>

        </div>

      </div>

    </div>

  );

}