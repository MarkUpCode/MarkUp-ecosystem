import type { ReactNode } from "react";

interface PageHeaderProps {

  title: string;

  subtitle: string;

  icon: ReactNode;

  actionLabel?: string;

  onAction?: () => void;

}

export function PageHeader({

  title,

  subtitle,

  icon,

  actionLabel,

  onAction,

}: PageHeaderProps) {

  return (

    <div className="flex items-center justify-between">

      <div>

        <h1 className="flex items-center gap-3 text-3xl font-bold text-white">

          <span className="text-cyan-400">

            {icon}

          </span>

          {title}

        </h1>

        <p className="mt-2 text-slate-400">

          {subtitle}

        </p>

      </div>

      {actionLabel && onAction && (

        <button
          onClick={onAction}
          className="
            flex
            items-center
            gap-2
            rounded-2xl
            bg-cyan-500
            px-5
            py-3
            font-semibold
            text-slate-950
            transition
            hover:bg-cyan-400
          "
        >

          {actionLabel}

        </button>

      )}

    </div>

  );

}