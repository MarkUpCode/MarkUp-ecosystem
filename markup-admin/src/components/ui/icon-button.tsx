import type { ButtonHTMLAttributes, ReactNode } from "react";

interface IconButtonProps
  extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;

  variant?: "default" | "danger" | "success";
}

export function IconButton({
  children,
  variant = "default",
  className = "",
  ...props
}: IconButtonProps) {
  const variants = {
    default:
      "border-white/10 text-slate-300 hover:bg-white/10",

    danger:
      "border-red-500/20 text-red-300 hover:bg-red-500/10",

    success:
      "border-emerald-500/20 text-emerald-300 hover:bg-emerald-500/10",
  };

  return (
    <button
      {...props}
      className={`
        inline-flex
        h-10
        w-10
        items-center
        justify-center
        rounded-xl
        border
        transition-all
        duration-200
        ${variants[variant]}
        ${className}
      `}
    >
      {children}
    </button>
  );
}