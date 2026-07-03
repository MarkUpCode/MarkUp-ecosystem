// Componente no utilizado en esta landing page
  const [form, setForm] = useState<FormState>(initialForm);
  const [errors, setErrors] = useState<{
    email?: string;
    cedula?: string;
    monto?: string;
    creditType?: string;
  }>({});
  const [acceptedTerms, setAcceptedTerms] = useState(false);

  const ciudadesDisponibles = form.provincia
    ? ciudadesPorProvincia[form.provincia as keyof typeof ciudadesPorProvincia]
    : [];

  const validateErrors = (nextForm: FormState) => {
    const nextErrors: {
      email?: string;
      cedula?: string;
      monto?: string;
      creditType?: string;
    } = {};

    if (nextForm.email && !/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(nextForm.email)) {
      nextErrors.email = "Correo invalido";
    }

    if (nextForm.cedula && !/^\d{10}$/.test(nextForm.cedula)) {
      nextErrors.cedula = "Cedula invalida";
    }

    if (nextForm.monto) {
      const amount = Number(nextForm.monto);
      if (!Number.isFinite(amount) || amount <= 0) {
        nextErrors.monto = "Monto invalido";
      } else if (type === "inversion" && amount < 500) {
        nextErrors.monto = "Monto minimo 500 USD";
      }
    }

    // NUEVO: creditType obligatorio solo si type === "credito"
    if (type === "credito") {
      if (!nextForm.creditType) {
        nextErrors.creditType = "Selecciona el tipo de crédito";
      }
    }

    return nextErrors;
  };

  const isValid = useMemo(() => {
    const baseRequired = [
      form.nombres,
      form.apellidos,
      form.email,
      form.telefono,
      form.cedula,
      form.provincia,
      form.ciudad,
      form.monto,
    ].every((value) => value.trim().length > 0);

    const creditTypeOk = type === "credito" ? !!form.creditType : true;

    return baseRequired && creditTypeOk && Object.keys(validateErrors(form)).length === 0;
  }, [form, type]);

  const handleChange = (e: ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;

    const nextForm: FormState = {
      ...form,
      [name]: value,
    } as FormState;

    setForm(nextForm);
    setErrors(validateErrors(nextForm));
  };

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const nextErrors = validateErrors(form);
    setErrors(nextErrors);

    const requiredFilled = [
      form.nombres,
      form.apellidos,
      form.email,
      form.telefono,
      form.cedula,
      form.provincia,
      form.ciudad,
      form.monto,
    ].every((value) => value.trim().length > 0);

    const creditTypeOk = type === "credito" ? !!form.creditType : true;

    if (!requiredFilled || !creditTypeOk || Object.keys(nextErrors).length > 0) {
      return;
    }

    if (!acceptedTerms) {
      alert("Debes aceptar los terminos y condiciones antes de continuar.");
      return;
    }

    try {
      const payload: any = {
        firstName: form.nombres.trim(),
        lastName: form.apellidos.trim(),
        email: form.email.trim(),
        phone: form.telefono.trim(),
        identification: form.cedula.trim(),
        province: form.provincia,
        city: form.ciudad,
        amount: Number(form.monto),
        type: type === "credito" ? "CREDITO" : "INVERSION",
      };

      // SOLO si es CREDITO enviamos creditType (en MAYÚSCULAS)
      if (type === "credito") {
        payload.creditType = form.creditType; // "MICROCREDITO" | "CONSUMO"
      }

      await submit(payload);

      onSuccess();
      setForm(initialForm);
      setErrors({});
      setAcceptedTerms(false);
    } catch (error: any) {
      alert(error.message || "Error en el registro");
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {/* Nombre y apellido */}
      <div className="grid grid-cols-2 gap-3">
        <Input
          icon={User}
          name="nombres"
          value={form.nombres}
          onChange={(e: ChangeEvent<HTMLInputElement>) => {
            const value = e.target.value;
            if (/^[A-Za-zA?A%A?A"AsA­AcA-A3A§A`Añ\s]*$/.test(value)) {
              handleChange(e);
            }
          }}
          placeholder="Juan"
        />

        <Input
          icon={User}
          name="apellidos"
          value={form.apellidos}
          onChange={(e: ChangeEvent<HTMLInputElement>) => {
            const value = e.target.value;
            if (/^[A-Za-zA?A%A?A"AsA­AcA-A3A§A`Añ\s]*$/.test(value)) {
              handleChange(e);
            }
          }}
          placeholder="Velez"
        />
      </div>

      {/* Email */}
      <Input
        icon={Mail}
        name="email"
        value={form.email}
        onChange={(e: ChangeEvent<HTMLInputElement>) => {
          const value = e.target.value;
          // Permite solo caracteres aceptados en emails
          if (/^[A-Za-z0-9@._-]*$/.test(value)) {
            handleChange(e);
          }
        }}
        placeholder="correoejemplo@ejemplo.com"
        error={errors.email}
      />

      {/* Teléfono y cédula */}
      <div className="grid grid-cols-2 gap-3">
        <Input
          icon={Phone}
          name="telefono"
          value={form.telefono}
          onChange={(e: ChangeEvent<HTMLInputElement>) => {
            const value = e.target.value;
            if (/^\d{0,10}$/.test(value)) {
              handleChange(e);
            }
          }}
          placeholder="0999999999"
        />

        <Input
          icon={CreditCard}
          name="cedula"
          value={form.cedula}
          onChange={(e: ChangeEvent<HTMLInputElement>) => {
            const value = e.target.value;
            if (/^\d{0,10}$/.test(value)) {
              handleChange(e);
            }
          }}
          placeholder="0492378223"
          maxLength={10}
          error={errors.cedula}
        />
      </div>

      {/* Provincia */}
      <Select
        icon={MapPin}
        name="provincia"
        value={form.provincia}
        onChange={handleChange}
        options={Object.keys(ciudadesPorProvincia)}
        placeholder="Provincia"
      />

      {/* Ciudad */}
      <Select
        icon={MapPin}
        name="ciudad"
        value={form.ciudad}
        onChange={handleChange}
        options={ciudadesDisponibles}
        placeholder="Ciudad"
        disabled={!form.provincia}
      />

      {/* NUEVO: Tipo de crédito (solo CREDITO) */}
      {type === "credito" && (
        <Select
          icon={CreditCard}
          name="creditType"
          value={form.creditType ?? ""}
          onChange={handleChange}
          options={["MICROCREDITO", "CONSUMO"]}
          placeholder="Tipo de crédito"
          error={errors.creditType}
        />
      )}

      {/* Monto */}
      <div>
        <input
          type="number"
          name="monto"
          value={form.monto}
          onChange={handleChange}
          placeholder={type === "inversion" ? "Monto a invertir (min 500 USD)" : "Monto a solicitar (USD)"}
          className="w-full border-2 border-gray-200 rounded-xl px-4 py-3 focus:border-blue-500"
          required
        />
        {errors.monto && <p className="text-xs text-red-600 mt-1">{errors.monto}</p>}
      </div>

      {/* Checkbox Términos y Condiciones */}
      <div className="flex items-start gap-2 mt-2">
        <input
          type="checkbox"
          checked={acceptedTerms}
          onChange={(e) => setAcceptedTerms(e.target.checked)}
          className="mt-1 h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
        />
        <label className="text-sm text-gray-700 leading-tight">
          Acepto los{" "}
          <a href="/terminos" target="_blank" className="text-blue-600 underline cursor-pointer">
            terminos y condiciones
          </a>{" "}
          del manejo de mis datos personales.
        </label>
      </div>

      {/* BOTÓN SUBMIT */}
      <button
        type="submit"
        disabled={!isValid || !acceptedTerms || loading}
        className="w-full mt-6 bg-gradient-to-r from-emerald-500 to-teal-600 text-white py-3 rounded-xl font-bold hover:scale-[1.02] transition disabled:opacity-50"
      >
        {loading ? "Procesando..." : type === "credito" ? "Solicitar Credito" : "Realizar inversion"}
      </button>
    </form>
  );
}

function Input({ icon: Icon, error, ...props }: any) {
  return (
    <div className="relative">
      <Icon className="absolute left-3 top-1/2 -translate-y-1/2 w-4 text-gray-400" />
      <input
        {...props}
        className={`w-full border-2 rounded-xl pl-10 pr-4 py-3 focus:border-blue-500 ${
          error ? "border-red-400" : "border-gray-200"
        }`}
        required
      />
      {error && <p className="text-xs text-red-600 mt-1">{error}</p>}
    </div>
  );
}

function Select({ icon: Icon, options, placeholder, error, ...props }: any) {
  return (
    <div className="relative">
      <Icon className="absolute left-3 top-1/2 -translate-y-1/2 w-4 text-gray-400" />
      <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-4 text-gray-400" />

      <select
        {...props}
        className={`w-full border-2 rounded-xl pl-10 pr-8 py-3 appearance-none bg-white focus:border-blue-500 ${
          error ? "border-red-400" : "border-gray-200"
        }`}
        required
      >
        <option value="">{placeholder}</option>
        {options.map((op: string) => (
          <option key={op} value={op}>
            {op}
          </option>
        ))}
      </select>

      {error && <p className="text-xs text-red-600 mt-1">{error}</p>}
    </div>
  );
}
