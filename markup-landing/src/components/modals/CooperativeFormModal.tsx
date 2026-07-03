import React, { useState } from "react";
import { X, Building2, User, Phone, Mail, MapPin, MessageSquare, Send, Sparkles, CheckCircle, Shield } from "lucide-react";

interface CooperativeFormModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: () => void;
}

const CooperativeFormModal: React.FC<CooperativeFormModalProps> = ({
    isOpen,
    onClose,
    onSuccess,
}) => {
    const [formData, setFormData] = useState({
        name: "",
        contact: "",
        phone: "",
        email: "",
        city: "",
        message: "",
    });

    const handleChange = (
        e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
    ) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        console.log("Datos enviados:", formData);
        setFormData({
            name: "",
            contact: "",
            phone: "",
            email: "",
            city: "",
            message: "",
        });
        onClose();
        onSuccess();
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-md p-4 animate-fade-in pointer-events-auto">
            <div className="bg-white rounded-3xl shadow-2xl w-full max-w-2xl relative overflow-hidden animate-scale-in pointer-events-auto">
                {/* Elementos decorativos de fondo en tonos azules */}
                <div className="absolute top-0 right-0 w-64 h-64 bg-gradient-to-br from-blue-200/40 to-indigo-200/40 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2"></div>
                <div className="absolute bottom-0 left-0 w-64 h-64 bg-gradient-to-tr from-sky-200/40 to-blue-200/40 rounded-full blur-3xl translate-y-1/2 -translate-x-1/2"></div>

                {/* Close button mejorado */}
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 z-50 w-10 h-10 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center text-gray-600 hover:bg-white hover:text-red-500 transition-all shadow-lg hover:scale-110"
                >
                    <X size={20} />
                </button>

                <div className="relative z-10 p-8">
                    {/* Header mejorado */}
                    <div className="text-center mb-8">
                        {/* Badge decorativo en tonos azules */}
                        <div className="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-full mb-4">
                            <Sparkles className="w-4 h-4 text-blue-600" />
                            <span className="text-sm font-semibold text-blue-700">Únete a nuestra red de cooperativas</span>
                        </div>

                        <h2 className="text-3xl font-bold text-gray-900 mb-3">
                            Postula tu Cooperativa
                        </h2>
                        <p className="text-gray-600 max-w-md mx-auto leading-relaxed">
                            Completa los siguientes datos y nos pondremos en contacto contigo para comenzar esta alianza estratégica.
                        </p>
                    </div>

                    {/* Benefits cards en tonos azules */}
                    <div className="grid grid-cols-3 gap-3 mb-8">
                        {[
                            { icon: CheckCircle, text: "Más clientes" },
                            { icon: Shield, text: "Mayor alcance" },
                            { icon: CheckCircle, text: "Sin costo inicial" }
                        ].map((benefit, i) => {
                            const Icon = benefit.icon;
                            return (
                                <div key={i} className="flex items-center gap-2 p-3 bg-gradient-to-br from-blue-50 to-indigo-50 rounded-xl border border-blue-100">
                                    <Icon className="w-4 h-4 text-blue-600 flex-shrink-0" />
                                    <span className="text-xs font-medium text-gray-700">{benefit.text}</span>
                                </div>
                            );
                        })}
                    </div>

                    {/* Form mejorado */}
                    <form onSubmit={handleSubmit} className="space-y-4">
                        {/* Nombre de cooperativa */}
                        <div className="relative group">
                            <Building2 className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 group-focus-within:text-blue-600 transition-colors" />
                            <input
                                name="name"
                                value={formData.name}
                                onChange={handleChange}
                                placeholder="Nombre de la cooperativa"
                                className="w-full border-2 border-gray-200 rounded-xl pl-12 pr-4 py-3.5 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition-all text-gray-900 placeholder:text-gray-400"
                                required
                            />
                        </div>

                        {/* Nombre de contacto */}
                        <div className="relative group">
                            <User className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 group-focus-within:text-blue-600 transition-colors" />
                            <input
                                name="contact"
                                value={formData.contact}
                                onChange={handleChange}
                                placeholder="Nombre del representante"
                                className="w-full border-2 border-gray-200 rounded-xl pl-12 pr-4 py-3.5 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition-all text-gray-900 placeholder:text-gray-400"
                                required
                            />
                        </div>

                        {/* Teléfono y Email */}
                        <div className="grid grid-cols-2 gap-4">
                            <div className="relative group">
                                <Phone className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 group-focus-within:text-blue-600 transition-colors" />
                                <input
                                    name="phone"
                                    value={formData.phone}
                                    onChange={handleChange}
                                    placeholder="Teléfono"
                                    className="w-full border-2 border-gray-200 rounded-xl pl-12 pr-4 py-3.5 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition-all text-gray-900 placeholder:text-gray-400"
                                    required
                                />
                            </div>
                            <div className="relative group">
                                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 group-focus-within:text-blue-600 transition-colors" />
                                <input
                                    type="email"
                                    name="email"
                                    value={formData.email}
                                    onChange={handleChange}
                                    placeholder="Email corporativo"
                                    className="w-full border-2 border-gray-200 rounded-xl pl-12 pr-4 py-3.5 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition-all text-gray-900 placeholder:text-gray-400"
                                    required
                                />
                            </div>
                        </div>

                        {/* Ciudad */}
                        <div className="relative group">
                            <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 group-focus-within:text-blue-600 transition-colors" />
                            <input
                                name="city"
                                value={formData.city}
                                onChange={handleChange}
                                placeholder="Ciudad principal de operación"
                                className="w-full border-2 border-gray-200 rounded-xl pl-12 pr-4 py-3.5 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition-all text-gray-900 placeholder:text-gray-400"
                            />
                        </div>



                        {/* Submit button con gradiente azul */}
                        <button
                            type="submit"
                            className="w-full group relative bg-gradient-to-r from-blue-500 via-blue-600 to-indigo-600 text-white font-bold py-4 rounded-xl hover:from-blue-600 hover:via-blue-700 hover:to-indigo-700 transition-all shadow-lg hover:shadow-xl hover:scale-[1.02] overflow-hidden"
                        >
                            <span className="relative z-10 flex items-center justify-center gap-2">
                                <Send className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                                Enviar postulación
                            </span>
                            <div className="absolute inset-0 bg-gradient-to-r from-white/0 via-white/20 to-white/0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-1000"></div>
                        </button>

                        {/* Footer info */}
                        <p className="text-xs text-center text-gray-500 mt-4">
                            Nos comunicaremos contigo en un plazo de 24-48 horas hábiles
                        </p>
                    </form>
                </div>
            </div>

            <style>{`
                @keyframes fade-in {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
                @keyframes scale-in {
                    from { transform: scale(0.95); opacity: 0; }
                    to { transform: scale(1); opacity: 1; }
                }
                .animate-fade-in {
                    animation: fade-in 0.2s ease-out;
                }
                .animate-scale-in {
                    animation: scale-in 0.3s ease-out;
                }
            `}</style>
        </div>
    );
};

export default CooperativeFormModal;