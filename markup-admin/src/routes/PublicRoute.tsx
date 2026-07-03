import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "@/contexts/useAuth";
import { isAdminRole } from "@/types/auth";

export function PublicRoute() {
  const { isAuthenticated, isLoading } = useAuth();

  if (isLoading) {
    return <div className="min-h-screen grid place-items-center">Cargando...</div>;
  }

  if (isAuthenticated) {
    return isAdminRole(useAuth().user?.role)
      ? <Navigate to="/dashboard" replace />
      : <Navigate to="/login" replace />;
  }

  return <Outlet />;
}
