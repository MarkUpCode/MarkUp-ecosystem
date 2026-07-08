interface BadgeProps {
  children: React.ReactNode;
  variant?:
    | "default"
    | "success"
    | "danger"
    | "warning"
    | "info";
}

export function Badge({
  children,
  variant = "default",
}: BadgeProps) {

  const variants = {

    default:
      "bg-slate-700 text-slate-200",

    success:
      "bg-emerald-500/15 text-emerald-300",

    danger:
      "bg-red-500/15 text-red-300",

    warning:
      "bg-yellow-500/15 text-yellow-300",

    info:
      "bg-cyan-500/15 text-cyan-300",

  };

  return (

    <span
      className={`
      inline-flex
      items-center
      rounded-full
      px-3
      py-1
      text-xs
      font-semibold
      ${variants[variant]}
      `}
    >
      {children}
    </span>

  );

}