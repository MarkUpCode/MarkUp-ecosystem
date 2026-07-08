import {
  createContext,
  useCallback,
  useMemo,
  useState,
  type ReactNode,
} from "react";

import { Toast, type ToastVariant } from "@/components/ui/toast";

interface ToastItem {

  id: number;

  title: string;

  message?: string;

  variant: ToastVariant;

}

interface ToastContextValue {

  success: (title: string, message?: string) => void;

  error: (title: string, message?: string) => void;

  warning: (title: string, message?: string) => void;

  info: (title: string, message?: string) => void;

}

export const ToastContext =
  createContext<ToastContextValue | null>(null);

export function ToastProvider({
  children,
}: {
  children: ReactNode;
}) {

  const [toasts, setToasts] =
    useState<ToastItem[]>([]);

  const removeToast = useCallback((id: number) => {

    setToasts((current) =>
      current.filter((toast) => toast.id !== id)
    );

  }, []);

  const showToast = useCallback(

    (
      variant: ToastVariant,
      title: string,
      message?: string
    ) => {

      const id = Date.now();

      setToasts((current) => [

        ...current,

        {

          id,

          variant,

          title,

          message,

        },

      ]);

      setTimeout(() => {

        removeToast(id);

      }, 4000);

    },

    [removeToast]

  );

  const value = useMemo(
    () => ({

      success: (title: string, message?: string) =>
        showToast("success", title, message),

      error: (title: string, message?: string) =>
        showToast("error", title, message),

      warning: (title: string, message?: string) =>
        showToast("warning", title, message),

      info: (title: string, message?: string) =>
        showToast("info", title, message),

    }),
    [showToast]
  );

  return (

    <ToastContext.Provider value={value}>

      {children}

      <div className="fixed right-6 top-6 z-[9999] flex flex-col gap-3">

        {toasts.map((toast) => (

          <Toast
            key={toast.id}
            title={toast.title}
            message={toast.message}
            variant={toast.variant}
            onClose={() => removeToast(toast.id)}
          />

        ))}

      </div>

    </ToastContext.Provider>

  );

}