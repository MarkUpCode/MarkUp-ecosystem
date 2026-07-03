// Archivo no utilizado en esta landing page

  if (!isOpen) return null;

  const headerTitle =
    type === "credito" ? "Solicita tu crédito" : "Realiza una inversión";

  const headerDescription =
    type === "credito"
      ? "Completa tus datos y solicita tu crédito en minutos."
      : "Ingresa tus datos y empieza a invertir con nuestras cooperativas aliadas.";

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center z-[9999] p-4 animate-fade-in">
      <div className="bg-white rounded-3xl shadow-2xl overflow-hidden w-full max-w-5xl flex flex-col md:flex-row relative animate-scale-in max-h-[90vh]">

        {/* Botón de cerrar */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 bg-white/90 rounded-full p-2 shadow hover:text-red-500 transition"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Lado izquierdo: Branding */}
        <div className="bg-gradient-to-br from-blue-900 via-indigo-900 to-purple-900 text-white p-10 md:w-2/5 flex flex-col justify-center relative">
          <div className="absolute top-0 right-0 w-40 h-40 bg-blue-500/20 rounded-full blur-3xl"></div>
          <div className="absolute bottom-0 left-0 w-40 h-40 bg-purple-500/20 rounded-full blur-3xl"></div>

          <div className="relative text-center">
            <img src={LogoDinerUp} className="w-40 h-40 mx-auto mb-6" />

            <h2 className="text-3xl font-bold mb-4">
              Bienvenid@ a <span className="text-blue-300">DinerUP</span>
            </h2>

            <div className="space-y-3 text-left mt-6">
              {[ 
                { icon: Shield, text: "Seguridad garantizada" },
                { icon: CheckCircle2, text: "Proceso digital" },
                { icon: User, text: "Atención personalizada" }
              ].map((item, i) => {
                const Icon = item.icon;
                return (
                  <div key={i} className="flex items-center gap-3">
                    <Icon className="w-5 h-5 text-blue-300" />
                    <span>{item.text}</span>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Lado derecho: Formulario */}
        <div className="p-8 md:w-3/5 bg-white overflow-y-auto">
          <div className="text-center mb-6">
            <h3 className="text-3xl font-bold text-gray-900">{headerTitle}</h3>
            <p className="text-sm text-gray-500 mt-1">{headerDescription}</p>
          </div>

          {/* Aquí se carga el formulario completo */}
          <CreditRequestForm
            type={type}
            onSuccess={() => setIsSuccessOpen(true)}
          />
        </div>
      </div>

      {/* Animaciones */}
      <style>{`
        @keyframes fade-in { from {opacity: 0;} to {opacity: 1;} }
        @keyframes scale-in { from {opacity: 0; transform: scale(.95);} to {opacity: 1; transform: scale(1);} }
        .animate-fade-in { animation: fade-in .2s ease-out; }
        .animate-scale-in { animation: scale-in .3s ease-out; }
      `}</style>

      {isSuccessOpen && (
        <SuccessModal
          isOpen={isSuccessOpen}
          onClose={() => setIsSuccessOpen(false)}
        />
      )}
    </div>
  );
}


