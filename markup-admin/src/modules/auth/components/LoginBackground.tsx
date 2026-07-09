export function LoginBackground() {
  return (
    <div className="absolute inset-0 overflow-hidden">

      {/* Base */}

      <div className="absolute inset-0 bg-slate-950" />

      {/* Gradiente principal */}

      <div className="absolute inset-0 bg-[radial-gradient(circle_at_top,rgba(6,182,212,.10),transparent_40%),linear-gradient(to_bottom,#020617,#0f172a)]" />

      {/* Grid */}

      <div
        className="absolute inset-0 opacity-[0.035]"
        style={{
          backgroundImage: `
            linear-gradient(rgba(255,255,255,.08) 1px, transparent 1px),
            linear-gradient(90deg, rgba(255,255,255,.08) 1px, transparent 1px)
          `,
          backgroundSize: "44px 44px",
        }}
      />

      {/* Glow superior */}

      <div className="absolute -top-44 left-1/2 h-[520px] w-[520px] -translate-x-1/2 rounded-full bg-cyan-500/10 blur-[140px]" />

      {/* Glow inferior */}

      <div className="absolute bottom-[-220px] right-[-150px] h-[500px] w-[500px] rounded-full bg-cyan-400/10 blur-[180px]" />

      {/* Glow izquierdo */}

      <div className="absolute left-[-180px] top-1/3 h-[400px] w-[400px] rounded-full bg-cyan-600/10 blur-[170px]" />

      {/* Viñeta */}

      <div className="absolute inset-0 bg-black/20" />

    </div>
  );
}