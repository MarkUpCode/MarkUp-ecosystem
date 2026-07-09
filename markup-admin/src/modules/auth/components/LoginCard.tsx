import { ReactNode } from "react";
import logo from "@/assets/logo-markup.png";

interface LoginCardProps {
  children: ReactNode;
}

export function LoginCard({ children }: LoginCardProps) {
  return (
    <div
      className="
        relative
        w-full
        max-w-[430px]
        overflow-hidden
        rounded-[34px]
        border
        border-white/10
        bg-slate-900/70
        p-10
        shadow-[0_30px_120px_rgba(0,0,0,.55)]
        backdrop-blur-2xl
      "
    >
      {/* Glow detrás del logo */}

      <div className="absolute left-1/2 top-24 h-36 w-36 -translate-x-1/2 rounded-full bg-cyan-500/15 blur-[90px]" />

      {/* Línea superior */}

      <div className="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-cyan-400/40 to-transparent" />

      {/* Contenido */}

      <div className="relative z-28 flex flex-col items-center">

        {/* Avatar */}

        <div
          className="
            relative
            mb-7
            flex
            h-28
            w-28
            items-center
            justify-center
            rounded-full
            border
            border-cyan-500/20
            bg-slate-950
            shadow-[0_0_50px_rgba(6,182,212,.15)]
          "
        >

          {/* Anillo */}

          <div
            className="
              absolute
              inset-2
              rounded-full
              border
              border-white/5
            "
          />

          <img
            src={logo}
            alt="Markup"
            className="h-full w-auto object-contain"
          />

        </div>

        

        <p className="mt-2 mb-10 text-sm text-slate-400">
          Admin Console
        </p>

        <div className="w-full">
          {children}
        </div>

        <p className="mt-10 text-xs tracking-[0.25em] text-slate-500">
          VERSION 1.0
        </p>

      </div>
    </div>
  );
}