import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "@/contexts/useAuth";
import { isAdminRole } from "@/types/auth";

export function ProtectedRoute() {
  const { isAuthenticated, isLoading, user } = useAuth();

  if (isLoading) {
    return <div className="min-h-screen grid place-items-center">Cargando...</div>;
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  if (!isAdminRole(user?.role)) {
    return <Navigate to="/login" replace />;
  }

  return <Outlet />;
}
