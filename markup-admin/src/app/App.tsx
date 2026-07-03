import { Navigate, Route, Routes } from "react-router-dom";
import { MainLayout } from "@/layouts/MainLayout";
import { ProtectedRoute } from "@/routes/ProtectedRoute";
import { PublicRoute } from "@/routes/PublicRoute";
import { LoginPage } from "@/modules/auth/pages/LoginPage";
import { DashboardPage } from "@/modules/dashboard/pages/DashboardPage";
import { CooperativesPage } from "@/modules/cooperatives/pages/CooperativesPage";
import { UsersPage } from "@/modules/users/pages/UsersPage";
import { RequestsPage } from "@/modules/requests/pages/RequestsPage";
import { LeadsPage } from "@/modules/leads/pages/LeadsPage";
import { ProductsPage } from "@/modules/products/pages/ProductsPage";
import { ReportsPage } from "@/modules/reports/pages/ReportsPage";
import { StatisticsPage } from "@/modules/statistics/pages/StatisticsPage";
import { SettingsPage } from "@/modules/settings/pages/SettingsPage";
import { ProfilePage } from "@/modules/profile/pages/ProfilePage";

export default function App() {
  return (
    <Routes>
      <Route element={<PublicRoute />}>
        <Route path="/login" element={<LoginPage />} />
      </Route>

      <Route element={<ProtectedRoute />}>
        <Route element={<MainLayout />}>
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/cooperativas" element={<CooperativesPage />} />
          <Route path="/usuarios" element={<UsersPage />} />
          <Route path="/solicitudes" element={<RequestsPage />} />
          <Route path="/leads" element={<LeadsPage />} />
          <Route path="/productos" element={<ProductsPage />} />
          <Route path="/reportes" element={<ReportsPage />} />
          <Route path="/estadisticas" element={<StatisticsPage />} />
          <Route path="/configuracion" element={<SettingsPage />} />
          <Route path="/perfil" element={<ProfilePage />} />
        </Route>
      </Route>
    </Routes>
  );
}
