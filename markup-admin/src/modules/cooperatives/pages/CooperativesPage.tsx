import { useState, type FormEvent } from "react";
import { useNavigate } from "react-router-dom";
import { Building2 } from "lucide-react";
import { PageHeader } from "@/components/ui/PageHeader";
import { Pagination } from "@/components/ui/Pagination";
import { getCooperativeById } from "../api/cooperatives.api";
import { CooperativesFilters } from "../components/CooperativesFilters";
import { CooperativesStats } from "../components/CooperativesStats";
import { CooperativesTable } from "../components/CooperativesTable";
import { CooperativeWizard } from "../components/CooperativeWizard";
import { useCooperatives } from "../hooks/useCooperatives";
import type { Cooperative, CooperativeListItem } from "../types/cooperative";

export function CooperativesPage() {
  const navigate = useNavigate();
  const [createOpen, setCreateOpen] = useState(false);
  const [selected, setSelected] = useState<Cooperative | null>(null);
  const [error, setError] = useState("");
  const { cooperatives, loading, page, size, totalPages, totalElements, setPage, search, city, province, setSearch, setCity, setProvince, reload, create, update, remove } = useCooperatives();

  async function openEdit(item: CooperativeListItem) {
    setError("");
    try { setSelected(await getCooperativeById(item.id)); }
    catch { setError("No se pudo cargar el detalle de la cooperativa."); }
  }

  async function saveEdit(event: FormEvent) {
    event.preventDefault();
    if (!selected) return;
    try {
      await update(selected.id, { nombre: selected.nombre, ciudad: selected.ciudad, provincia: selected.provincia, direccion: selected.direccion ?? "", telefono: selected.telefono ?? "", paginaWeb: selected.paginaWeb ?? "", logoUrl: selected.logoUrl ?? "", calificacion: selected.calificacion, montoMaximoCredito: selected.montoMaximoCredito });
      setSelected(null);
    } catch { setError("No se pudieron guardar los cambios."); }
  }

  const fields = [["nombre", "Nombre"], ["ciudad", "Ciudad"], ["provincia", "Provincia"], ["direccion", "Dirección"], ["telefono", "Teléfono"], ["paginaWeb", "Página web"], ["logoUrl", "URL del logo"]] as const;

  return <div className="space-y-6">
    <PageHeader title="Cooperativas" subtitle="Administra las entidades, sus usuarios y productos financieros." icon={<Building2 size={30} />} actionLabel="Nueva cooperativa" onAction={() => setCreateOpen(true)} />
    <CooperativesStats total={cooperatives.length} averageRating={cooperatives.length ? cooperatives.reduce((sum, item) => sum + item.calificacion, 0) / cooperatives.length : 0} highestCredit={cooperatives.length ? Math.max(...cooperatives.map((item) => item.montoMaximoCredito)) : 0} cities={new Set(cooperatives.map((item) => item.ciudad)).size} />
    <CooperativesFilters search={search} city={city} province={province} onSearchChange={setSearch} onCityChange={setCity} onProvinceChange={setProvince} onReload={reload} />
    {error && !selected && <p className="rounded-xl bg-red-500/10 p-3 text-sm text-red-200">{error}</p>}
    {loading ? <div className="rounded-3xl border border-white/10 bg-slate-900 p-20 text-center">Cargando cooperativas…</div> : <CooperativesTable cooperatives={cooperatives} onEdit={(item) => void openEdit(item)} onView={(item) => navigate(`/productos?cooperativeId=${item.id}`)} onDelete={(item) => { if (window.confirm(`¿Eliminar la cooperativa ${item.nombre}?`)) void remove(item.id); }} />}
    <Pagination page={page} size={size} totalPages={totalPages} totalElements={totalElements} onPageChange={setPage} />
    <CooperativeWizard open={createOpen} onClose={() => setCreateOpen(false)} onCreate={create} />
    {selected && <div className="fixed inset-0 z-50 grid place-items-center overflow-y-auto bg-black/70 p-4"><form onSubmit={saveEdit} className="my-6 max-h-[90vh] w-full max-w-2xl overflow-y-auto rounded-3xl border border-white/10 bg-slate-900 p-6"><h2 className="text-xl font-bold text-white">Editar cooperativa</h2><div className="mt-5 grid gap-4 sm:grid-cols-2">{fields.map(([key, label]) => <label key={key} className="text-sm text-slate-300">{label}<input required={key === "nombre" || key === "ciudad" || key === "provincia"} className="mt-1 w-full rounded-xl border border-white/10 bg-slate-950 px-3 py-2.5 text-white" value={selected[key] ?? ""} onChange={(event) => setSelected((current) => current ? { ...current, [key]: event.target.value } : current)} /></label>)}<label className="text-sm text-slate-300">Calificación<input type="number" min="0" max="5" step="0.1" className="mt-1 w-full rounded-xl border border-white/10 bg-slate-950 px-3 py-2.5 text-white" value={selected.calificacion ?? ""} onChange={(event) => setSelected((current) => current ? { ...current, calificacion: event.target.value ? Number(event.target.value) : null } : current)} /></label><label className="text-sm text-slate-300">Monto máximo legado<input type="number" min="0" step="0.01" className="mt-1 w-full rounded-xl border border-white/10 bg-slate-950 px-3 py-2.5 text-white" value={selected.montoMaximoCredito} onChange={(event) => setSelected((current) => current ? { ...current, montoMaximoCredito: Number(event.target.value) } : current)} /></label></div>{error && <p className="mt-4 text-sm text-red-300">{error}</p>}<div className="mt-6 flex justify-end gap-3"><button type="button" onClick={() => { setSelected(null); setError(""); }} className="rounded-xl border border-white/10 px-4 py-2 text-slate-300">Cancelar</button><button className="rounded-xl bg-cyan-400 px-5 py-2 font-semibold text-slate-950">Guardar</button></div></form></div>}
  </div>;
}
