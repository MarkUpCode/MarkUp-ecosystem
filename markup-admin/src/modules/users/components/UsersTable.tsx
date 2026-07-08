import type { UserListItem } from "../types/user";
import { RoleBadge } from "./RoleBadge";
import { StatusBadge } from "./StatusBadge";
import { UserActions } from "@/components/ui/UserActions";
import { UserAvatar } from "@/components/ui/UserAvatar";


interface UsersTableProps {
  users: UserListItem[];
}

export function UsersTable({
  users,
}: UsersTableProps) {
  return (
    <div className="overflow-hidden rounded-3xl border border-white/10 bg-slate-900">

      <table className="w-full">

        <thead className="border-b border-white/10 bg-slate-950">

          <tr>

            <th className="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider text-slate-400">
              Usuario
            </th>

            <th className="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider text-slate-400">
              Rol
            </th>

            <th className="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider text-slate-400">
              Estado
            </th>

            <th className="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider text-slate-400">
              Fecha
            </th>

            <th className="px-6 py-4 text-right text-xs font-semibold uppercase tracking-wider text-slate-400">
              Acciones
            </th>

          </tr>

        </thead>

        <tbody>

          {users.map((user) => (

            <tr
              key={user.id}
              className="border-b border-white/5 transition hover:bg-white/5"
            >

              <td className="px-6 py-5">

                <UserAvatar
                    email={user.email}
                    active={user.active}
                />

              </td>

              <td className="px-6 py-5">

                <td className="px-6 py-5">
                    <RoleBadge role={user.role} />
                </td>

              </td>

              <td className="px-6 py-5">

                <td className="px-6 py-5">
                    <StatusBadge status={user.status} />
                </td>

              </td>

              <td className="px-6 py-5">

                {new Date(user.createdAt).toLocaleDateString("es-EC", {
                    day: "2-digit",
                    month: "short",
                    year: "numeric",
                })}

              </td>

              <td className="px-6 py-5 text-right">

                <UserActions

                    active={user.active}

                    onToggleStatus={() => {

                        console.log(user.id);

                    }}

                    onView={() => {

                        console.log(user.id);

                    }}

                />

              </td>

            </tr>

          ))}

        </tbody>

      </table>

    </div>
  );
}