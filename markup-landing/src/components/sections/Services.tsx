import React from 'react';
import { Users, Target, Zap, Shield, TrendingUp, Sparkles } from 'lucide-react';
import MapWithMarkers from './Map'; // 👈 Ya no necesitas pasar props

const Services: React.FC = () => {
  const services = [
    {
      icon: Users,
      title: "Diversas Cooperativas Financieras",
      description: "Accede a más de 25 cooperativas confiables que ofrecen créditos e inversiones seguras en un solo lugar.",
      color: "from-blue-500 to-indigo-600",
      bgGlow: "bg-blue-500/10"
    },
    {
      icon: Target,
      title: "Créditos Personalizados",
      description: "Recibe propuestas de crédito ajustadas a tu capacidad de pago, historial y metas financieras.",
      color: "from-emerald-500 to-teal-600",
      bgGlow: "bg-emerald-500/10"
    },
    {
      icon: Zap,
      title: "Inversiones Ágiles y Rentables",
      description: "Invierte de manera digital en cooperativas certificadas, con procesos simples y retornos confiables.",
      color: "from-amber-500 to-orange-600",
      bgGlow: "bg-amber-500/10"
    }
  ];

  return (
    <section id="services" className="py-24 bg-gradient-to-b from-gray-50 via-white to-gray-50 relative overflow-hidden">
      {/* Elementos decorativos de fondo */}
      <div className="absolute top-0 left-0 w-96 h-96 bg-blue-200/30 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2"></div>
      <div className="absolute bottom-0 right-0 w-96 h-96 bg-purple-200/30 rounded-full blur-3xl translate-x-1/2 translate-y-1/2"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Header Section */}
        <div className="text-center mb-6">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-blue-500/10 to-purple-500/10 backdrop-blur-sm border border-blue-200 rounded-full mb-4">
            <Sparkles className="w-4 h-4 text-blue-600" />
            <span className="text-sm font-semibold text-blue-600">Lo que ofrecemos</span>
          </div>
          <h2 className="text-xl lg:text-4xl font-bold text-gray-900 mb-4">
            Sobre <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">Nosotros</span>
          </h2>
          <p className="text-1xl text-gray-600 max-w-1xl mx-auto">
            Conoce la red de cooperativas financieras que respaldan nuestros servicios de créditos e inversiones.
          </p>
        </div>

        {/* Grid de 2 columnas */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-start">
          {/* Servicios */}
          <div className="space-y-6">
            <div className="flex items-center gap-3 mb-6">
              <div className="h-1 w-10 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-full"></div>
              <h3 className="text-2xl font-bold text-gray-900">
                Nuestros Servicios
              </h3>
            </div>

            <div className="space-y-5 max-h-[800px] overflow-y-auto pr-2 custom-scrollbar">
              {services.map((service, index) => {
                const IconComponent = service.icon;
                return (
                  <div
                    key={index}
                    className="group relative bg-white rounded-2xl p-6 shadow-lg hover:shadow-2xl transform hover:-translate-y-1 transition-all duration-300 border border-gray-100 overflow-hidden"
                  >
                    <div className={`absolute inset-0 ${service.bgGlow} opacity-0 group-hover:opacity-100 transition-opacity duration-300`}></div>
                    <div className={`absolute top-0 left-0 w-1 h-full bg-gradient-to-b ${service.color} transform scale-y-0 group-hover:scale-y-100 transition-transform duration-300 origin-top`}></div>

                    <div className="relative z-10 flex gap-4">
                      <div className={`flex-shrink-0 w-14 h-14 rounded-xl bg-gradient-to-br ${service.color} flex items-center justify-center shadow-lg group-hover:scale-110 group-hover:rotate-3 transition-all duration-300`}>
                        <IconComponent className="h-7 w-7 text-white" />
                      </div>

                      <div className="flex-1">
                        <h3 className="text-lg font-bold text-gray-900 mb-2 group-hover:text-blue-600 transition-colors">
                          {service.title}
                        </h3>
                        <p className="text-gray-600 text-sm leading-relaxed mb-3">
                          {service.description}
                        </p>
                      </div>
                    </div>

                    <div className="absolute bottom-0 right-0 w-20 h-20 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                      <div className={`absolute bottom-0 right-0 w-full h-full bg-gradient-to-tl ${service.color} opacity-10 rounded-tl-full`}></div>
                    </div>
                  </div>
                );
              })}
            </div>

            {/* Stats */}
            <div className="grid grid-cols-3 gap-4 mt-8 p-6 bg-gradient-to-br from-blue-50 to-indigo-50 rounded-2xl border border-blue-100">
              {[
                { icon: Users, value: "25+", label: "Cooperativas" },
                { icon: Shield, value: "100%", label: "Seguro" },
                { icon: TrendingUp, value: "98%", label: "Aprobación" }
              ].map((stat, i) => {
                const StatIcon = stat.icon;
                return (
                  <div key={i} className="text-center">
                    <div className="inline-flex items-center justify-center w-10 h-10 rounded-lg bg-white shadow-md mb-2">
                      <StatIcon className="w-5 h-5 text-blue-600" />
                    </div>
                    <div className="text-2xl font-bold text-gray-900">{stat.value}</div>
                    <div className="text-xs text-gray-600">{stat.label}</div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Mapa con filtros integrados */}
          <div className="relative">
            <div className="flex items-center gap-3 mb-6">
              <div className="h-1 w-12 bg-gradient-to-r from-emerald-600 to-teal-600 rounded-full"></div>
              <h3 className="text-2xl font-bold text-gray-900">
                Nuestros Aliados
              </h3>
            </div>
            {/* Importar mapa */}
            <MapWithMarkers />
          </div>
        </div>
      </div>

      <style>{`
        .custom-scrollbar::-webkit-scrollbar {
          width: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
          background: #f1f5f9;
          border-radius: 10px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
          background: linear-gradient(to bottom, #3b82f6, #6366f1);
          border-radius: 10px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
          background: linear-gradient(to bottom, #2563eb, #4f46e5);
        }
      `}</style>
    </section>
  );
};

export default Services;