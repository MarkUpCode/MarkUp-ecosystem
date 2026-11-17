import { useState } from "react";

import { UsersTable } from "../components/UsersTable";

import { useUsers } from "../hooks/useUsers";
import { resendInvitation, revokeInvitation } from "../api/users.api";
import { useToast } from "@/hooks/useToast";
import { UsersStats } from "../components/UsersStats";
import { UsersFilters } from "../components/UsersFilters";
import { InviteUserModal } from "../components/InviteUserModal";
import { ConfirmationModal } from "@/components/ui/ConfirmationModal";
import type { UserListItem } from "../types/user";
import { Pagination } from "@/components/ui/Pagination";
import { Users } from "lucide-react";
import { PageHeader } from "@/components/ui/PageHeader";


export function UsersPage() {
  const toast = useToast();

  const [inviteOpen, setInviteOpen] = useState(false);

  const [selectedUser, setSelectedUser] =
  useState<UserListItem | null>(null);

  const [confirmOpen, setConfirmOpen] =
  useState(false);
  
  const {

      users,

      loading,

      createUser,

      search,

      role,

      status,

      setSearch,

      setRole,

      setStatus,

      reload,
      
      updateStatus,

      page,

      size,

      totalPages,

      totalElements,

      setPage,

      stats,


  } = useUsers();

  async function manageInvitation(id: number, action: "resend" | "revoke") {
    try {
      if (action === "resend") await resendInvitation(id);
      else await revokeInvitation(id);
      toast.success(action === "resend" ? "Invitación reenviada" : "Invitación revocada", "El cambio se guardó correctamente.");
      await reload();
    } catch {
      toast.error("No se pudo actualizar la invitación", "Inténtalo nuevamente.");
    }
  }

  function handleToggleStatus(user: UserListItem) {

    setSelectedUser(user);

    setConfirmOpen(true);

  }

  return (

    <div>

      <PageHeader

            title="Usuarios"

            subtitle="Administración de usuarios del sistema."

            icon={<Users size={30}/>}

            actionLabel="Invitar usuario"

            onAction={() => setInviteOpen(true)}

        />

      <UsersStats
          total={stats.total}
          active={stats.active}
          pending={stats.pending}
          disabled={stats.disabled}
      />

      <UsersFilters
          search={search}
          role={role}
          status={status}
          onSearchChange={setSearch}
          onRoleChange={setRole}
          onStatusChange={setStatus}
          onReload={reload}
      />

      {loading ? (

        <div className="rounded-3xl border border-white/10 bg-slate-900 p-20 text-center">

          Cargando usuarios...

        </div>

      ) : (

        <UsersTable
            users={users}
            onToggleStatus={handleToggleStatus}
            onResendInvitation={(user) => void manageInvitation(user.id, "resend")}
            onRevokeInvitation={(user) => void manageInvitation(user.id, "revoke")}
            
        />

        

      )}
      
      <Pagination
          page={page}
          size={size}
          totalPages={totalPages}
          totalElements={totalElements}
          onPageChange={setPage}
      />

      <InviteUserModal

          open={inviteOpen}

          loading={loading}

          onClose={() => setInviteOpen(false)}

          onSubmit={createUser}

      />
      <ConfirmationModal
        open={confirmOpen}
        title={
            selectedUser?.active
                ? "Deshabilitar usuario"
                : "Habilitar usuario"
        }
        message={
            selectedUser?.active
                ? `¿Está seguro de deshabilitar a ${selectedUser.email}?`
                : `¿Está seguro de habilitar a ${selectedUser?.email}?`
        }
        danger={selectedUser?.active}
        confirmText={
            selectedUser?.active
                ? "Deshabilitar"
                : "Habilitar"
        }
        onClose={() => {
            setConfirmOpen(false);
            setSelectedUser(null);
        }}
        onConfirm={async () => {

            if (!selectedUser) return;

            await updateStatus(

                selectedUser.id,

                !selectedUser.active

            );

        }}
    />

    </div>

  );

}
