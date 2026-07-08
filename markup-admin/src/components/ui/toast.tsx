import { CheckCircle2, AlertCircle, AlertTriangle, Info, X } from "lucide-react";

export type ToastVariant =
  | "success"
  | "error"
  | "warning"
  | "info";

interface ToastProps {

  title: string;

  message?: string;

  variant: ToastVariant;

  onClose: () => void;

}

export function Toast({

  title,

  message,

  variant,

  onClose,

}: ToastProps) {

  const variants = {

    success: {

      icon: CheckCircle2,

      border: "border-emerald-500/30",

      iconColor: "text-emerald-400",

    },

    error: {

      icon: AlertCircle,

      border: "border-red-500/30",

      iconColor: "text-red-400",

    },

    warning: {

      icon: AlertTriangle,

      border: "border-yellow-500/30",

      iconColor: "text-yellow-400",

    },

    info: {

      icon: Info,

      border: "border-cyan-500/30",

      iconColor: "text-cyan-400",

    },

  };

  const current = variants[variant];

  const Icon = current.icon;

  return (

    <div
      className={`
        w-[380px]
        rounded-2xl
        border
        ${current.border}
        bg-slate-900
        shadow-2xl
        backdrop-blur-xl
        animate-in
        slide-in-from-right
        duration-300
      `}
    >

      <div className="flex items-start gap-4 p-5">

        <Icon
          className={`mt-0.5 h-6 w-6 ${current.iconColor}`}
        />

        <div className="flex-1">

          <h3 className="font-semibold text-white">

            {title}

          </h3>

          {message && (

            <p className="mt-1 text-sm text-slate-400">

              {message}

            </p>

          )}

        </div>

        <button
          onClick={onClose}
          className="rounded-lg p-1 text-slate-500 hover:bg-white/10"
        >

          <X className="h-4 w-4"/>

        </button>

      </div>

    </div>

  );

}