import { cn } from "@/lib/utils";

type Color = "default" | "gold" | "white";

interface EyebrowProps {
  children: React.ReactNode;
  color?: Color;
  className?: string;
}

const colors: Record<Color, string> = {
  default: "text-gray-500",
  gold: "text-gold",
  white: "text-bone/60",
};

export function Eyebrow({ children, color = "default", className }: EyebrowProps) {
  return (
    <span className={cn("eyebrow block mb-4", colors[color], className)}>
      — {children}
    </span>
  );
}
