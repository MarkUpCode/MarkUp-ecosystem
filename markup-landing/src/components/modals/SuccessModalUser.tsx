import React from "react";
import { CheckCircle, ArrowRight, MailCheck } from "lucide-react";

interface SuccessModalProps {
  isOpen: boolean;
  onClose: () => void;
  message?: string;
  userEmail?: string;
}

const SuccessModal: React.FC<SuccessModalProps> = ({
  isOpen,
  onClose,
  message,
  userEmail,
}) => {
  if (!isOpen) return null;

  const handleGoToPlatform = () => {
    onClose();
    window.open("https://dinerup-app.vercel.app/", "_blank");
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm animate-fade-in">
      <div className="bg-white rounded-3xl shadow-2xl p-8 w-full max-w-md mx-4 animate-scale-in">
        
        {/* Ícono éxito */}
        <div className="flex justify-center mb-4">
          <div className="bg-green-100 p-4 rounded-full">
            <CheckCircle className="text-green-600" size={48} />
          </div>
        </div>

        {/* Título */}
        <h2 className="text-2xl font-bold text-gray-900 text-center mb-2">
          ¡Solicitud enviada con éxito!
        </h2>

        {/* Mensaje corto */}
        <p className="text-sm text-gray-600 text-center mb-6">
          {message || "Hemos recibido tu solicitud correctamente."}
        </p>

        {/* Pasos */}
        <div className="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl p-5 border border-blue-100 mb-6">
          <div className="flex items-center gap-2 mb-3">
            <MailCheck className="text-blue-600" size={20} />
            <p className="text-base font-semibold text-gray-800">
              Sigue estos pasos para continuar
            </p>
          </div>

          <ol className="text-sm text-gray-700 space-y-2 list-decimal list-inside">
            <li>
              Revisa tu correo electrónico y
              <span className="font-semibold"> activa tu cuenta</span>.
            </li>
            <li>
              Completa tu
              <span className="font-semibold"> registro en la plataforma</span>.
            </li>
            <li>
              Ingresa a DinerUp y da seguimiento al estado de tu
              <span className="font-semibold"> crédito o inversión</span>.
            </li>
          </ol>

          {userEmail && (
            <p className="text-xs text-gray-600 mt-3">
              Correo registrado:{" "}
              <span className="font-semibold text-blue-600">
                {userEmail}
              </span>
            </p>
          )}
        </div>

        {/* Acciones */}
        <div className="flex flex-col gap-3">
          <button
            onClick={handleGoToPlatform}
            className="group w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-3 rounded-xl font-semibold flex items-center justify-center gap-2 hover:from-blue-700 hover:to-indigo-700 transition-all"
          >
            Ir a DinerUp
            <ArrowRight className="group-hover:translate-x-1 transition-transform" size={18} />
          </button>

          <button
            onClick={onClose}
            className="w-full text-sm text-gray-600 hover:text-gray-800 transition"
          >
            Cerrar
          </button>
        </div>
      </div>

      <style>{`
        @keyframes fade-in {
          from { opacity: 0; }
          to { opacity: 1; }
        }

        @keyframes scale-in {
          from {
            opacity: 0;
            transform: scale(0.95) translateY(20px);
          }
          to {
            opacity: 1;
            transform: scale(1) translateY(0);
          }
        }

        .animate-fade-in {
          animation: fade-in 0.3s ease-out;
        }

        .animate-scale-in {
          animation: scale-in 0.4s ease-out;
        }
      `}</style>
    </div>
  );
};

export default SuccessModal;
