import { useCallback, useEffect, useRef, useState } from "react";
import { getMyCooperativeRequests } from "../api/creditRequests.api";
import type { CooperativeCreditRequest } from "../types/credit";

const POLL_INTERVAL_MS = 15_000;
const MAX_NOTIFICATIONS = 50;

export type CooperativeNotification = {
  id: string;
  requestId: number;
  title: string;
  message: string;
  createdAt: number;
  read: boolean;
};

function describeRequestChange(
  previous: CooperativeCreditRequest | undefined,
  current: CooperativeCreditRequest,
): Omit<CooperativeNotification, "id" | "createdAt" | "read"> | null {
  if (!previous) {
    return {
      requestId: current.solicitudId,
      title: "Nueva solicitud de crédito",
      message: `${current.nombreSolicitante || "Un solicitante"} envió una solicitud${current.montoSolicitado != null ? ` por $${current.montoSolicitado.toLocaleString("es-EC")}` : ""}.`,
    };
  }

  if (previous.estado !== current.estado) {
    return {
      requestId: current.solicitudId,
      title: "Solicitud actualizada",
      message: `La solicitud #${current.solicitudId} cambió a ${current.estado.replace(/_/g, " ").toLowerCase()}.`,
    };
  }

  if (JSON.stringify(previous) !== JSON.stringify(current)) {
    return {
      requestId: current.solicitudId,
      title: "Datos de solicitud actualizados",
      message: `Se actualizaron los datos de la solicitud #${current.solicitudId}.`,
    };
  }

  return null;
}

export function useCooperativeLiveUpdates() {
  const [requests, setRequests] = useState<CooperativeCreditRequest[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [connectionError, setConnectionError] = useState(false);
  const [lastUpdatedAt, setLastUpdatedAt] = useState<number | null>(null);
  const [notifications, setNotifications] = useState<CooperativeNotification[]>([]);
  const previousRequests = useRef<Map<number, CooperativeCreditRequest> | null>(null);
  const notificationSequence = useRef(0);
  const refreshInProgress = useRef(false);

  const refresh = useCallback(async () => {
    if (refreshInProgress.current) return;
    refreshInProgress.current = true;
    try {
      const nextRequests = await getMyCooperativeRequests();
      const currentById = new Map(nextRequests.map((request) => [request.solicitudId, request]));
      const previousById = previousRequests.current;

      if (previousById) {
        const detected = nextRequests
          .map((request) => describeRequestChange(previousById.get(request.solicitudId), request))
          .filter((change): change is NonNullable<typeof change> => change !== null)
          .map((change) => ({
            ...change,
            id: `${Date.now()}-${notificationSequence.current++}`,
            createdAt: Date.now(),
            read: false,
          }));

        for (const previousRequest of previousById.values()) {
          if (!currentById.has(previousRequest.solicitudId)) {
            detected.push({
              id: `${Date.now()}-${notificationSequence.current++}`,
              requestId: previousRequest.solicitudId,
              title: "Solicitud actualizada",
              message: `La solicitud #${previousRequest.solicitudId} ya no aparece en la bandeja de la cooperativa.`,
              createdAt: Date.now(),
              read: false,
            });
          }
        }

        if (detected.length) {
          setNotifications((current) => [...detected, ...current].slice(0, MAX_NOTIFICATIONS));
        }
      }

      previousRequests.current = currentById;
      setRequests(nextRequests);
      setConnectionError(false);
      setLastUpdatedAt(Date.now());
    } catch {
      setConnectionError(true);
    } finally {
      refreshInProgress.current = false;
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    void refresh();

    const interval = window.setInterval(() => {
      if (!document.hidden) void refresh();
    }, POLL_INTERVAL_MS);

    const onVisibilityChange = () => {
      if (!document.hidden) void refresh();
    };

    document.addEventListener("visibilitychange", onVisibilityChange);
    return () => {
      window.clearInterval(interval);
      document.removeEventListener("visibilitychange", onVisibilityChange);
    };
  }, [refresh]);

  const markRead = useCallback((id: string) => {
    setNotifications((current) => current.map((item) => item.id === id ? { ...item, read: true } : item));
  }, []);

  const markAllRead = useCallback(() => {
    setNotifications((current) => current.map((item) => ({ ...item, read: true })));
  }, []);

  const unreadCount = notifications.reduce((total, item) => total + Number(!item.read), 0);

  return { requests, isLoading, connectionError, lastUpdatedAt, notifications, unreadCount, markRead, markAllRead, refresh };
}
