import React from "react";
import { Sparkles } from "lucide-react";
import headerImage from "../../images/header.jpg";

const Hero: React.FC = () => {

  return (
    <section
      id="hero"
      className="relative min-h-screen flex items-center overflow-hidden bg-gradient-to-br from-slate-900 via-blue-900 to-blue-700"
    >
      {/* Imagen decorativa */}
      <div className="absolute right-0 top-0 w-1/2 h-full opacity-10 pointer-events-none">
        <div className="absolute inset-0 bg-gradient-to-l from-transparent to-slate-900 z-10" />
        <img
          src={headerImage}
          alt="Fondo financiero"
          className="w-full h-full object-cover"
        />
      </div>

      {/* Contenido principal */}
      <div className="relative z-10 w-full max-w-7xl mx-auto px-6 py-20 flex items-center justify-center">
        <div className="space-y-8 max-w-3xl">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-white/10 border border-white/20 rounded-full mb-6 animate-fade-in">
            <Sparkles className="w-4 h-4 text-yellow-400" />
            <span className="text-sm text-white font-medium">
              Plataforma líder en créditos e inversión
            </span>
          </div>

          <h1 className="text-5xl lg:text-7xl font-bold text-white mb-6 bg-clip-text text-transparent bg-gradient-to-r from-white to-blue-200">
            Bienvenido(a) a MARK UP ECUADOR
          </h1>

          <p className="text-xl text-gray-300 leading-relaxed">
            Pioneros en la gestión de negocios con propósito: impulsamos el
            progreso de los pueblos mediante soluciones tecnológicas y
            financieras que ayudan a cumplir sueños, fortalecidos por el sistema
            financiero nacional.
          </p>
        </div>
      </div>
    </section>
  );
};

export default Hero;
