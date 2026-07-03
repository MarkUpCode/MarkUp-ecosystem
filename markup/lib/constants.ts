export const siteConfig = {
  name: "Markup Business",
  description:
    "Holding fintech enfocado en el crédito cooperativo en América Latina.",
  url: "https://markupbusiness.com",
  email: "hola@markupbusiness.com",
  investorsEmail: "invest@markupbusiness.com",
  tagline: "Construimos el futuro del crédito cooperativo",
  social: {
    linkedin: "https://linkedin.com/company/markupbusiness",
    twitter: "https://twitter.com/markupbusiness",
  },
} as const;

export const navigation = [
  { label: "Ecosistema", href: "/ecosistema" },
  { label: "Nosotros", href: "/nosotros" },
  { label: "Inversionistas", href: "/inversionistas" },
  { label: "Insights", href: "/insights" },
] as const;

export const ecosystem = [
  {
    id: "dinerop",
    label: "01 / FINTECH B2C",
    name: "Dinerop",
    description:
      "Consolida solicitudes de crédito entre múltiples cooperativas. Una sola solicitud, múltiples opciones.",
    href: "https://www.dinerop.com",
    external: true,
    color: "#4338CA",
    textColor: "#FFFFFF",
  },
  {
    id: "waki",
    label: "02 / RED B2B",
    name: "Waki",
    description:
      "Red colaborativa para cooperativas. Integración de servicios, datos compartidos y sinergia institucional.",
    href: "/ecosistema/waki",
    external: false,
    color: "#0E5E6F",
    textColor: "#FFFFFF",
  },
  {
    id: "markup-digital",
    label: "03 / CONSULTORÍA",
    name: "Markup Digital",
    description:
      "Consultoría estratégica en transformación digital para el sector financiero y cooperativo.",
    href: "/markup-digital",
    external: false,
    color: "#0F1419",
    textColor: "#FFFFFF",
  },
] as const;

export const metrics = [
  { value: "+40", label: "COOPERATIVAS ALIADAS" },
  { value: "2.020+", label: "USUARIOS ACTIVOS" },
  { value: "3", label: "PRODUCTOS EN EL ECOSISTEMA" },
] as const;

export const pillars = [
  {
    number: "01",
    title: "Tecnología propia",
    description:
      "Desarrollamos nuestras plataformas de principio a fin, con arquitectura escalable.",
  },
  {
    number: "02",
    title: "Enfoque cooperativo",
    description:
      "No reemplazamos cooperativas, las potenciamos con herramientas digitales.",
  },
  {
    number: "03",
    title: "Escala regional",
    description:
      "Diseñado para crecer desde Ecuador hacia toda América Latina.",
  },
] as const;
