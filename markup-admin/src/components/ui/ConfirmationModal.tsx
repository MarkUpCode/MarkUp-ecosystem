import { TriangleAlert } from "lucide-react";
import { Modal } from "./modal";

interface ConfirmationModalProps {

  open: boolean;

  title: string;

  message: string;

  confirmText?: string;

  cancelText?: string;

  loading?: boolean;

  danger?: boolean;

  onConfirm: () => Promise<void> | void;

  onClose: () => void;

}

export function ConfirmationModal({

  open,

  title,

  message,

  confirmText = "Confirmar",

  cancelText = "Cancelar",

  loading = false,

  danger = false,

  onConfirm,

  onClose,

}: ConfirmationModalProps) {

  async function handleConfirm() {

    try {

        await onConfirm();

        onClose();

    } catch {

        // Si ocurre un error, dejamos el modal abierto.
        // El toast mostrará el mensaje correspondiente.

    }

  }

  return (

    <Modal
      open={open}
      title={title}
      onClose={onClose}
    >

      <div className="space-y-8">

        <div className="flex items-start gap-4">

          <div className="rounded-2xl bg-yellow-500/10 p-3">

            <TriangleAlert className="h-6 w-6 text-yellow-400" />

          </div>

          <p className="text-slate-300">

            {message}

          </p>

        </div>

        <div className="flex justify-end gap-3">

          <button
            onClick={onClose}
            className="
              rounded-2xl
              border
              border-white/10
              px-5
              py-3
              text-slate-300
              transition
              hover:bg-white/5
            "
          >
            {cancelText}
          </button>

          <button
            disabled={loading}
            onClick={handleConfirm}
            className={`
              rounded-2xl
              px-5
              py-3
              font-semibold
              transition
              disabled:opacity-50
              ${
                danger
                  ? "bg-red-600 hover:bg-red-500 text-white"
                  : "bg-cyan-500 hover:bg-cyan-400 text-slate-950"
              }
            `}
          >
            {confirmText}
          </button>

        </div>

      </div>

    </Modal>

  );

}