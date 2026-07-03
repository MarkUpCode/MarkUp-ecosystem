import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { Separator } from "@/components/ui/separator";
import { Section } from "@/components/layout/section";
import { Eyebrow } from "@/components/ui/eyebrow";
import { FadeIn } from "@/components/animations/fade-in";
import { siteConfig } from "@/lib/constants";

const arguments_ = [
  {
    number: "01",
    title: "Mercado desatendido de $200B+",
    description:
      "El crédito cooperativo en LATAM moviliza más de $200 mil millones anuales. Más del 85% de estas operaciones ocurren sin digitalización. La oportunidad no está en crear otro banco digital, está en modernizar la infraestructura que ya tiene la confianza de millones.",
  },
  {
    number: "02",
    title: "Tecnología probada, red en expansión",
    description:
      "Dinerop y Waki tienen operaciones activas con más de 40 cooperativas aliadas y 2.020+ usuarios. No es una tesis de mercado: es un modelo de negocio con tracción real, métricas de retención sólidas y un equipo técnico que ya resolvió los problemas más difíciles.",
  },
  {
    number: "03",
    title: "Modelo de holding con sinergias nativas",
    description:
      "La estructura de holding genera efectos de red entre productos: cada cooperativa que adopta Waki amplifica el valor de Dinerop, y cada usuario de Dinerop fortalece la red de datos de Waki. Markup Digital monetiza la transformación en ambos sentidos.",
  },
];

const kpis = [
  {
    value: "2.020+",
    label: "USUARIOS ACTIVOS",
    description: "Personas en la plataforma Dinerop",
  },
  {
    value: "+40",
    label: "COOPERATIVAS ALIADAS",
    description: "Instituciones integradas a la red",
  },
  {
    value: "15K+",
    label: "SOLICITUDES PROCESADAS",
    description: "Créditos gestionados en plataforma",
  },
  {
    value: "23%",
    label: "CRECIMIENTO MoM",
    description: "Tasa de crecimiento mensual de usuarios",
  },
  {
    value: "3",
    label: "PRODUCTOS EN MERCADO",
    description: "Soluciones activas del ecosistema",
  },
  {
    value: "4+",
    label: "AÑOS DE OPERACIÓN",
    description: "Trayectoria comprobada en el sector",
  },
];

const thesisParagraphs = [
  "El mercado de crédito cooperativo en América Latina moviliza más de $200 mil millones anuales, sirviendo a una población que históricamente ha sido excluida del sistema bancario tradicional. Sin embargo, más del 85% de estas operaciones ocurren de manera no digitalizada, con procesos manuales, información fragmentada y nula interoperabilidad entre instituciones.",
  "Markup Business identifica esta brecha como una de las mayores oportunidades no atendidas en fintech regional. A diferencia de los neobancos que compiten con cooperativas, construimos tecnología que potencia a estas instituciones: Dinerop conecta personas con múltiples opciones de crédito, Waki crea la infraestructura colaborativa entre cooperativas, y Markup Digital acelera la transformación institucional.",
  "El modelo de holding integrado nos permite capturar valor en múltiples puntos del flujo financiero cooperativo, con efectos de red entre productos. A medida que más cooperativas adoptan Waki, el valor de Dinerop para los usuarios finales se multiplica. Esta sinergia es la base de nuestra ventaja competitiva sostenible y el argumento central de nuestra tesis de inversión.",
];

export default function InversionistasPage() {
  return (
    <>
      {/* Hero */}
      <section className="bg-obsidian-dark py-28 lg:py-40">
        <div className="max-w-[1200px] mx-auto px-6 lg:px-10">
          <Eyebrow color="gold">INVERSIONISTAS Y ALIADOS</Eyebrow>
          <h1 className="font-serif text-4xl md:text-5xl lg:text-6xl text-bone leading-tight max-w-3xl mb-7">
            Invierte en el futuro del crédito cooperativo en LATAM.
          </h1>
          <p className="text-gray-400 text-lg max-w-2xl mb-10 leading-relaxed">
            Buscamos socios de largo plazo que compartan nuestra convicción de
            que el cooperativismo digitalizado es la forma más resiliente y
            equitativa de expandir el acceso al crédito en América Latina.
          </p>
          <div className="flex flex-col sm:flex-row gap-4">
            <a
              href={`mailto:${siteConfig.investorsEmail}`}
              className="inline-flex items-center gap-2 h-12 px-8 rounded-lg bg-gold text-obsidian text-sm font-medium hover:bg-gold-soft transition-colors"
            >
              Solicitar one-pager
              <ArrowRight className="size-4" />
            </a>
            <a
              href={`mailto:${siteConfig.investorsEmail}`}
              className="inline-flex items-center justify-center h-12 px-8 rounded-lg border border-white/25 text-bone text-sm font-medium hover:border-white/50 hover:bg-white/5 transition-all"
            >
              Agendar conversación
            </a>
          </div>
        </div>
      </section>

      {/* Por qué Markup — 3 argumentos */}
      <Section background="default">
        <FadeIn>
          <div className="mb-14">
            <Eyebrow>POR QUÉ MARKUP BUSINESS</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight">
              Tres argumentos, una oportunidad irrepetible.
            </h2>
          </div>
        </FadeIn>
        <div className="space-y-0">
          {arguments_.map((arg, i) => (
            <FadeIn key={arg.number} delay={i * 0.08}>
              <div className="py-10 grid grid-cols-1 lg:grid-cols-[120px_1fr] gap-6 border-b border-bone-dark last:border-0">
                <p className="font-serif text-5xl text-gold leading-none">
                  {arg.number}
                </p>
                <div>
                  <h3 className="font-display font-semibold text-xl text-obsidian mb-3">
                    {arg.title}
                  </h3>
                  <p className="text-gray-500 leading-relaxed max-w-2xl">
                    {arg.description}
                  </p>
                </div>
              </div>
            </FadeIn>
          ))}
        </div>
      </Section>

      {/* Métricas clave */}
      <Section background="bone">
        <FadeIn>
          <div className="mb-12">
            <Eyebrow>MÉTRICAS</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight">
              Números que respaldan la tesis.
            </h2>
          </div>
        </FadeIn>
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          {kpis.map((kpi, i) => (
            <FadeIn key={kpi.label} delay={i * 0.06}>
              <div className="bg-white border border-bone-dark rounded-xl p-7">
                <p className="font-serif text-4xl text-gold mb-1">
                  {kpi.value}
                </p>
                <p className="eyebrow text-gray-500 mb-2">{kpi.label}</p>
                <p className="text-xs text-gray-400 leading-relaxed">
                  {kpi.description}
                </p>
              </div>
            </FadeIn>
          ))}
        </div>
      </Section>

      {/* Tesis de inversión — editorial */}
      <Section background="default">
        <FadeIn>
          <div className="max-w-3xl mx-auto">
            <Eyebrow>TESIS DE INVERSIÓN</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight mb-10">
              Por qué el crédito cooperativo digital es la mayor oportunidad
              fintech de la próxima década en LATAM.
            </h2>
            <div className="space-y-6">
              {thesisParagraphs.map((p, i) => (
                <p
                  key={i}
                  className="font-serif text-lg text-gray-700 leading-relaxed"
                >
                  {p}
                </p>
              ))}
            </div>
          </div>
        </FadeIn>
      </Section>

      {/* Ronda actual */}
      <Section background="bone">
        <FadeIn>
          <div
            className="rounded-2xl p-10 md:p-14 border"
            style={{
              backgroundColor: "#0F1419",
              borderColor: "rgba(184,147,90,0.3)",
            }}
          >
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-10 items-center">
              <div>
                <span className="inline-block eyebrow text-gold mb-4">
                  ESTADO ACTUAL
                </span>
                <h2 className="font-serif text-3xl md:text-4xl text-bone leading-tight mb-4">
                  Serie A en preparación.
                </h2>
                <p className="text-gray-400 leading-relaxed">
                  Actualmente cerramos nuestra ronda semilla con inversores
                  estratégicos del sector. La Serie A está proyectada para Q3
                  2026 con un objetivo de $3M para acelerar la expansión
                  regional y el desarrollo de producto.
                </p>
              </div>
              <div className="space-y-4">
                <div className="border border-white/10 rounded-lg p-5">
                  <p className="eyebrow text-gray-500 mb-1">ETAPA</p>
                  <p className="font-display font-semibold text-bone">
                    Pre-Serie A / Semilla avanzada
                  </p>
                </div>
                <div className="border border-white/10 rounded-lg p-5">
                  <p className="eyebrow text-gray-500 mb-1">USO DE FONDOS</p>
                  <p className="font-display font-semibold text-bone">
                    Expansión LATAM · Producto · Equipo
                  </p>
                </div>
                <div className="border border-white/10 rounded-lg p-5">
                  <p className="eyebrow text-gray-500 mb-1">OBJETIVO</p>
                  <p className="font-display font-semibold text-gold">
                    USD $3.000.000
                  </p>
                </div>
              </div>
            </div>
          </div>
        </FadeIn>
      </Section>

      {/* Contacto directo */}
      <Section background="obsidian">
        <FadeIn>
          <div className="text-center max-w-lg mx-auto">
            <Eyebrow color="gold">CONTACTO DIRECTO</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-bone mb-5">
              Hablemos.
            </h2>
            <p className="text-gray-400 mb-8 leading-relaxed">
              Si compartes la visión y quieres explorar una conversación,
              escríbenos directamente. Respondemos en menos de 48 horas.
            </p>
            <a
              href={`mailto:${siteConfig.investorsEmail}`}
              className="inline-flex items-center gap-2 h-12 px-8 rounded-lg bg-gold text-obsidian text-sm font-medium hover:bg-gold-soft transition-colors mb-4"
            >
              {siteConfig.investorsEmail}
              <ArrowRight className="size-4" />
            </a>
          </div>
        </FadeIn>
      </Section>
    </>
  );
}
