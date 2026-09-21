type Step4EconomicProps = {
  data: any;
  setData: React.Dispatch<React.SetStateAction<any>>;
  nextStep: () => void;
  prevStep: () => void;
};

export default function Step4Economic({ data, setData, nextStep, prevStep }: Step4EconomicProps) {
  const handleActivityChange = (field: string, value: string) => {
    setData((prev: any) => ({
      ...prev,
      solicitante: {
        ...prev.solicitante,
        actividadEconomica: {
          ...prev.solicitante.actividadEconomica,
          [field]: value,
        },
      },
    }));
  };

  const handleIncomeChange = (field: string, value: number) => {
    setData((prev: any) => ({
      ...prev,
      solicitante: {
        ...prev.solicitante,
        ingresoEgreso: {
          ...prev.solicitante.ingresoEgreso,
          [field]: value,
        },
      },
    }));
  };

  const handleReferenceChange = (index: number, field: string, value: string) => {
    setData((prev: any) => {
      const newReferencias = [...prev.solicitante.referencias];
      newReferencias[index] = { ...newReferencias[index], [field]: value };
      return {
        ...prev,
        solicitante: {
          ...prev.solicitante,
          referencias: newReferencias,
        },
      };
    });
  };

  const addReference = () => {
    setData((prev: any) => ({
      ...prev,
      solicitante: {
        ...prev.solicitante,
        referencias: [
          ...prev.solicitante.referencias,
          { nombreCompleto: "", tipo: "PERSONAL", parentesco: "", telefono: "" },
        ],
      },
    }));
  };

  const removeReference = (index: number) => {
    setData((prev: any) => ({
      ...prev,
      solicitante: {
        ...prev.solicitante,
        referencias: prev.solicitante.referencias.filter((_: any, i: number) => i !== index),
      },
    }));
  };

  const solicitante = data.solicitante;

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-6 text-gray-800">Información Económica</h2>

      {/* Sección de Actividad Económica */}
      <div className="mb-8 p-4 bg-gray-50 rounded-xl">
        <h3 className="text-lg font-semibold mb-4 text-gray-700">Actividad Económica</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
          <Input
            label="Nombre del Negocio"
            value={solicitante.actividadEconomica.nombreNegocio}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleActivityChange("nombreNegocio", e.target.value)}
            placeholder="Ej: Tienda de abarrotes"
          />
          <Input
            label="Dirección del Negocio"
            value={solicitante.actividadEconomica.direccionNegocio}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleActivityChange("direccionNegocio", e.target.value)}
            placeholder="Ej: Calle Principal 123"
          />
          <Input
            label="Tiempo de Actividad"
            value={solicitante.actividadEconomica.tiempoActividad}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleActivityChange("tiempoActividad", e.target.value)}
            placeholder="Ej: 5 años"
          />
          <Input
            label="Teléfono del Negocio"
            value={solicitante.actividadEconomica.telefonoNegocio}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleActivityChange("telefonoNegocio", e.target.value)}
            placeholder="Ej: 0987654321"
            maxLength={10}
          />
        </div>
      </div>

      {/* Sección de Ingresos y Egresos */}
      <div className="mb-8 p-4 bg-gray-50 rounded-xl">
        <h3 className="text-lg font-semibold mb-4 text-gray-700">Ingresos y Egresos Mensuales</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
          <Input
            label="Ingreso Mensual (USD) *"
            type="number"
            value={solicitante.ingresoEgreso.ingresoMensual}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleIncomeChange("ingresoMensual", parseFloat(e.target.value) || 0)}
            placeholder="Ej: 1500"
            min={0}
          />
          <Input
            label="Egreso Mensual (USD) *"
            type="number"
            value={solicitante.ingresoEgreso.egresoMensual}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleIncomeChange("egresoMensual", parseFloat(e.target.value) || 0)}
            placeholder="Ej: 1000"
            min={0}
          />
        </div>
      </div>

      {/* Sección de Referencias */}
      <div className="p-4 bg-gray-50 rounded-xl">
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-semibold text-gray-700">Referencias Personales</h3>
          <button
            onClick={addReference}
            className="px-4 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700"
          >
            + Agregar Referencia
          </button>
        </div>

        {solicitante.referencias.map((ref: any, index: number) => (
          <div key={index} className="mb-6 p-4 border rounded-lg bg-white">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5 mb-4">
              <Input
                label="Nombre Completo *"
                value={ref.nombreCompleto}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleReferenceChange(index, "nombreCompleto", e.target.value)}
                placeholder="Ej: María García"
              />
              <Select
                label="Tipo de Referencia *"
                value={ref.tipo}
                onChange={(e: React.ChangeEvent<HTMLSelectElement>) => handleReferenceChange(index, "tipo", e.target.value)}
                options={["PERSONAL", "LABORAL", "COMERCIAL"]}
              />
              <Input
                label="Parentesco/Relación"
                value={ref.parentesco}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleReferenceChange(index, "parentesco", e.target.value)}
                placeholder="Ej: Amigo"
              />
              <Input
                label="Teléfono *"
                value={ref.telefono}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleReferenceChange(index, "telefono", e.target.value)}
                placeholder="Ej: 0987654321"
                maxLength={10}
              />
            </div>
            {solicitante.referencias.length > 1 && (
              <button
                onClick={() => removeReference(index)}
                className="px-4 py-2 bg-red-600 text-white rounded-lg text-sm hover:bg-red-700"
              >
                Eliminar Referencia
              </button>
            )}
          </div>
        ))}
      </div>

      <div className="flex justify-between mt-8">
        <button onClick={prevStep} className="px-6 py-3 border rounded-xl">← Atrás</button>

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
        className="w-full px-4 py-3 border rounded-xl bg-gray-50 focus:ring-2 focus:ring-primary-600 transition outline-none"
      />
    </div>
  );
}

type SelectProps = {
  label: string;
  value: string;
  options: string[];
  [key: string]: any;
};

function Select({ label, value, options, ...props }: SelectProps) {
  return (
    <div>
      <label className="text-gray-700 font-medium mb-1">{label}</label>
      <select
        {...props}
        value={value}
        className="w-full px-4 py-3 border rounded-xl bg-gray-50 focus:ring-2 focus:ring-primary-600 transition outline-none"
      >
        <option value="">Seleccione...</option>
        {options.map((o) => (
          <option key={o} value={o}>{o}</option>
        ))}
      </select>
    </div>
  );
}
