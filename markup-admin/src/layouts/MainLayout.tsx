import { useMemo, useState } from "react";
import { Outlet, NavLink, useLocation, useNavigate } from "react-router-dom";
import {
  BarChart3,
  Bell,
  Building2,
  ChevronRight,
  CircleDollarSign,
  ClipboardList,
  LayoutDashboard,
  LogOut,
  Menu,
  Package,
  Settings,
  ShieldCheck,
  SunMoon,
  Users,
  UserCircle,
  Waves,
  ChartNoAxesCombined,
} from "lucide-react";
import { useAuth } from "@/contexts/useAuth";
import { useTheme } from "@/hooks/useTheme";

const menuItems = [
  { to: "/dashboard", label: "Dashboard", icon: LayoutDashboard },
  { to: "/cooperativas", label: "Cooperativas", icon: Building2 },
  { to: "/usuarios", label: "Usuarios", icon: Users },
  { to: "/solicitudes", label: "Solicitudes", icon: ClipboardList },
  { to: "/leads", label: "Leads", icon: Waves },
  { to: "/productos", label: "Productos", icon: Package },
  { to: "/reportes", label: "Reportes", icon: CircleDollarSign },
  { to: "/estadisticas", label: "Estadísticas", icon: ChartNoAxesCombined },
  { to: "/configuracion", label: "Configuración", icon: Settings },
  { to: "/perfil", label: "Perfil", icon: UserCircle },
];

export function MainLayout() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const { theme, toggleTheme } = useTheme();

  const breadcrumbs = useMemo(() => {
    const segments = location.pathname.split("/").filter(Boolean);
    const labels = ["Inicio", ...segments.map((segment) => segment.replace(/-/g, " "))];
    return labels;
  }, [location.pathname]);

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 lg:grid lg:grid-cols-[280px_1fr]">
      <aside className={`${sidebarOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0"} fixed inset-y-0 left-0 z-40 w-72 border-r border-white/10 bg-slate-950/95 backdrop-blur-xl transition-transform lg:static lg:w-auto`}>
        <div className="flex h-full flex-col">
          <div className="flex items-center gap-3 border-b border-white/10 px-6 py-5">
            <div className="grid h-11 w-11 place-items-center rounded-2xl bg-cyan-500/15 text-cyan-300">
              <ShieldCheck className="h-5 w-5" />
            </div>
            <div>
              <p className="text-sm font-semibold uppercase tracking-[0.2em] text-cyan-300">Markup</p>
              <h1 className="text-lg font-bold">Admin CRM</h1>
            </div>
          </div>

          <nav className="flex-1 space-y-1 px-3 py-5">
            {menuItems.map((item) => {
              const Icon = item.icon;
              const active = location.pathname === item.to;
              return (
                <NavLink
                  key={item.to}
                  to={item.to}
                  className={`flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-medium transition ${active ? "bg-cyan-500 text-slate-950" : "text-slate-300 hover:bg-white/5 hover:text-white"}`}
                  onClick={() => setSidebarOpen(false)}
                >
                  <Icon className="h-4 w-4" />
                  {item.label}
                </NavLink>
              );
            })}
          </nav>

          <div className="border-t border-white/10 p-4">
            <button
              onClick={handleLogout}
              className="flex w-full items-center gap-3 rounded-2xl bg-white/5 px-4 py-3 text-sm font-medium text-white transition hover:bg-white/10"
            >
              <LogOut className="h-4 w-4" />
              Cerrar sesión
            </button>
          </div>
        </div>
      </aside>

      {sidebarOpen && (
        <button
          aria-label="Cerrar menú"
          className="fixed inset-0 z-30 bg-black/50 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      <div className="flex min-h-screen flex-col">
        <header className="sticky top-0 z-20 border-b border-white/10 bg-slate-950/85 backdrop-blur-xl">
          <div className="flex items-center justify-between gap-4 px-4 py-4 lg:px-8">
            <div className="flex items-center gap-3">
              <button
                className="grid h-11 w-11 place-items-center rounded-2xl border border-white/10 bg-white/5 lg:hidden"
                onClick={() => setSidebarOpen(true)}
              >
                <Menu className="h-5 w-5" />
              </button>
              <div>
                <div className="flex items-center gap-2 text-xs text-slate-400">
                  {breadcrumbs.map((item, index) => (
                    <span key={`${item}-${index}`} className="flex items-center gap-2">
                      {index > 0 && <ChevronRight className="h-3 w-3" />}
                      {item}
                    </span>
                  ))}
                </div>
                <h2 className="text-xl font-semibold">{breadcrumbs.at(-1)}</h2>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <button
                onClick={toggleTheme}
                className="grid h-11 w-11 place-items-center rounded-2xl border border-white/10 bg-white/5"
              >
                <SunMoon className="h-5 w-5" />
              </button>
              <button className="grid h-11 w-11 place-items-center rounded-2xl border border-white/10 bg-white/5">
                <Bell className="h-5 w-5" />
              </button>
              <div className="flex items-center gap-3 rounded-2xl border border-white/10 bg-white/5 px-3 py-2">
                <div className="grid h-9 w-9 place-items-center rounded-full bg-cyan-500/15 text-cyan-300">
                  {(user?.name ?? user?.email ?? "A").slice(0, 1).toUpperCase()}
                </div>
                <div className="hidden md:block">
                  <p className="text-sm font-medium">{user?.name ?? "Administrador"}</p>
                  <p className="text-xs text-slate-400">{user?.email}</p>
                </div>
              </div>
            </div>
          </div>
        </header>

        <main className="flex-1 px-4 py-6 lg:px-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
