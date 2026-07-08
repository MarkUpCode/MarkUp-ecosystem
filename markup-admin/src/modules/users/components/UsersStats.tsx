import {
  Users,
  CheckCircle2,
  Clock3,
  Ban,
} from "lucide-react";

interface UsersStatsProps {
  total: number;
  active: number;
  pending: number;
  disabled: number;
}

export function UsersStats({
  total,
  active,
  pending,
  disabled,
}: UsersStatsProps) {
  const cards = [
    {
      title: "Total usuarios",
      value: total,
      icon: Users,
      color: "text-cyan-400",
      bg: "bg-cyan-500/10",
    },
    {
      title: "Activos",
      value: active,
      icon: CheckCircle2,
      color: "text-emerald-400",
      bg: "bg-emerald-500/10",
    },
    {
      title: "Pendientes",
      value: pending,
      icon: Clock3,
      color: "text-yellow-400",
      bg: "bg-yellow-500/10",
    },
    {
      title: "Deshabilitados",
      value: disabled,
      icon: Ban,
      color: "text-red-400",
      bg: "bg-red-500/10",
    },
  ];

  return (
    <div className="mb-8 grid gap-4 md:grid-cols-2 xl:grid-cols-4">
      {cards.map((card) => {
        const Icon = card.icon;

        return (
          <div
            key={card.title}
            className="rounded-3xl border border-white/10 bg-slate-900 p-6 transition hover:border-cyan-500/30 hover:bg-slate-900/80"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-slate-400">
                  {card.title}
                </p>

                <h2 className="mt-2 text-3xl font-bold text-white">
                  {card.value}
                </h2>
              </div>

              <div
                className={`rounded-2xl p-3 ${card.bg}`}
              >
                <Icon
                  className={`h-6 w-6 ${card.color}`}
                />
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}