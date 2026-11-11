import { Bell, LogOut, ShieldCheck, UserRound } from "lucide-react";
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
    <nav className="sticky top-0 z-30 border-b border-white/10 bg-[#0b1d42] shadow-[0_8px_30px_rgba(11,29,66,0.2)]">
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
              <h1 className="text-lg font-extrabold tracking-tight text-white">Dinerop</h1>
              <p className="text-xs font-medium text-blue-100">Tu portal financiero</p>
            </div>
          </div>

          <div className="flex items-center gap-2 sm:gap-3">
            <div className="hidden items-center gap-2 rounded-full bg-emerald-50 px-3 py-2 text-xs font-semibold text-emerald-700 sm:flex">
              <ShieldCheck className="h-4 w-4" />
              Entorno seguro
            </div>
            <button className="grid h-10 w-10 place-items-center rounded-xl text-blue-100 transition hover:bg-white/10 hover:text-white" aria-label="Notificaciones">
              <Bell className="h-5 w-5" />
            </button>
            <div className="hidden items-center gap-2 rounded-2xl border border-white/10 bg-white/10 px-2 py-1.5 sm:flex">
              <div className="grid h-8 w-8 place-items-center rounded-xl bg-white/15 text-white">
                <UserRound className="h-4 w-4" />
              </div>
              <span className="max-w-28 truncate pr-2 text-sm font-semibold text-white">{user.name}</span>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center space-x-2 rounded-xl px-3 py-2 text-blue-100 transition-colors hover:bg-white/10 hover:text-white sm:px-4"
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
