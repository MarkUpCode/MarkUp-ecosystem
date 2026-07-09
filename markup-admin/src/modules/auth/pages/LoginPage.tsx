import { useState } from "react";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useNavigate } from "react-router-dom";


import { useAuth } from "@/contexts/useAuth";
import { Button } from "@/components/ui/button";
import { LoginInput } from "../components/LoginInput";
import { isAdminRole } from "@/types/auth";
import { LoginBackground } from "../components/LoginBackground";
import { LoginCard } from "../components/LoginCard";

import logo from "@/assets/logo-markup.png";

import {
  Mail,
  Lock,
  Eye,
  EyeOff,
  AlertCircle,
} from "lucide-react";



const schema = z.object({
  email: z.string().email("Correo inválido"),
  password: z.string().min(6, "Mínimo 6 caracteres"),
});

type LoginForm = z.infer<typeof schema>;

export function LoginPage() {
  const navigate = useNavigate();
  const { login, user } = useAuth();
  const [error, setError] = useState("");
  const [showPassword, setShowPassword] = useState(false);
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

<div className="relative flex min-h-screen items-center justify-center overflow-hidden px-6">

    <LoginBackground />

    <LoginCard>

        <form
          onSubmit={handleSubmit(onSubmit)}
          className="space-y-5"
        >

          <LoginInput
            icon={Mail}
            type="email"
            placeholder="Correo electrónico"
            {...register("email")}
          />

          {errors.email && (
            <p className="pl-2 text-xs text-red-400">
              {errors.email.message}
            </p>
          )}

          <LoginInput
            icon={Lock}
            type={showPassword ? "text" : "password"}
            placeholder="Contraseña"
            {...register("password")}
            endAdornment={
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="
                  text-slate-500
                  transition
                  hover:text-cyan-400
                "
              >
                {showPassword ? (
                  <EyeOff className="h-5 w-5" />
                ) : (
                  <Eye className="h-5 w-5" />
                )}
              </button>
            }
          />

          {errors.password && (
            <p className="pl-2 text-xs text-red-400">
              {errors.password.message}
            </p>
          )}

          {error && (
            <div
              className="
                flex
                items-center
                gap-3
                rounded-2xl
                border
                border-red-500/20
                bg-red-500/10
                px-4
                py-3
                text-sm
                text-red-200
              "
            >
              <AlertCircle className="h-5 w-5 flex-shrink-0" />

              <span>{error}</span>
            </div>
          )}

          <Button
            type="submit"
            disabled={isSubmitting}
            className="
              mt-2
              h-14
              w-full
              rounded-2xl
              bg-cyan-500
              text-base
              font-semibold
              text-slate-950
              transition-all
              duration-300
              hover:-translate-y-0.5
              hover:bg-cyan-400
              hover:shadow-[0_0_35px_rgba(6,182,212,.35)]
            "
          >
            {isSubmitting ? "Ingresando..." : "Entrar"}
          </Button>

        </form>

    </LoginCard>

</div>

);
}
