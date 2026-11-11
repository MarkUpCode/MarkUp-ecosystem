import AlianzaDelValle from "../../images/cooperatives/AlianzaDelValle.png";
import Tulcan from "../../images/cooperatives/Tulcan.png";
import UnionElEjido from "../../images/cooperatives/UnionElEjido.png";

const cooperatives = [
  { name: "Alianza del Valle", logo: AlianzaDelValle },
  { name: "Tulcán", logo: Tulcan },
  { name: "Unión El Ejido", logo: UnionElEjido },
];

export default function CooperativeLogoMarquee() {
  return (
    <section
      aria-label="Cooperativas aliadas"
      className="mb-8 overflow-hidden rounded-2xl border border-slate-200/80 bg-white/80 py-3 shadow-sm"
    >
      <div className="mb-2 px-4 text-center text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400">
        Cooperativas aliadas
      </div>
      <div className="relative overflow-hidden">
        <div className="cooperative-logo-track flex w-max items-center">
          {[...cooperatives, ...cooperatives].map((cooperative, index) => (
            <div
              key={`${cooperative.name}-${index}`}
              className="mx-2 flex h-16 w-44 shrink-0 items-center justify-center rounded-xl border border-slate-100 bg-slate-50/80 px-4 sm:mx-3 sm:w-52"
            >
              <img
                src={cooperative.logo}
                alt={cooperative.name}
                className="max-h-12 w-full object-contain"
              />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
