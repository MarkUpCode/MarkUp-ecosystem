import { api } from "@/services/axios";

export interface DashboardData {
  users: { total: number; clients: number; cooperatives: number; admins: number };
  cooperatives: { total: number };
  credits: { total: number; created: number; sent: number };
  visits: { total: number };
  recentUsers: Array<{ id: number; email: string; role: string; status: string; createdAt: string }>;
  recentCredits: Array<{ id: number; email: string; amount: number; status: string; fechaSolicitud: string }>;
}

export async function getDashboard(): Promise<DashboardData> {
  const { data } = await api.get<DashboardData>("/api/admin/dashboard");
  return data;
}
