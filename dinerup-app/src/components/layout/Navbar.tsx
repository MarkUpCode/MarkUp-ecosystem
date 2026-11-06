import { Bell, LogOut, ShieldCheck } from "lucide-react";
import { useAuth } from "../../context/useAuth";
import { useNavigate } from "react-router-dom";
import logo from "../../images/LogoDinerop.png";

export default function Navbar() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate("/");
  };

  if (!user) return null;

  return (
    <nav className="sticky top-0 z-30 border-b border-slate-200/80 bg-white/90 shadow-[0_8px_30px_rgba(15,23,42,0.06)] backdrop-blur-xl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <div className="flex items-center space-x-3">
            <div className="inline-flex h-12 w-12 items-center justify-center overflow-hidden rounded-2xl bg-slate-950 shadow-lg">
              <img
                src={logo}
                alt="DinerUp Logo"
                className="h-10 w-10 object-contain"
              />
            </div>
            <div>
              <h1 className="text-lg font-extrabold tracking-tight text-slate-950">Dinerop</h1>
              <p className="text-xs font-medium text-slate-500">Tu portal financiero</p>
            </div>
          </div>

          <div className="flex items-center gap-2 sm:gap-4">
            <div className="hidden items-center gap-2 rounded-full bg-emerald-50 px-3 py-2 text-xs font-semibold text-emerald-700 sm:flex">
              <ShieldCheck className="h-4 w-4" />
              Entorno seguro
            </div>
            <button className="grid h-10 w-10 place-items-center rounded-xl text-slate-500 transition hover:bg-slate-100 hover:text-slate-900" aria-label="Notificaciones">
              <Bell className="h-5 w-5" />
            </button>
            <button
              onClick={handleLogout}
              className="flex items-center space-x-2 rounded-xl px-3 py-2 text-slate-600 transition-colors hover:bg-slate-100 hover:text-slate-950 sm:px-4"
            >
              <LogOut className="w-5 h-5" />
              <span className="font-medium">Salir</span>
            </button>
          </div>
        </div>
      </div>
    </nav>
  );
}
