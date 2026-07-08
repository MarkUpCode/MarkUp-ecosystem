import {
  Building2,
  Star,
  Landmark,
  MapPin,
} from "lucide-react";

interface CooperativesStatsProps {

  total: number;

  averageRating: number;

  highestCredit: number;

  cities: number;

}

function Card({

  title,

  value,

  icon,

}:{

  title:string;

  value:string;

  icon:React.ReactNode;

}){

  return(

    <div className="rounded-3xl border border-white/10 bg-slate-900 p-6">

      <div className="flex items-center justify-between">

        <div>

          <p className="text-sm text-slate-400">

            {title}

          </p>

          <h3 className="mt-2 text-3xl font-bold text-white">

            {value}

          </h3>

        </div>

        <div className="rounded-2xl bg-cyan-500/10 p-3 text-cyan-400">

          {icon}

        </div>

      </div>

    </div>

  );

}

export function CooperativesStats({

  total,

  averageRating,

  highestCredit,

  cities,

}:CooperativesStatsProps){

  return(

    <div className="grid gap-5 md:grid-cols-2 xl:grid-cols-4">

      <Card

        title="Cooperativas"

        value={total.toString()}

        icon={<Building2 size={28}/>}

      />

      <Card

        title="Calificación"

        value={averageRating.toFixed(1)}

        icon={<Star size={28}/>}

      />

      <Card

        title="Monto máximo"

        value={`$${highestCredit.toLocaleString()}`}

        icon={<Landmark size={28}/>}

      />

      <Card

        title="Ciudades"

        value={cities.toString()}

        icon={<MapPin size={28}/>}

      />

    </div>

  );

}