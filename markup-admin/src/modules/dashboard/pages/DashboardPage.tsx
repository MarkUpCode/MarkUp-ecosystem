import { useEffect, useState } from "react";
import { Card } from "@/components/ui/card";
import { BarChart3, Building2, Users, Eye, ArrowUpRight, Clock3 } from "lucide-react";
import { getDashboard, type DashboardData } from "../api/dashboard.api";

export function DashboardPage() {
  const [data, setData] = useState<DashboardData | null>(null);
  const [error, setError] = useState("");

  useEffect(() => {
    void getDashboard().then(setData).catch(() => setError("No se pudieron cargar las métricas del panel."));
  }, []);

  const metrics = data ? [
    { label: "Usuarios registrados", value: data.users.total.toLocaleString("es-EC"), icon: Users, tone: "text-cyan-300 bg-cyan-400/15" },
    { label: "Cooperativas", value: data.cooperatives.total.toLocaleString("es-EC"), icon: Building2, tone: "text-violet-300 bg-violet-400/15" },
    { label: "Solicitudes totales", value: data.credits.total.toLocaleString("es-EC"), icon: BarChart3, tone: "text-amber-300 bg-amber-400/15" },
    { label: "Visitas a la plataforma", value: data.visits.total.toLocaleString("es-EC"), icon: Eye, tone: "text-emerald-300 bg-emerald-400/15" },
  ] : [];

  return (
    <div className="space-y-6">
      <div className="relative overflow-hidden rounded-[2rem] bg-gradient-to-br from-cyan-500/20 via-slate-900 to-violet-500/20 p-7">
        <div className="relative z-10">
          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-cyan-300">Vista general</p>
          <h1 className="mt-2 text-3xl font-bold text-white">Buenos días, equipo MarkUp</h1>
          <p className="mt-2 max-w-2xl text-slate-400">Supervisa el ecosistema, detecta oportunidades y mantén el flujo de solicitudes bajo control.</p>
        </div>
        <ArrowUpRight className="absolute -bottom-5 right-7 h-40 w-40 text-white/5" />
      </div>
      {error && <div className="rounded-2xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-200">{error}</div>}
      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        {metrics.map((item) => {
          const Icon = item.icon;
          return (
            <Card key={item.label} className="border-white/10 bg-white/[0.06]">
              <div className="flex items-start justify-between gap-4">
                <div>
                  <p className="text-sm text-slate-400">{item.label}</p>
                  <h3 className="mt-2 text-3xl font-semibold text-white">{item.value}</h3>
                </div>
                <div className={`grid h-12 w-12 place-items-center rounded-2xl ${item.tone}`}>
                  <Icon className="h-5 w-5" />
                </div>
              </div>
            </Card>
          );
        })}
      </div>

      <div className="grid gap-6 xl:grid-cols-[1.6fr_1fr]">
        <Card className="border-white/10 bg-white/5">
          <div className="flex items-center justify-between">
            <div><h2 className="text-lg font-semibold">Ritmo de solicitudes</h2><p className="mt-1 text-sm text-slate-400">Distribución actual por estado</p></div>
            <BarChart3 className="text-cyan-300" />
          </div>
          <div className="mt-8 space-y-5">
            {data ? [
              ["Creadas", data.credits.created, "bg-amber-400"],
              ["Enviadas", data.credits.sent, "bg-cyan-400"],
              ["Total", data.credits.total, "bg-violet-400"],
            ].map(([label, value, color]) => {
              const percentage = data.credits.total ? Math.round((Number(value) / data.credits.total) * 100) : 0;
              return <div key={String(label)}><div className="mb-2 flex justify-between text-sm"><span>{label}</span><span className="font-semibold text-white">{value}</span></div><div className="h-2 rounded-full bg-white/10"><div className={`h-2 rounded-full ${color}`} style={{ width: `${Math.max(percentage, 3)}%` }} /></div></div>;
            }) : <div className="h-32 animate-pulse rounded-2xl bg-white/5" />}
          </div>
        </Card>
        <Card className="border-white/10 bg-white/5">
          <div className="flex items-center justify-between"><div><h2 className="text-lg font-semibold">Actividad reciente</h2><p className="mt-1 text-sm text-slate-400">Últimos movimientos del ecosistema</p></div><Clock3 className="text-cyan-300" /></div>
          <div className="mt-6 space-y-3 text-sm text-slate-300">
            {data?.recentCredits.slice(0, 4).map((credit) => <div key={credit.id} className="rounded-2xl border border-white/10 bg-black/20 p-4"><div className="flex items-center justify-between"><span className="font-medium text-white">{credit.email}</span><span className="text-xs text-cyan-300">{credit.status}</span></div><p className="mt-2 text-slate-400">${Number(credit.amount ?? 0).toLocaleString("es-EC")} · Solicitud #{credit.id}</p></div>)}
            {!data && <div className="h-40 animate-pulse rounded-2xl bg-white/5" />}
            {data?.recentCredits.length === 0 && <p className="rounded-2xl border border-white/10 p-4 text-slate-400">No hay actividad registrada.</p>}
          </div>
        </Card>
      </div>
    </div>
  );
}
