import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { Section } from "@/components/layout/section";
import { Eyebrow } from "@/components/ui/eyebrow";
import { FadeIn } from "@/components/animations/fade-in";
import { siteConfig, ecosystem, metrics, pillars } from "@/lib/constants";

export default function Home() {
  return (
    <>
      {/* ── Hero ─────────────────────────────────────────── */}
      <section className="bg-obsidian py-28 lg:py-36">
        <div className="max-w-[1200px] mx-auto px-6 lg:px-10">
          <Eyebrow color="gold">HOLDING FINTECH</Eyebrow>
          <h1 className="font-serif text-5xl md:text-6xl lg:text-7xl text-bone leading-[1.06] tracking-tight max-w-4xl mb-7">
            Construimos el futuro del{" "}
            <em className="not-italic" style={{ color: "#B8935A" }}>
              crédito cooperativo.
            </em>
          </h1>
          <p className="text-gray-400 text-base md:text-lg max-w-2xl mb-10 leading-relaxed">
            Tres productos, una visión: democratizar el acceso al crédito
            mediante tecnología que conecta personas, cooperativas y
            oportunidades en América Latina.
          </p>
          <div className="flex flex-col sm:flex-row gap-4">
            <Link
              href="/ecosistema"
              className="inline-flex items-center gap-2 h-11 px-6 rounded-lg bg-bone text-obsidian text-sm font-medium hover:bg-white transition-colors"
            >
              Conocer el ecosistema
              <ArrowRight className="size-4" />
            </Link>
            <a
              href={`mailto:${siteConfig.email}`}
              className="inline-flex items-center justify-center h-11 px-6 rounded-lg border border-white/25 text-bone text-sm font-medium hover:border-white/50 hover:bg-white/5 transition-all"
            >
              Hablar con el equipo
            </a>
          </div>

          {/* Metrics */}
          <div className="mt-16 pt-8 border-t border-white/10">
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-8">
              {metrics.map((m) => (
                <div key={m.label}>
                  <p className="font-serif text-4xl md:text-5xl text-gold mb-2">
                    {m.value}
                  </p>
                  <p className="eyebrow text-gray-500">{m.label}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* ── Nosotros preview ─────────────────────────────── */}
      <Section background="bone">
        <FadeIn>
          <div className="grid grid-cols-1 lg:grid-cols-[1fr_1.4fr] gap-12 lg:gap-20 items-start">
            <div>
              <Eyebrow>NOSOTROS</Eyebrow>
              <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight">
                Una empresa, un ecosistema financiero.
              </h2>
            </div>
            <div className="space-y-5 text-gray-600 leading-relaxed">
              <p>
                Markup Business es un holding fintech fundado en Ecuador con la
                visión de transformar radicalmente el acceso al crédito
                cooperativo en América Latina. Operamos tres unidades de negocio
                complementarias que, en conjunto, cubren toda la cadena de valor
                del sector.
              </p>
              <p>
                Creemos que las cooperativas son el vehículo natural de
                inclusión financiera en la región. Nuestro trabajo no es
                competir con ellas, sino potenciarlas con tecnología que
                democratiza el acceso y genera sinergias institucionales sin
                precedentes.
              </p>
              <Link
                href="/nosotros"
                className="inline-flex items-center gap-1.5 text-sm font-medium text-obsidian hover:text-gold transition-colors mt-2"
              >
                Conocer nuestra historia
                <ArrowRight className="size-4" />
              </Link>
            </div>
          </div>
        </FadeIn>
      </Section>

      {/* ── Ecosistema ───────────────────────────────────── */}
      <Section background="default">
        <FadeIn>
          <div className="mb-12">
            <Eyebrow>ECOSISTEMA</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight mb-3">
              Tres productos que trabajan en red.
            </h2>
            <p className="text-gray-500 max-w-lg">
              Cada uno resuelve una pieza del rompecabezas financiero.
            </p>
          </div>
        </FadeIn>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {ecosystem.map((item, i) => (
            <FadeIn key={item.id} delay={i * 0.08}>
              <EcosystemCard item={item} />
            </FadeIn>
          ))}
        </div>
      </Section>

      {/* ── Pilares ─────────────────────────────────────── */}
      <Section background="bone">
        <FadeIn>
          <div className="mb-12 text-center max-w-xl mx-auto">
            <Eyebrow>POR QUÉ MARKUP</Eyebrow>
            <h2 className="font-serif text-3xl md:text-4xl text-obsidian leading-tight">
              Pilares que sostienen nuestro trabajo.
            </h2>
          </div>
        </FadeIn>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {pillars.map((p, i) => (
            <FadeIn key={p.number} delay={i * 0.08}>
              <div className="bg-white border border-bone-dark rounded-xl p-8">
                <p className="font-serif text-5xl text-gold mb-6">{p.number}</p>
                <h3 className="font-display font-semibold text-lg text-obsidian mb-3">
                  {p.title}
                </h3>
                <p className="text-gray-500 text-sm leading-relaxed">
                  {p.description}
                </p>
              </div>
            </FadeIn>
          ))}
        </div>
      </Section>

      {/* ── CTA Inversionistas ───────────────────────────── */}
      <Section background="obsidian">
        <FadeIn>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-20 items-center">
            <div>
              <Eyebrow color="gold">INVERSIONISTAS</Eyebrow>
              <h2 className="font-serif text-3xl md:text-4xl text-bone leading-tight">
                ¿Interesado en el futuro del crédito cooperativo?
              </h2>
              <p className="text-gray-400 mt-5 leading-relaxed">
                Exploramos oportunidades de inversión y alianzas estratégicas
                con fondos, family offices y ángeles inversores alineados con
                nuestra visión.
              </p>
            </div>
            <div className="flex flex-col items-start gap-4">
              <Link
                href="/inversionistas"
                className="inline-flex items-center gap-2 h-12 px-8 rounded-lg bg-gold text-obsidian text-sm font-medium hover:bg-gold-soft transition-colors"
              >
                Ver tesis de inversión
                <ArrowRight className="size-4" />
              </Link>
              <a
                href={`mailto:${siteConfig.investorsEmail}`}
                className="text-sm text-gray-500 hover:text-gold transition-colors"
              >
                {siteConfig.investorsEmail}
              </a>
            </div>
          </div>
        </FadeIn>
      </Section>
    </>
  );
}

function EcosystemCard({ item }: { item: (typeof ecosystem)[number] }) {
  const className =
    "group flex flex-col min-h-[260px] p-7 rounded-xl transition-transform duration-300 hover:-translate-y-1";
  const style = {
    backgroundColor: item.color,
    color: item.textColor,
  };

  const inner = (
    <>
      <div className="flex-1">
        <p className="eyebrow opacity-50 mb-5">{item.label}</p>
        <h3 className="font-serif text-2xl md:text-3xl mb-3">{item.name}</h3>
        <p className="text-sm opacity-70 leading-relaxed">{item.description}</p>
      </div>
      <div className="flex items-center gap-2 text-sm font-medium mt-8 opacity-70 group-hover:opacity-100 transition-opacity">
        <span>{item.external ? "Visitar" : "Conocer más"}</span>
        <ArrowRight className="size-4 group-hover:translate-x-0.5 transition-transform" />
      </div>
    </>
  );

  return item.external ? (
    <a
      href={item.href}
      target="_blank"
      rel="noopener noreferrer"
      className={className}
      style={style}
    >
      {inner}
    </a>
  ) : (
    <Link href={item.href} className={className} style={style}>
      {inner}
    </Link>
  );
}
