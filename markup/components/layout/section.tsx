import { cn } from "@/lib/utils";

type Background = "default" | "bone" | "obsidian";

interface SectionProps {
  children: React.ReactNode;
  background?: Background;
  className?: string;
  id?: string;
}

const bgs: Record<Background, string> = {
  default: "bg-white",
  bone: "bg-bone",
  obsidian: "bg-obsidian",
};

export function Section({ children, background = "default", className, id }: SectionProps) {
  return (
    <section id={id} className={cn("py-20 md:py-28", bgs[background], className)}>
      <div className="max-w-[1200px] mx-auto px-6 lg:px-10">{children}</div>
    </section>
  );
}
