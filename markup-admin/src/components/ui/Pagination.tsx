import {
  ChevronLeft,
  ChevronRight,
} from "lucide-react";

interface PaginationProps {

  page: number;

  size: number;

  totalPages: number;

  totalElements: number;

  onPageChange: (page: number) => void;

}

export function Pagination({

  page,

  size,

  totalPages,

  totalElements,

  onPageChange,

}: PaginationProps) {

  if (totalPages <= 1) return null;

  const start = page * size + 1;

  const end = Math.min(
    (page + 1) * size,
    totalElements
  );

  return (

    <div className="mt-6 flex items-center justify-between rounded-3xl border border-white/10 bg-slate-900 px-6 py-4">

      <p className="text-sm text-slate-400">

        Mostrando

        <span className="mx-1 font-semibold text-white">

          {start}-{end}

        </span>

        de

        <span className="ml-1 font-semibold text-white">

          {totalElements}

        </span>

        usuarios

      </p>

      <div className="flex items-center gap-2">

        <button

          disabled={page === 0}

          onClick={() => onPageChange(page - 1)}

          className="rounded-xl border border-white/10 p-2 transition hover:bg-white/10 disabled:cursor-not-allowed disabled:opacity-40"

        >

          <ChevronLeft className="h-4 w-4"/>

        </button>

        {Array.from({ length: totalPages }).map((_, index) => (

          <button

            key={index}

            onClick={() => onPageChange(index)}

            className={`
              h-10
              w-10
              rounded-xl
              text-sm
              font-semibold
              transition

              ${
                page === index
                  ? "bg-cyan-500 text-slate-950"
                  : "border border-white/10 hover:bg-white/10"
              }
            `}

          >

            {index + 1}

          </button>

        ))}

        <button

          disabled={page + 1 >= totalPages}

          onClick={() => onPageChange(page + 1)}

          className="rounded-xl border border-white/10 p-2 transition hover:bg-white/10 disabled:cursor-not-allowed disabled:opacity-40"

        >

          <ChevronRight className="h-4 w-4"/>

        </button>

      </div>

    </div>

  );

}