type Step2PersonalDetailsProps = {
  data: any;
  setData: React.Dispatch<React.SetStateAction<any>>;
  nextStep: () => void;
  prevStep: () => void;
};

export default function Step2PersonalDetails({
  data,
  setData,
  nextStep,
  prevStep,
}: Step2PersonalDetailsProps) {
  const solicitante = data.solicitante;

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;

    setData((prev: any) => ({
      ...prev,
      solicitante: {
        ...prev.solicitante,
        [name]: value,
      },
    }));
  };

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-6 text-gray-800">
        Datos Personales
      </h2>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        <Input
          label="Teléfono *"
          name="telefono"
          value={solicitante.telefono}
          onChange={handleChange}
          placeholder="Ej: 0987654321"
          maxLength={10}
        />

        <Input
          label="Ocupación *"
          name="ocupacion"
          value={solicitante.ocupacion}
          onChange={handleChange}
          placeholder="Ej: Ingeniero de Sistemas"
        />

        <Input
          label="Empresa o Negocio *"
          name="empresaTrabajo"
          value={solicitante.empresaTrabajo}
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
