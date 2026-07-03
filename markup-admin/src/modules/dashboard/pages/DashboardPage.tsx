import { Card } from "@/components/ui/card";
import { BarChart3, Building2, CircleDollarSign, Users, BadgeCheck, Banknote, TrendingUp, TrendingDown } from "lucide-react";

const metrics = [
  { label: "Total Cooperativas", value: "128", icon: Building2 },
  { label: "Cooperativas activas", value: "114", icon: BadgeCheck },
  { label: "Usuarios", value: "8,240", icon: Users },
  { label: "Solicitudes", value: "1,287", icon: BarChart3 },
  { label: "Créditos aprobados", value: "642", icon: TrendingUp },
  { label: "Créditos desembolsados", value: "511", icon: TrendingDown },
  { label: "Monto solicitado", value: "$12.4M", icon: CircleDollarSign },
  { label: "Monto desembolsado", value: "$8.7M", icon: Banknote },
];

export function DashboardPage() {
  return (
    <div className="space-y-6">
      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        {metrics.map((item) => {
          const Icon = item.icon;
          return (
            <Card key={item.label} className="border-white/10 bg-white/5">
              <div className="flex items-start justify-between gap-4">
                <div>
                  <p className="text-sm text-slate-400">{item.label}</p>
                  <h3 className="mt-2 text-3xl font-semibold text-white">{item.value}</h3>
                </div>
                <div className="grid h-12 w-12 place-items-center rounded-2xl bg-cyan-400/15 text-cyan-300">
                  <Icon className="h-5 w-5" />
                </div>
              </div>
            </Card>
          );
        })}
      </div>

      <div className="grid gap-6 xl:grid-cols-[1.6fr_1fr]">
        <Card className="border-white/10 bg-white/5">
          <h2 className="text-lg font-semibold">Gráficos y actividad</h2>
          <div className="mt-6 grid min-h-[280px] place-items-center rounded-3xl border border-dashed border-white/10 bg-black/20 text-slate-400">
            Próximamente: gráficos de conversión, comisiones y tendencias.
          </div>
        </Card>
        <Card className="border-white/10 bg-white/5">
          <h2 className="text-lg font-semibold">Actividad reciente</h2>
          <div className="mt-6 space-y-4 text-sm text-slate-300">
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">Nueva cooperativa creada</div>
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">Usuario ADMIN asignado</div>
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">Solicitud preaprobada</div>
          </div>
        </Card>
      </div>
    </div>
  );
}
