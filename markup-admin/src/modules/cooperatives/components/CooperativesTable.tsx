import type { CooperativeListItem } from "../types/cooperative";

import {
    Eye,
    Pencil,
    Trash2,
    Building2,
    Star,
} from "lucide-react";

interface CooperativesTableProps {

    cooperatives: CooperativeListItem[];

    onView?: (cooperative: CooperativeListItem) => void;

    onEdit?: (cooperative: CooperativeListItem) => void;

    onDelete?: (cooperative: CooperativeListItem) => void;

}

export function CooperativesTable({

    cooperatives,

    onView,

    onEdit,

    onDelete,

}: CooperativesTableProps) {

    return (

        <div className="overflow-hidden rounded-3xl border border-white/10 bg-slate-900">

            <table className="w-full">

                <thead className="border-b border-white/10 bg-slate-950">

                    <tr>

                        <th className="px-6 py-4 text-left text-xs uppercase tracking-wider text-slate-400">

                            Cooperativa

                        </th>

                        <th className="px-6 py-4 text-left text-xs uppercase tracking-wider text-slate-400">

                            Ciudad

                        </th>

                        <th className="px-6 py-4 text-left text-xs uppercase tracking-wider text-slate-400">

                            Provincia

                        </th>

                        <th className="px-6 py-4 text-center text-xs uppercase tracking-wider text-slate-400">

                            Calificación

                        </th>

                        <th className="px-6 py-4 text-right text-xs uppercase tracking-wider text-slate-400">

                            Crédito Máx.

                        </th>

                        <th className="px-6 py-4 text-center text-xs uppercase tracking-wider text-slate-400">

                            Acciones

                        </th>

                    </tr>

                </thead>

                <tbody>

                    {cooperatives.map((cooperative) => (

                        <tr

                            key={cooperative.id}

                            className="border-b border-white/5 hover:bg-white/5 transition"

                        >

                            <td className="px-6 py-5">

                                <div className="flex items-center gap-3">

                                    <div className="rounded-2xl bg-cyan-500/10 p-3">

                                        <Building2 className="h-6 w-6 text-cyan-400"/>

                                    </div>

                                    <div>

                                        <p className="font-semibold text-white">

                                            {cooperative.nombre}

                                        </p>

                                        <p className="text-sm text-slate-400">

                                            {cooperative.telefono}

                                        </p>

                                    </div>

                                </div>

                            </td>

                            <td className="px-6 py-5 text-slate-300">

                                {cooperative.ciudad}

                            </td>

                            <td className="px-6 py-5 text-slate-300">

                                {cooperative.provincia}

                            </td>

                            <td className="px-6 py-5">

                                <div className="flex items-center justify-center gap-1 text-yellow-400">

                                    <Star className="h-4 w-4 fill-current"/>

                                    {cooperative.calificacion.toFixed(1)}

                                </div>

                            </td>

                            <td className="px-6 py-5 text-right font-semibold text-cyan-400">

                                $

                                {cooperative.montoMaximoCredito.toLocaleString()}

                            </td>

                            <td className="px-6 py-5">

                                <div className="flex justify-center gap-2">

                                    <button

                                        onClick={() => onView?.(cooperative)}

                                        className="rounded-xl bg-cyan-500/10 p-2 text-cyan-400 transition hover:bg-cyan-500 hover:text-slate-950"

                                    >

                                        <Eye size={18}/>

                                    </button>

                                    <button

                                        onClick={() => onEdit?.(cooperative)}

                                        className="rounded-xl bg-amber-500/10 p-2 text-amber-400 transition hover:bg-amber-500 hover:text-slate-950"

                                    >

                                        <Pencil size={18}/>

                                    </button>

                                    <button

                                        onClick={() => onDelete?.(cooperative)}

                                        className="rounded-xl bg-red-500/10 p-2 text-red-400 transition hover:bg-red-500 hover:text-white"

                                    >

                                        <Trash2 size={18}/>

                                    </button>

                                </div>

                            </td>

                        </tr>

                    ))}

                </tbody>

            </table>

        </div>

    );

}