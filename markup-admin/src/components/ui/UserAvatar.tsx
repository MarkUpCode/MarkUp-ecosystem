interface UserAvatarProps {
  email: string;
  active: boolean;
}

export function UserAvatar({
  email,
  active,
}: UserAvatarProps) {
  return (
    <div className="flex items-center gap-4">

      <div className="relative">

        <div className="grid h-12 w-12 place-items-center rounded-full bg-cyan-500/15 font-bold text-cyan-300">
          {email.charAt(0).toUpperCase()}
        </div>

        <span
          className={`absolute bottom-0 right-0 h-3.5 w-3.5 rounded-full border-2 border-slate-900 ${
            active
              ? "bg-emerald-400"
              : "bg-red-500"
          }`}
        />

      </div>

      <div>

        <p className="font-semibold text-white">
          {email}
        </p>

        <p className="text-xs text-slate-400">
          Usuario del sistema
        </p>

      </div>

    </div>
  );
}