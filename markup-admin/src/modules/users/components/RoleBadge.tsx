import { ShieldCheck, User, Building2 } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import type { UserRole } from "../types/user";

interface RoleBadgeProps {
  role: UserRole;
}

export function RoleBadge({ role }: RoleBadgeProps) {
  switch (role) {
    case "ADMIN":
      return (
        <Badge>
          <ShieldCheck className="mr-1.5 h-3.5 w-3.5" />
          Administrador
        </Badge>
      );

    case "CLIENT":
      return (
        <Badge>
          <User className="mr-1.5 h-3.5 w-3.5" />
          Cliente
        </Badge>
      );

    case "COOPERATIVE":
      return (
        <Badge>
          <Building2 className="mr-1.5 h-3.5 w-3.5" />
          Cooperativa
        </Badge>
      );

    default:
      return <Badge>{role}</Badge>;
  }
}