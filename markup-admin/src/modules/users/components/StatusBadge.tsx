import { Circle } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import type { UserStatus } from "../types/user";

interface StatusBadgeProps {
  status: UserStatus;
}

export function StatusBadge({
  status,
}: StatusBadgeProps) {
  switch (status) {
    case "ACTIVE":
      return (
        <Badge variant="success">
          <Circle className="mr-1.5 h-2.5 w-2.5 fill-current" />
          Activo
        </Badge>
      );

    case "DISABLED":
      return (
        <Badge variant="danger">
          <Circle className="mr-1.5 h-2.5 w-2.5 fill-current" />
          Deshabilitado
        </Badge>
      );

    case "PENDING_ACTIVATION":
      return (
        <Badge variant="warning">
          <Circle className="mr-1.5 h-2.5 w-2.5 fill-current" />
          Pendiente
        </Badge>
      );

    default:
      return <Badge>{status}</Badge>;
  }
}