import { ReactNode } from "react";
import { X } from "lucide-react";

interface ModalProps {
  open: boolean;
  title: string;
  description?: string;
  children: ReactNode;
  onClose: () => void;
}

export function Modal({
  open,
  title,
  description,
  children,
  onClose,
}: ModalProps) {

  if (!open) return null;

  return (

    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm">

      <div className="relative w-full max-w-lg rounded-3xl border border-white/10 bg-slate-900 shadow-2xl">

        <button
          onClick={onClose}
          className="absolute right-5 top-5 rounded-xl p-2 text-slate-400 transition hover:bg-white/10 hover:text-white"
        >
          <X className="h-5 w-5" />
        </button>

        <div className="border-b border-white/10 px-8 py-6">

          <h2 className="text-2xl font-bold text-white">

            {title}

          </h2>

          {description && (

            <p className="mt-2 text-sm text-slate-400">

              {description}

            </p>

          )}

        </div>

        <div className="p-8">

          {children}

        </div>

      </div>

    </div>

  );

}