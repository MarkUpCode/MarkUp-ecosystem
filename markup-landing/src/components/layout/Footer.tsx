import React from 'react';
import { TrendingUp, Mail, Phone, MapPin, Facebook, Twitter, Instagram, Linkedin } from 'lucide-react';

const Footer: React.FC = () => {
  const scrollToSection = (sectionId: string) => {
    const element = document.getElementById(sectionId);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <footer id="contact" className="bg-gradient-to-br from-primary-900 to-primary-600 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        {/* Main Footer Content */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-12">
          {/* Company Info */}
          <div className="lg:col-span-1">
            <div className="flex items-center space-x-2 mb-6">
              <TrendingUp className="h-8 w-8 text-white" />
              <span className="text-2xl font-bold">Mark Up</span>
            </div>
            <p className="text-gray-200 mb-6 leading-relaxed">
              Tu aliado financiero para consolidar créditos. Conectamos personas con las mejores
              oportunidades de crédito del mercado de forma rápida, segura y transparente.
            </p>
            <div className="flex space-x-4">
              <a href="#" className="p-2 bg-white/10 rounded-lg hover:bg-white/20 transition-colors duration-200">
                <Facebook className="h-5 w-5" />
              </a>
              <a href="#" className="p-2 bg-white/10 rounded-lg hover:bg-white/20 transition-colors duration-200">
                <Twitter className="h-5 w-5" />
              </a>
              <a href="#" className="p-2 bg-white/10 rounded-lg hover:bg-white/20 transition-colors duration-200">
                <Instagram className="h-5 w-5" />
              </a>
              <a href="#" className="p-2 bg-white/10 rounded-lg hover:bg-white/20 transition-colors duration-200">
                <Linkedin className="h-5 w-5" />
              </a>
            </div>
          </div>

          {/* Quick Links */}
          <div>
            <h3 className="text-xl font-semibold mb-6">Enlaces Rápidos</h3>
            <ul className="space-y-3">
              <li>
                <button
                  onClick={() => scrollToSection('hero')}
                  className="text-gray-200 hover:text-white transition-colors duration-200 text-left"
                >
                  Inicio
                </button>
              </li>
              <li>
                <button
                  onClick={() => scrollToSection('services')}
                  className="text-gray-200 hover:text-white transition-colors duration-200 text-left"
                >
                  Nuestros Servicios
                </button>
              </li>
              <li>
                <button
                  onClick={() => scrollToSection('calculator')}
                  className="text-gray-200 hover:text-white transition-colors duration-200 text-left"
                >
                  Calculadora de Créditos
                </button>
              </li>
              <li>
                <button
                  onClick={() => scrollToSection('registration')}
                  className="text-gray-200 hover:text-white transition-colors duration-200 text-left"
                >
                  Registro
                </button>
              </li>
              <li>
                <a href="#" className="text-gray-200 hover:text-white transition-colors duration-200">
                  Términos y Condiciones
                </a>
              </li>
              <li>
                <a href="#" className="text-gray-200 hover:text-white transition-colors duration-200">
                  Política de Privacidad
                </a>
              </li>
            </ul>
          </div>

          {/* Services */}
          <div>
            <h3 className="text-xl font-semibold mb-6">Servicios</h3>
            <ul className="space-y-3">
              <li>
                <a href="#" className="text-gray-200 hover:text-white transition-colors duration-200">
                  Crédito Personal
                </a>
              </li>
              <li>
                <a href="#" className="text-gray-200 hover:text-white transition-colors duration-200">
                  Crédito Hipotecario
                </a>
              </li>
              <li>
                <a href="#" className="text-gray-200 hover:text-white transition-colors duration-200">
                  Crédito Vehicular
                </a>
              </li>
              <li>
                <a href="#" className="text-gray-200 hover:text-white transition-colors duration-200">
                  Libre Inversión
                </a>
              </li>
            </ul>
          </div>

          {/* Contact Info */}
          <div>
            <h3 className="text-xl font-semibold mb-6">Contacto</h3>
            <ul className="space-y-4">
              <li className="flex items-start space-x-3">
                <MapPin className="h-5 w-5 text-success mt-1 flex-shrink-0" />
                <div>
                  <p className="text-gray-200">
                    La vicentina<br />
                    Quito, Ecuador
                  </p>
                </div>
              </li>
              <li className="flex items-center space-x-3">
                <Phone className="h-5 w-5 text-success flex-shrink-0" />
                <div>
                  <p className="text-gray-200">+593 12 234 2345</p>
                  <p className="text-gray-200">+593 12 234 2345</p>
                </div>
              </li>
              <li className="flex items-center space-x-3">
                <Mail className="h-5 w-5 text-success flex-shrink-0" />
                <div>
                  <p className="text-gray-200">info@markup.com</p>
                  <p className="text-gray-200">sistemas@markup.com</p>
                </div>
              </li>
            </ul>

          </div>
        </div>

        {/* Bottom Section */}
        <div className="border-t border-white/10 pt-8">
          <div className="flex flex-col lg:flex-row justify-between items-center space-y-4 lg:space-y-0">
            <div className="text-center lg:text-left">
              <p className="text-gray-200">
                © 2025 Mark Up. Todos los derechos reservados.
              </p>
            </div>

            <div className="flex items-center space-x-6 text-sm text-gray-200">
              <a href="#" className="hover:text-white transition-colors duration-200">
                Protección de Datos
              </a>
              <a href="#" className="hover:text-white transition-colors duration-200">
                Código de Ética
              </a>
            </div>
          </div>
        </div>

        {/* Regulatory Info */}
        <div className="mt-8 p-6 bg-white/5 rounded-2xl">
          <p className="text-sm text-gray-200 text-center leading-relaxed">
            Mark Up es una plataforma de intermediación financiera que conecta usuarios con entidades
            cooperativas autorizadas. No somos una entidad financiera. Todos los productos están sujetos
            a evaluación crediticia. Las tasas y condiciones pueden variar según el perfil del solicitante.
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;