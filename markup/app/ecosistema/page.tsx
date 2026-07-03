import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { Section } from "@/components/layout/section";
import { Eyebrow } from "@/components/ui/eyebrow";
import { FadeIn } from "@/components/animations/fade-in";
import { ecosystem, siteConfig } from "@/lib/constants";

const productDetails = [
  {
    id: "dinerop",
    headline: "Una solicitud. Múltiples cooperativas. La mejor opción.",
    paragraphs: [
      "Dinerop es la primera plataforma B2C de crédito cooperativo en Ecuador. En lugar de visitar cada cooperativa por separado, el usuario completa una sola solicitud y recibe ofertas comparadas de hasta 40 instituciones aliadas.",
      "Nuestra tecnología de matching conecta el perfil crediticio del solicitante con los productos más adecuados de la red, reduciendo el tiempo de aprobación de semanas a horas y democratizando el acceso a las mejores tasas del mercado cooperativo.",
    ],
    benefits: [
      "Solicitud única para múltiples cooperativas",
      "Comparación de tasas y condiciones en tiempo real",
      "Aprobación en horas, no en semanas",
      "Red de más de 40 cooperativas aliadas",
    ],
    cta: "Visitar Dinerop",
    number: "01",
  },
  {
    id: "waki",
    headline: "La primera red colaborativa para cooperativas.",
    paragraphs: [
      "Waki transforma la forma en que las cooperativas operan entre sí. Más que un software de gestión, es una red B2B que permite a las instituciones compartir información, servicios y oportunidades de negocio de manera segura y estructurada.",
      "Con Waki, las cooperativas dejan de operar como silos y comienzan a funcionar como un ecosistema. Esto se traduce en menor riesgo crediticio compartido, mayor capacidad de servicio y una experiencia significativamente mejor para los socios de cada institución.",
    ],
    benefits: [
      "Interoperabilidad entre sistemas core bancarios",
      "Datos compartidos con privacidad por diseño",
      "Servicios complementarios entre instituciones",
      "Dashboard de inteligencia sectorial en tiempo real",
    ],
    cta: "Conocer Waki",
    number: "02",
  },
  {
    id: "markup-digital",
    headline: "Transformación digital a medida para el sector cooperativo.",
    paragraphs: [
      "Markup Digital es el brazo de consultoría estratégica del holding. Trabajamos con cooperativas, fondos de inversión y organismos reguladores para diseñar e implementar hojas de ruta de transformación digital que crean valor real y medible.",
      "Nuestro equipo combina experiencia en fintech, regulación financiera cooperativa y desarrollo de software para entregar soluciones que se integran al negocio, no al revés. No vendemos proyectos, construimos capacidades institucionales.",
    ],
    benefits: [
      "Diagnóstico de madurez digital institucional",
      "Diseño de arquitectura tecnológica cooperativa",
      "Implementación y acompañamiento iterativo",
      "Formación de equipos internos de tecnología",
    ],
    cta: "Conocer Markup Digital",
    number: "03",
  },
] as const;

export default function EcosistemaPage() {
  return (
    <>
      {/* Hero */}
      <Section background="bone" className="pb-16">
        <FadeIn>
          <Eyebrow>ECOSISTEMA</Eyebrow>
          <h1 className="font-serif text-4xl md:text-5xl lg:text-6xl text-obsidian leading-tight max-w-3xl mb-6">
            Tres productos. Una visión integrada.
          </h1>
          <p className="text-gray-500 text-lg max-w-2xl leading-relaxed">
            Dinerop, Waki y Markup Digital son unidades complementarias que
            cubren la cadena de valor completa del crédito cooperativo: el
            usuario final, la red institucional y la transformación estratégica.
          </p>
        </FadeIn>
      </Section>

      {/* Product sections — alternating layout */}
      {ecosystem.map((product, i) => {
        const detail = productDetails.find((d) => d.id === product.id)!;
        const isEven = i % 2 === 0;

        return (
          <Section key={product.id} background={isEven ? "default" : "bone"}>
            <FadeIn>
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-20 items-center">
                {/* Text */}
                <div className={isEven ? "" : "lg:order-2"}>
                  <div
                    className="inline-flex items-center px-3 py-1.5 rounded-full text-[10px] font-semibold tracking-widest uppercase text-white mb-6"
                    style={{ backgroundColor: product.color }}
                  >
                    {product.label}
                  </div>
                  <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight mb-6">
                    {detail.headline}
                  </h2>
                  {detail.paragraphs.map((para, pi) => (
                    <p
                      key={pi}
                      className="text-gray-500 leading-relaxed mb-4 last:mb-0"
                    >
                      {para}
                    </p>
                  ))}
                  <ul className="mt-7 space-y-3">
                    {detail.benefits.map((b) => (
                      <li
                        key={b}
                        className="flex items-start gap-3 text-sm text-gray-600"
                      >
                        <span
                          className="mt-2 size-1.5 rounded-full shrink-0"
                          style={{ backgroundColor: product.color }}
                        />
                        {b}
                      </li>
                    ))}
                  </ul>
                  <div className="mt-8">
                    {product.external ? (
                      <a
                        href={product.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-2 h-11 px-6 rounded-lg text-white text-sm font-medium hover:opacity-90 transition-opacity"
                        style={{ backgroundColor: product.color }}
                      >
                        {detail.cta}
                        <ArrowRight className="size-4" />
                      </a>
                    ) : (
                      <Link
                        href={product.href}
                        className="inline-flex items-center gap-2 h-11 px-6 rounded-lg text-white text-sm font-medium hover:opacity-90 transition-opacity"
                        style={{ backgroundColor: product.color }}
                      >
                        {detail.cta}
                        <ArrowRight className="size-4" />
                      </Link>
                    )}
                  </div>
                </div>

                {/* Visual block */}
                <div
                  className={`relative h-[320px] md:h-[420px] w-full rounded-2xl overflow-hidden flex flex-col items-start justify-end p-10 ${
                    isEven ? "" : "lg:order-1"
                  }`}
                  style={{ backgroundColor: product.color }}
                >
                  <p
                    className="absolute -top-6 -right-4 font-serif leading-none select-none"
                    style={{
                      fontSize: "11rem",
                      color: "rgba(255,255,255,0.07)",
                    }}
                  >
                    {detail.number}
                  </p>
                  <p
                    className="font-serif text-4xl md:text-5xl relative z-10"
                    style={{ color: product.textColor }}
                  >
                    {product.name}
                  </p>
                  <p
                    className="text-xs tracking-widest uppercase mt-2 relative z-10"
                    style={{ color: `${product.textColor}80` }}
                  >
                    {product.label}
                  </p>
                </div>
              </div>
            </FadeIn>
          </Section>
        );
      })}

      {/* Final CTA */}
      <Section background="obsidian">
        <FadeIn>
          <div className="text-center max-w-xl mx-auto">
            <Eyebrow color="gold">ÚNETE</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-bone mb-5">
              ¿Quieres ser parte del ecosistema?
            </h2>
            <p className="text-gray-400 mb-8 leading-relaxed">
              Tanto si eres una cooperativa que quiere digitalizarse, un
              inversionista que busca oportunidades o un talento que quiere
              construir el futuro del crédito cooperativo.
            </p>
            <a
              href={`mailto:${siteConfig.email}`}
              className="inline-flex items-center gap-2 h-11 px-8 rounded-lg bg-gold text-obsidian text-sm font-medium hover:bg-gold-soft transition-colors"
            >
              Escribirnos
              <ArrowRight className="size-4" />
            </a>
          </div>
        </FadeIn>
      </Section>
    </>
  );
}
