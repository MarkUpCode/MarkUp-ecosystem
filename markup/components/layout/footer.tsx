import Link from "next/link";
import { Separator } from "@/components/ui/separator";
import { siteConfig, navigation, ecosystem } from "@/lib/constants";

export function Footer() {
  return (
    <footer className="bg-obsidian-dark pt-16 pb-8">
      <div className="max-w-[1200px] mx-auto px-6 lg:px-10">
        {/* Columns */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-10 mb-14">
          {/* Brand */}
          <div className="col-span-2 md:col-span-1">
            <Link href="/" className="inline-flex items-baseline gap-1.5 mb-5">
              <span className="font-display text-base font-semibold text-bone">
                Markup
              </span>
              <span className="font-serif text-base italic text-gold">
                Business
              </span>
            </Link>
            <p className="text-sm text-gray-600 leading-relaxed max-w-[180px]">
              {siteConfig.description}
            </p>
          </div>

          {/* Ecosistema */}
          <div>
            <p className="eyebrow text-gray-700 mb-5">Ecosistema</p>
            <ul className="space-y-3">
              {ecosystem.map((item) =>
                item.external ? (
                  <li key={item.id}>
                    <a
                      href={item.href}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-sm text-gray-500 hover:text-gray-300 transition-colors"
                    >
                      {item.name}
                    </a>
                  </li>
                ) : (
                  <li key={item.id}>
                    <Link
                      href={item.href}
                      className="text-sm text-gray-500 hover:text-gray-300 transition-colors"
                    >
                      {item.name}
                    </Link>
                  </li>
                )
              )}
            </ul>
          </div>

          {/* Empresa */}
          <div>
            <p className="eyebrow text-gray-700 mb-5">Empresa</p>
            <ul className="space-y-3">
              {navigation.map((item) => (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    className="text-sm text-gray-500 hover:text-gray-300 transition-colors"
                  >
                    {item.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Contacto */}
          <div>
            <p className="eyebrow text-gray-700 mb-5">Contacto</p>
            <ul className="space-y-3">
              <li>
                <a
                  href={`mailto:${siteConfig.email}`}
                  className="text-sm text-gray-500 hover:text-gray-300 transition-colors"
                >
                  {siteConfig.email}
                </a>
              </li>
              <li>
                <a
                  href={`mailto:${siteConfig.investorsEmail}`}
                  className="text-sm text-gray-500 hover:text-gray-300 transition-colors"
                >
                  {siteConfig.investorsEmail}
                </a>
              </li>
              <li>
                <a
                  href={siteConfig.social.linkedin}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-sm text-gray-500 hover:text-gray-300 transition-colors"
                >
                  LinkedIn
                </a>
              </li>
              <li>
                <a
                  href={siteConfig.social.twitter}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-sm text-gray-500 hover:text-gray-300 transition-colors"
                >
                  X (Twitter)
                </a>
              </li>
            </ul>
          </div>
        </div>

        <Separator className="bg-white/5 mb-6" />

        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2">
          <p className="text-xs text-gray-700">
            © {new Date().getFullYear()} {siteConfig.name}. Todos los derechos
            reservados.
          </p>
          <p className="text-xs text-gray-700">Ecuador · América Latina</p>
        </div>
      </div>
    </footer>
  );
}
