import { ArrowLeft } from "lucide-react";
import { Link } from "react-router-dom";

export default function Terms() {
  return (
    <div className="min-h-screen bg-gray-50 py-16 px-4">
      
      {/* Contenedor */}
      <div className="max-w-4xl mx-auto bg-white shadow-lg rounded-2xl p-8 md:p-12">
        
        {/* Botón volver */}
        <div className="mb-6">
          <Link 
            to="/" 
            className="inline-flex items-center gap-2 text-blue-600 font-semibold hover:text-blue-700 transition"
          >
            <ArrowLeft className="w-5 h-5" />
            Volver a MarkUp
          </Link>
        </div>

        {/* Título */}
        <h1 className="text-3xl font-bold text-gray-900 mb-4">
          Términos y Condiciones
        </h1>

        <p className="text-gray-600 mb-8">
          Última actualización: Enero 2025
        </p>

        {/* Contenido */}
        <div className="space-y-8 text-gray-700 leading-relaxed">

          {/* Sección 1 */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              1. Introducción
            </h2>
            <p>
              Bienvenido a <strong>MarkUp</strong>. Al utilizar nuestros servicios
              de solicitud de crédito e inversión, aceptas los presentes Términos
              y Condiciones. Este documento regula el uso de la plataforma y el
              manejo de tus datos dentro del ecosistema de MarkUp.
            </p>
          </section>

          {/* Sección 2 */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              2. Uso de la plataforma
            </h2>
            <p>
              MarkUp permite que usuarios puedan registrarse para acceder a 
              productos financieros, como solicitudes de crédito o vehículos 
              de inversión. Todo uso indebido, fraudulento o destinado a 
              actividades ilícitas será bloqueado permanentemente.
            </p>
          </section>

          {/* Sección 3 */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              3. Registro y veracidad de la información
            </h2>
            <p>
              Al registrarte declaras que toda la información enviada es 
              verdadera, completa y verificable. MarkUp se reserva el derecho 
              de suspender cuentas que presenten inconsistencias o intentos de 
              suplantación de identidad.
            </p>
          </section>

          {/* Sección 4 */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              4. Protección de datos personales
            </h2>
            <p>
              MarkUp cumple con las normativas vigentes de protección de datos. 
              La información proporcionada será utilizada únicamente para fines 
              relacionados con análisis de perfil crediticio, contacto comercial 
              y verificación de identidad.
            </p>
            <p className="mt-2">
              Tus datos nunca serán vendidos. Solamente podrán ser compartidos 
              con instituciones financieras asociadas para la evaluación de tu 
              solicitud.
            </p>
          </section>

          {/* Sección 5 */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              5. Consentimiento para el tratamiento de datos
            </h2>
            <p>
              Al enviar un formulario en MarkUp, otorgas autorización expresa 
              para que tus datos sean procesados conforme a las finalidades 
              descritas. Puedes solicitar la eliminación de tus datos en 
              cualquier momento mediante contacto directo.
            </p>
          </section>

          {/* Sección 6 */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              6. Responsabilidad del usuario
            </h2>
            <p>
              Eres responsable del uso adecuado de la plataforma, así como de la 
              confidencialidad de tu información. Está prohibido el uso de MarkUp 
              para actividades fraudulentas o ilegales.
            </p>
          </section>

          {/* Sección 7 */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              7. Modificaciones a los términos
            </h2>
            <p>
              MarkUp podrá actualizar estos términos en cualquier momento. 
              Se notificará a los usuarios cuando se realicen cambios relevantes.
            </p>
          </section>

          {/* Sección 8 */}
          <section>
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              8. Contacto
            </h2>
            <p>
              Si tienes preguntas sobre estos términos o deseas ejercer tus 
              derechos de protección de datos, contáctanos al correo:
              <strong> soporte@markup.ec</strong>
            </p>
          </section>

        </div>

        {/* Botón volver final */}
        <div className="mt-12 text-center">
          <Link
            to="/"
            className="inline-block bg-blue-600 hover:bg-blue-700 text-white font-semibold px-6 py-3 rounded-xl shadow-md transition"
          >
            Volver a MarkUp
          </Link>
        </div>

      </div>
    </div>
  );
}
