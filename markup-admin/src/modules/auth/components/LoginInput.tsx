import { forwardRef } from "react";
import type { LucideIcon } from "lucide-react";

interface LoginInputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {
  icon: LucideIcon;
  endAdornment?: React.ReactNode;
}

export const LoginInput = forwardRef<HTMLInputElement, LoginInputProps>(
  ({ icon: Icon, endAdornment, className = "", ...props }, ref) => {
    return (
      <div className="relative group">
        <Icon
          className="
            absolute
            left-5
            top-1/2
            h-5
            w-5
            -translate-y-1/2
            text-slate-500
            transition-colors
            duration-300
            group-focus-within:text-cyan-400
          "
        />

        <input
          ref={ref}
          {...props}
          className={`
            h-14
            w-full
            rounded-2xl
            border
            border-white/10
            bg-slate-950/60
            px-14
            text-sm
            text-slate-100
            placeholder:text-slate-500
            outline-none
            transition-all
            duration-300
            hover:border-cyan-500/30
            focus:border-cyan-400
            focus:ring-4
            focus:ring-cyan-500/10
            ${className}
          `}
        />

        {endAdornment && (
          <div className="absolute right-5 top-1/2 -translate-y-1/2">
            {endAdornment}
          </div>
        )}
      </div>
    );
  }
);

LoginInput.displayName = "LoginInput";