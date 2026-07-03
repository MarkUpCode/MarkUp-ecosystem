import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { Section } from "@/components/layout/section";
import { Eyebrow } from "@/components/ui/eyebrow";
import { FadeIn } from "@/components/animations/fade-in";

const featured = {
  category: "Editorial",
  title:
    "Markup Business: construyendo el sistema financiero del futuro cooperativo",
  excerpt:
    "Una mirada profunda a cómo el holding transforma el acceso al crédito en América Latina mediante tres productos complementarios y una visión unificada del ecosistema cooperativo digital.",
  author: "Equipo Editorial",
  date: "Abril 2026",
  readTime: "12 min lectura",
};

const articles = [
  {
    category: "Análisis",
    title:
      "El cooperativismo como columna del crédito inclusivo en LATAM",
    excerpt:
      "Las cooperativas representan el 30% de la penetración financiera en comunidades rurales. ¿Por qué su modelo es el más resiliente del sector?",
    author: "Equipo Markup",
    date: "Marzo 2026",
    accentColor: "#0F1419",
  },
  {
    category: "Tecnología",
    title: "Por qué las cooperativas no pueden esperar más para digitalizarse",
    excerpt:
      "La brecha tecnológica entre bancos y cooperativas se amplía cada año. Los datos son contundentes y las consecuencias, costosas.",
    author: "Equipo Markup",
    date: "Febrero 2026",
    accentColor: "#4338CA",
  },
  {
    category: "Regulación",
    title: "Marco regulatorio fintech en Ecuador: guía para cooperativas 2026",
    excerpt:
      "La SEPS actualiza su normativa. Lo que cada directivo cooperativo necesita saber para mantener el cumplimiento en la era digital.",
    author: "Equipo Markup",
    date: "Enero 2026",
    accentColor: "#0E5E6F",
  },
  {
    category: "Producto",
    title: "Una sola solicitud, cuarenta cooperativas: la promesa de Dinerop",
    excerpt:
      "Cómo la consolidación de solicitudes de crédito elimina fricciones y democratiza el acceso a las mejores condiciones del mercado.",
    author: "Equipo Markup",
    date: "Diciembre 2025",
    accentColor: "#B8935A",
  },
  {
    category: "Inversión",
    title: "La tesis del crédito cooperativo digital: por qué invertir ahora",
    excerpt:
      "El mercado mueve +$200B anuales y permanece no digitalizado. Un análisis de la oportunidad y del timing de mercado en LATAM.",
    author: "Equipo Markup",
    date: "Noviembre 2025",
    accentColor: "#1F2937",
  },
  {
    category: "Ecosistema",
    title: "Waki: cómo la colaboración entre cooperativas genera valor sistémico",
    excerpt:
      "Más allá de la digitalización individual, el modelo de red propone un nuevo paradigma de sinergia institucional en el sector.",
    author: "Equipo Markup",
    date: "Octubre 2025",
    accentColor: "#374151",
  },
];

export default function InsightsPage() {
  return (
    <>
      {/* Hero */}
      <Section background="bone" className="pb-16">
        <FadeIn>
          <Eyebrow>INSIGHTS</Eyebrow>
          <h1 className="font-serif text-4xl md:text-5xl lg:text-6xl text-obsidian leading-tight max-w-3xl mb-6">
            Ideas sobre el futuro del crédito cooperativo.
          </h1>
          <p className="text-gray-500 text-lg max-w-xl leading-relaxed">
            Análisis, perspectivas y reflexiones del equipo Markup sobre
            fintech, cooperativismo, regulación e inclusión financiera en
            América Latina.
          </p>
        </FadeIn>
      </Section>

      {/* Artículo destacado */}
      <Section background="default" className="pt-0">
        <FadeIn>
          <div className="rounded-2xl overflow-hidden border border-bone-dark flex flex-col md:flex-row min-h-[320px]">
            {/* Visual block */}
            <div className="md:w-2/5 min-h-[200px] bg-obsidian flex flex-col items-start justify-end p-8 shrink-0">
              <span className="eyebrow text-gold mb-3">{featured.category}</span>
              <p className="font-serif text-3xl text-bone leading-tight">
                {featured.readTime}
              </p>
            </div>
            {/* Content */}
            <div className="flex-1 p-8 md:p-10 flex flex-col justify-between">
              <div>
                <span className="eyebrow text-gray-400 mb-4 block">
                  Artículo destacado
                </span>
                <h2 className="font-serif text-2xl md:text-3xl text-obsidian leading-tight mb-4">
                  {featured.title}
                </h2>
                <p className="text-gray-500 leading-relaxed text-sm max-w-lg">
                  {featured.excerpt}
                </p>
              </div>
              <div className="flex items-center justify-between mt-8 pt-6 border-t border-bone-dark">
                <div>
                  <p className="text-sm font-medium text-obsidian">
                    {featured.author}
                  </p>
                  <p className="text-xs text-gray-400">{featured.date}</p>
                </div>
                <span className="inline-flex items-center gap-1.5 text-sm font-medium text-obsidian hover:text-gold transition-colors cursor-pointer">
                  Leer artículo
                  <ArrowRight className="size-4" />
                </span>
              </div>
            </div>
          </div>
        </FadeIn>
      </Section>

      {/* Grid de artículos */}
      <Section background="bone">
        <FadeIn>
          <div className="mb-10">
            <Eyebrow>ÚLTIMOS ARTÍCULOS</Eyebrow>
            <h2 className="font-serif text-2xl md:text-3xl text-obsidian leading-tight">
              Perspectivas recientes.
            </h2>
          </div>
        </FadeIn>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {articles.map((article, i) => (
            <FadeIn key={article.title} delay={i * 0.06}>
              <article className="bg-white border border-bone-dark rounded-xl overflow-hidden flex flex-col h-full">
                {/* Placeholder visual */}
                <div
                  className="h-44 w-full shrink-0"
                  style={{ backgroundColor: article.accentColor }}
                />
                {/* Content */}
                <div className="p-6 flex flex-col flex-1">
                  <span className="eyebrow text-gray-400 mb-3">
                    {article.category}
                  </span>
                  <h3 className="font-serif text-lg text-obsidian leading-tight mb-3 line-clamp-2">
                    {article.title}
                  </h3>
                  <p className="text-gray-500 text-sm leading-relaxed flex-1 line-clamp-3">
                    {article.excerpt}
                  </p>
                  <div className="flex items-center justify-between mt-6 pt-4 border-t border-bone-dark">
                    <div>
                      <p className="text-xs font-medium text-gray-600">
                        {article.author}
                      </p>
                      <p className="text-xs text-gray-400">{article.date}</p>
                    </div>
                    <ArrowRight className="size-4 text-gray-300" />
                  </div>
                </div>
              </article>
            </FadeIn>
          ))}
        </div>

        {/* CTA */}
        <FadeIn>
          <div className="mt-12 text-center">
            <button
              type="button"
              className="inline-flex items-center gap-2 h-11 px-8 rounded-lg border border-obsidian/20 text-obsidian text-sm font-medium hover:bg-obsidian/5 transition-colors"
            >
              Ver todos los artículos
              <ArrowRight className="size-4" />
            </button>
          </div>
        </FadeIn>
      </Section>
    </>
  );
}
