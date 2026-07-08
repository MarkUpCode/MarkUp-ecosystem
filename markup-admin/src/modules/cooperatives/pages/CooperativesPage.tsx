import { useState } from "react";

import { useCooperatives } from "../hooks/useCooperatives";

import { CooperativesHeader } from "../components/CooperativesHeader";

import { CooperativesStats } from "../components/CooperativesStats";

import { CooperativesFilters } from "../components/CooperativesFilters";

import { CooperativesTable } from "../components/CooperativesTable";

import { Pagination } from "@/components/ui/Pagination";

export function CooperativesPage() {

  const [createOpen, setCreateOpen] = useState(false);

 const {

    cooperatives,

    loading,

    page,

    size,

    totalPages,

    totalElements,

    setPage,

    search,

    city,

    province,

    setSearch,

    setCity,

    setProvince,

    reload,

} = useCooperatives();

  return (

    <div className="space-y-6">

      <CooperativesHeader

        onCreate={() => setCreateOpen(true)}

      />

      <CooperativesStats

        total={cooperatives.length}

        averageRating={
            cooperatives.length
                ? cooperatives.reduce(
                      (acc, c) => acc + c.calificacion,
                      0
                  ) / cooperatives.length
                : 0
        }

        highestCredit={
            cooperatives.length
                ? Math.max(
                      ...cooperatives.map(
                          c => c.montoMaximoCredito
                      )
                  )
                : 0
        }

        cities={
            new Set(
                cooperatives.map(
                    c => c.ciudad
                )
            ).size
        }

    />

    <CooperativesFilters

        search={search}

        city={city}

        province={province}

        onSearchChange={setSearch}

        onCityChange={setCity}

        onProvinceChange={setProvince}

        onReload={reload}

    />

      {loading ? (

        <div className="rounded-3xl border border-white/10 bg-slate-900 p-20 text-center">

          Cargando cooperativas...

        </div>

      ) : (

        <CooperativesTable

            cooperatives={cooperatives}

        />
        

      )}
      <Pagination

          page={page}

          size={size}

          totalPages={totalPages}

          totalElements={totalElements}

          onPageChange={setPage}

      />

    </div>

  );

}