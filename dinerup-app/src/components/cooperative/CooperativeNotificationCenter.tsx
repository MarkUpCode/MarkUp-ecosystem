import { useEffect, useRef, useState } from "react";
import { Bell, CheckCheck, Circle, X } from "lucide-react";
import type { CooperativeNotification } from "../../hooks/useCooperativeLiveUpdates";

type Props = {
  notifications: CooperativeNotification[];
  unreadCount: number;
  onMarkRead: (id: string) => void;
  onMarkAllRead: () => void;
  onOpenNotification: (notification: CooperativeNotification) => void;
};

export default function CooperativeNotificationCenter({
  notifications,
  unreadCount,
  onMarkRead,
  onMarkAllRead,
  onOpenNotification,
}: Props) {
  const [open, setOpen] = useState(false);
  const panelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;

    const closeOnOutsideClick = (event: PointerEvent) => {
      if (event.target instanceof Node && !panelRef.current?.contains(event.target)) setOpen(false);
    };
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") setOpen(false);
    };

    document.addEventListener("pointerdown", closeOnOutsideClick);
    document.addEventListener("keydown", closeOnEscape);
    return () => {
      document.removeEventListener("pointerdown", closeOnOutsideClick);
      document.removeEventListener("keydown", closeOnEscape);
    };
  }, [open]);

  return (
    <div className="relative" ref={panelRef}>
      <button
        type="button"
        onClick={() => setOpen((value) => !value)}
        className="relative grid h-10 w-10 place-items-center rounded-xl border border-slate-200 text-slate-600 transition hover:bg-slate-50"
        aria-label={`Notificaciones${unreadCount ? `, ${unreadCount} sin leer` : ""}`}
        aria-expanded={open}
        aria-haspopup="dialog"
      >
        <Bell className="h-[18px] w-[18px]" />
        {unreadCount > 0 && <span className="absolute -right-1 -top-1 grid min-h-5 min-w-5 place-items-center rounded-full bg-rose-600 px-1 text-[10px] font-extrabold text-white">{unreadCount > 9 ? "9+" : unreadCount}</span>}
      </button>

      {open && <section role="dialog" aria-label="Notificaciones" className="absolute right-0 top-14 z-[70] flex max-h-[min(70vh,34rem)] w-[min(92vw,390px)] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xl">
        <header className="flex items-center justify-between border-b border-slate-100 px-4 py-4">
          <div><h2 className="font-extrabold text-[#173b57]">Notificaciones</h2><p className="text-xs text-slate-500">Actividad de tus solicitudes</p></div>
          <div className="flex items-center gap-1">
            {unreadCount > 0 && <button type="button" onClick={onMarkAllRead} className="rounded-lg p-2 text-slate-500 hover:bg-slate-100" aria-label="Marcar todas como leídas" title="Marcar todas como leídas"><CheckCheck className="h-4 w-4" /></button>}
            <button type="button" onClick={() => setOpen(false)} className="rounded-lg p-2 text-slate-500 hover:bg-slate-100" aria-label="Cerrar notificaciones"><X className="h-4 w-4" /></button>
          </div>
        </header>
        <div className="overflow-y-auto">
          {notifications.length === 0 ? <div className="px-6 py-12 text-center"><Bell className="mx-auto h-8 w-8 text-slate-300" /><p className="mt-3 text-sm font-semibold text-slate-600">Aún no hay notificaciones</p><p className="mt-1 text-xs text-slate-400">Aquí aparecerán las nuevas solicitudes y sus cambios.</p></div> : notifications.map((notification) => <button
            type="button"
            key={notification.id}
            onClick={() => { onMarkRead(notification.id); onOpenNotification(notification); setOpen(false); }}
            className={`flex w-full gap-3 border-b border-slate-100 px-4 py-4 text-left transition hover:bg-slate-50 ${notification.read ? "bg-white" : "bg-sky-50/70"}`}
          >
            <span className={`mt-1 grid h-9 w-9 shrink-0 place-items-center rounded-full ${notification.read ? "bg-slate-100 text-slate-500" : "bg-sky-100 text-sky-700"}`}><Bell className="h-4 w-4" /></span>
            <span className="min-w-0 flex-1"><span className="flex items-center justify-between gap-2"><span className="text-sm font-bold text-slate-800">{notification.title}</span>{!notification.read && <Circle className="h-2 w-2 shrink-0 fill-sky-600 text-sky-600" />}</span><span className="mt-1 block text-xs leading-5 text-slate-600">{notification.message}</span><span className="mt-1 block text-[10px] text-slate-400">{new Date(notification.createdAt).toLocaleString("es-EC")} · Solicitud #{notification.requestId}</span></span>
          </button>)}
        </div>
      </section>}
    </div>
  );
}
