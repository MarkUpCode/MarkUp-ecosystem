import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { Section } from "@/components/layout/section";
import { Eyebrow } from "@/components/ui/eyebrow";
import { FadeIn } from "@/components/animations/fade-in";
import { siteConfig } from "@/lib/constants";

const timeline = [
  {
    year: "2020",
    title: "Fundación de Markup Business",
    description:
      "Nace en Ecuador con la misión de transformar el acceso al crédito cooperativo mediante tecnología propia. Primeras alianzas con cooperativas locales.",
  },
  {
    year: "2022",
    title: "Lanzamiento de Dinerop",
    description:
      "Primera plataforma B2C del ecosistema. Consolida solicitudes de crédito entre múltiples cooperativas. Supera los 500 usuarios en los primeros tres meses de operación.",
  },
  {
    year: "2024",
    title: "Waki se integra al holding",
    description:
      "Red B2B colaborativa que conecta cooperativas, comparte datos y genera sinergias operativas. Las primeras 15 cooperativas adoptan la plataforma en Ecuador.",
  },
  {
    year: "2026",
    title: "Expansión regional",
    description:
      "Iniciamos operaciones exploratorias en Colombia y Perú. El modelo de crédito cooperativo digital escala hacia América Latina con más de 40 cooperativas aliadas.",
  },
];

const values = [
  {
    icon: "◎",
    title: "Transparencia",
    description:
      "Operamos con total claridad ante cooperativas, usuarios e inversionistas. Sin letra pequeña, sin opacidad.",
  },
  {
    icon: "◈",
    title: "Inclusión financiera",
    description:
      "Cada decisión de producto tiene como norte ampliar el acceso al crédito para personas históricamente excluidas.",
  },
  {
    icon: "◇",
    title: "Innovación responsable",
    description:
      "Construimos tecnología que resuelve problemas reales del sector, sin comprometer la estabilidad institucional.",
  },
  {
    icon: "◉",
    title: "Colaboración",
    description:
      "No competimos con cooperativas ni entre productos. Cada unidad potencia a las demás en el ecosistema.",
  },
];

const team = [
  { name: "Andrés Mora", role: "CEO & Co-Founder", initials: "AM" },
  { name: "Carolina Vélez", role: "CTO", initials: "CV" },
  { name: "Felipe Rivadeneira", role: "COO", initials: "FR" },
  { name: "Lucía Andrade", role: "Head of Product", initials: "LA" },
];

export default function NosotrosPage() {
  return (
    <>
      {/* Hero */}
      <section className="bg-obsidian py-28 lg:py-36">
        <div className="max-w-[1200px] mx-auto px-6 lg:px-10">
          <Eyebrow color="gold">NOSOTROS</Eyebrow>
          <h1 className="font-serif text-4xl md:text-5xl lg:text-6xl text-bone leading-tight max-w-3xl mb-6">
            Tecnología con propósito cooperativo.
          </h1>
          <p className="text-gray-400 text-lg max-w-2xl leading-relaxed">
            Somos un equipo multidisciplinario unido por la convicción de que
            la tecnología puede transformar el sector cooperativo en América
            Latina sin traicionar sus valores fundacionales.
          </p>
        </div>
      </section>

      {/* Misión y Visión */}
      <Section background="bone">
        <FadeIn>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-10 lg:gap-16">
            <div className="bg-white border border-bone-dark rounded-xl p-8 lg:p-10">
              <Eyebrow>MISIÓN</Eyebrow>
              <h3 className="font-serif text-2xl text-obsidian mb-4 leading-tight">
                Democratizar el acceso al crédito cooperativo.
              </h3>
              <p className="text-gray-500 leading-relaxed text-sm">
                Construir tecnología que elimine las fricciones que separan a
                las personas de los productos financieros cooperativos más
                adecuados para ellas, haciendo del crédito una herramienta de
                desarrollo real y no un laberinto institucional.
              </p>
            </div>
            <div className="bg-white border border-bone-dark rounded-xl p-8 lg:p-10">
              <Eyebrow>VISIÓN</Eyebrow>
              <h3 className="font-serif text-2xl text-obsidian mb-4 leading-tight">
                Ser la infraestructura del cooperativismo digital en LATAM.
              </h3>
              <p className="text-gray-500 leading-relaxed text-sm">
                En 2030, cada cooperativa de América Latina que quiera crecer
                tendrá a Markup Business como su aliado tecnológico natural,
                y cada persona que busque crédito justo encontrará opciones
                reales en nuestra red.
              </p>
            </div>
          </div>
        </FadeIn>
      </Section>

      {/* Historia — Timeline */}
      <Section background="default">
        <FadeIn>
          <div className="mb-14">
            <Eyebrow>HISTORIA</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight">
              Cuatro años construyendo el ecosistema.
            </h2>
          </div>
        </FadeIn>
        <div className="max-w-2xl">
          <div className="relative">
            <div className="absolute left-4 top-0 bottom-0 w-px bg-bone-dark" />
            {timeline.map((item, i) => (
              <FadeIn key={item.year} delay={i * 0.1}>
                <div className="relative pl-12 pb-12 last:pb-0">
                  <div className="absolute left-0 top-1 size-8 rounded-full bg-bone border border-bone-dark flex items-center justify-center">
                    <div className="size-2 rounded-full bg-gold" />
                  </div>
                  <p className="eyebrow text-gold mb-2">{item.year}</p>
                  <h3 className="font-display font-semibold text-lg text-obsidian mb-2">
                    {item.title}
                  </h3>
                  <p className="text-gray-500 text-sm leading-relaxed">
                    {item.description}
                  </p>
                </div>
              </FadeIn>
            ))}
          </div>
        </div>
      </Section>

      {/* Valores */}
      <Section background="bone">
        <FadeIn>
          <div className="mb-12">
            <Eyebrow>VALORES</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight">
              Los principios que nos guían.
            </h2>
          </div>
        </FadeIn>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {values.map((v, i) => (
            <FadeIn key={v.title} delay={i * 0.07}>
              <div className="bg-white border border-bone-dark rounded-xl p-7 h-full">
                <span className="block text-2xl text-gold mb-5">{v.icon}</span>
                <h3 className="font-display font-semibold text-base text-obsidian mb-3">
                  {v.title}
                </h3>
                <p className="text-gray-500 text-sm leading-relaxed">
                  {v.description}
                </p>
              </div>
            </FadeIn>
          ))}
        </div>
      </Section>

      {/* Equipo */}
      <Section background="default">
        <FadeIn>
          <div className="mb-12">
            <Eyebrow>EQUIPO</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight mb-4">
              Las personas detrás del ecosistema.
            </h2>
            <p className="text-gray-500 max-w-lg leading-relaxed">
              Un equipo con experiencia en fintech, cooperativismo, regulación
              financiera y construcción de productos digitales de escala.
            </p>
          </div>
        </FadeIn>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {team.map((member, i) => (
            <FadeIn key={member.name} delay={i * 0.07}>
              <div className="bg-bone border border-bone-dark rounded-xl p-6 flex flex-col items-center text-center">
                <div className="size-16 rounded-full bg-obsidian flex items-center justify-center mb-4">
                  <span className="font-serif text-lg text-gold">
                    {member.initials}
                  </span>
                </div>
                <p className="font-display font-semibold text-sm text-obsidian">
                  {member.name}
                </p>
                <p className="text-xs text-gray-500 mt-1">{member.role}</p>
              </div>
            </FadeIn>
          ))}
        </div>
      </Section>

      {/* CTA */}
      <Section background="obsidian">
        <FadeIn>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <Eyebrow color="gold">ÚNETE</Eyebrow>
              <h2 className="font-serif text-3xl md:text-4xl text-bone leading-tight">
                ¿Quieres construir el futuro con nosotros?
              </h2>
              <p className="text-gray-400 mt-5 leading-relaxed">
                Buscamos personas apasionadas por el cooperativismo, la
                tecnología y la inclusión financiera. Si crees que puedes
                aportar a la misión, queremos conocerte.
              </p>
            </div>
            <div className="flex flex-col items-start gap-4">
              <a
                href={`mailto:${siteConfig.email}`}
                className="inline-flex items-center gap-2 h-11 px-6 rounded-lg bg-bone text-obsidian text-sm font-medium hover:bg-white transition-colors"
              >
                Escribirnos
                <ArrowRight className="size-4" />
              </a>
              <Link
                href="/ecosistema"
                className="text-sm text-gray-500 hover:text-gold transition-colors"
              >
                Ver el ecosistema →
              </Link>
            </div>
          </div>
        </FadeIn>
      </Section>
    </>
  );
}
