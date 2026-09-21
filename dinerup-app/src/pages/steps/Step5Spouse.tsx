type Step5SpouseProps = {
  data: any;
  setData: React.Dispatch<React.SetStateAction<any>>;
  nextStep: () => void;
  prevStep: () => void;
};

export default function Step5Spouse({ data, setData, nextStep, prevStep }: Step5SpouseProps) {
  const conyuge = data.conyuge;

  if (!conyuge) {
    return null;
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;

    setData((prev: any) => {
      if (!prev.conyuge) return prev;

      return {
        ...prev,
        conyuge: {
          ...prev.conyuge,
          [name]: value,
        },
      };
    });
  };

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-6 text-gray-800">
        Información del Cónyuge
      </h2>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        <Input
          label="Cédula del Cónyuge *"
          name="cedula"
          value={conyuge.cedula}
          onChange={handleChange}
          placeholder="Ej: 1234567890"
          maxLength={10}
        />

        <Input
          label="Nombres *"
          name="nombres"
          value={conyuge.nombres}
          onChange={handleChange}
          placeholder="Ej: María"
        />

        <Input
          label="Apellidos *"
          name="apellidos"
          value={conyuge.apellidos}
          onChange={handleChange}
          placeholder="Ej: García Pérez"
        />

        <Input
          label="Fecha de Nacimiento *"
          type="date"
          name="fechaNacimiento"
          value={conyuge.fechaNacimiento}
          onChange={handleChange}
        />

        <Input
          label="Teléfono *"
          name="telefono"
          value={conyuge.telefono}
          onChange={handleChange}
          placeholder="Ej: 0987654321"
          maxLength={10}
        />

        <Input
          label="Ocupación *"
          name="ocupacion"
          value={conyuge.ocupacion}
          onChange={handleChange}
          placeholder="Ej: Ingeniera"
        />

        <Input
          label="Empresa o Negocio *"
          name="empresaTrabajo"
          value={conyuge.empresaTrabajo}
          onChange={handleChange}
          placeholder="Ej: Empresa XYZ"
        />
      </div>

      <div className="flex justify-between mt-8">
        <button
          onClick={prevStep}
          className="px-6 py-3 border rounded-xl"
        >
          ← Atrás
        </button>

        <button
          onClick={nextStep}
          className="px-6 py-3 bg-primary-600 text-white rounded-xl font-semibold hover:bg-primary-700"
        >
          Siguiente →
        </button>
      </div>
    </div>
  );
}

/* ======================
   COMPONENTE INPUT
====================== */

type InputProps = {
  label: string;
  value: string | number;
  [key: string]: any;
};

function Input({ label, value, ...props }: InputProps) {
  return (
    <div>
      <label className="text-gray-700 font-medium mb-1">{label}</label>
      <input
        {...props}
        value={value}
        className="w-full px-4 py-3 border rounded-xl bg-gray-50
        focus:ring-2 focus:ring-primary-600 transition outline-none"
      />
    </div>
  );
}
