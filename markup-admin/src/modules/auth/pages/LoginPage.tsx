import { useState } from "react";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useNavigate } from "react-router-dom";
import { LogIn } from "lucide-react";
import { useAuth } from "@/contexts/useAuth";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card } from "@/components/ui/card";
import { isAdminRole } from "@/types/auth";

const schema = z.object({
  email: z.string().email("Correo inválido"),
  password: z.string().min(6, "Mínimo 6 caracteres"),
});

type LoginForm = z.infer<typeof schema>;

export function LoginPage() {
  const navigate = useNavigate();
  const { login, user } = useAuth();
  const [error, setError] = useState("");
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<LoginForm>({
    resolver: zodResolver(schema),
    defaultValues: { email: "", password: "" },
  });

  const onSubmit = async (values: LoginForm) => {
    setError("");
    try {
      await login(values.email, values.password);
      if (!isAdminRole(user?.role)) {
        setError("Acceso denegado");
        return;
      }
      navigate("/dashboard");
    } catch (error) {
      setError(error instanceof Error ? error.message : "No fue posible iniciar sesión");
    }
  };

  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top,_rgba(34,211,238,0.18),_transparent_32%),linear-gradient(180deg,#020617_0%,#0f172a_100%)] px-4 py-10 text-slate-100">
      <div className="mx-auto grid w-full max-w-6xl overflow-hidden rounded-[2rem] border border-white/10 bg-white/5 shadow-soft backdrop-blur-xl lg:grid-cols-2">
        <div className="flex flex-col justify-between gap-8 p-8 lg:p-12">
          <div>
            <p className="mb-4 inline-flex rounded-full border border-cyan-400/20 bg-cyan-400/10 px-4 py-1 text-xs font-semibold uppercase tracking-[0.24em] text-cyan-300">
              Markup Admin
            </p>
            <h1 className="max-w-xl text-4xl font-semibold leading-tight lg:text-6xl">
              CRM interno para operar la plataforma con control total.
            </h1>
            <p className="mt-5 max-w-xl text-sm leading-7 text-slate-300 lg:text-base">
              Administración de cooperativas, usuarios, solicitudes, leads, productos y reportes en un solo panel.
            </p>
          </div>
          <div className="grid gap-4 text-sm text-slate-300 sm:grid-cols-3">
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">JWT + rutas privadas</div>
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">React Query + Axios</div>
            <div className="rounded-2xl border border-white/10 bg-black/20 p-4">Tailwind + shadcn/ui</div>
          </div>
        </div>

        <div className="flex items-center justify-center bg-slate-950/80 p-8 lg:p-12">
          <Card className="w-full max-w-md border-white/10 bg-slate-950/70">
            <div className="mb-8">
              <div className="mb-4 grid h-14 w-14 place-items-center rounded-2xl bg-cyan-400/15 text-cyan-300">
                <LogIn className="h-6 w-6" />
              </div>
              <h2 className="text-2xl font-semibold">Iniciar sesión</h2>
              <p className="mt-2 text-sm text-slate-400">Acceso restringido para administradores.</p>
            </div>

            <form className="space-y-4" onSubmit={handleSubmit(onSubmit)}>
              <div>
                <label className="mb-2 block text-sm text-slate-300">Correo</label>
                <Input type="email" placeholder="admin@markup.com" {...register("email")} />
                {errors.email && <p className="mt-2 text-xs text-red-400">{errors.email.message}</p>}
              </div>

              <div>
                <label className="mb-2 block text-sm text-slate-300">Contraseña</label>
                <Input type="password" placeholder="••••••••" {...register("password")} />
                {errors.password && <p className="mt-2 text-xs text-red-400">{errors.password.message}</p>}
              </div>

              {error && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-sm text-red-200">{error}</div>}

              <Button type="submit" disabled={isSubmitting} className="h-11 w-full bg-cyan-400 text-slate-950 hover:bg-cyan-300">
                {isSubmitting ? "Ingresando..." : "Entrar al panel"}
              </Button>
            </form>
          </Card>
        </div>
      </div>
    </div>
  );
}
