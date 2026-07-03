// Validar cédula Ecuatoriana
export const validarCedulaEcuador = (cedula: string) => {
  if (!/^\d{10}$/.test(cedula)) return false;

  const provincia = parseInt(cedula.substring(0, 2));
  if (provincia < 1 || provincia > 24) return false;

  const digitos = cedula.split("").map((d) => parseInt(d));
  const ultimo = digitos.pop()!;
  let suma = 0;

  digitos.forEach((val, index) => {
    if (index % 2 === 0) {
      let mult = val * 2;
      if (mult > 9) mult -= 9;
      suma += mult;
    } else {
      suma += val;
    }
  });

  const verificador = (10 - (suma % 10)) % 10;
  return verificador === ultimo;
};

// Validar monto según tipo
export const validarMonto = (valor: string, tipo: "credito" | "inversion") => {
  const num = parseFloat(valor);
  if (!/^\d+(\.\d{1,2})?$/.test(valor)) return "Ingresa un monto válido";
  if (num <= 0) return "El monto debe ser mayor a cero";

  if (tipo === "inversion" && num < 500)
    return "El monto mínimo para inversión es 500 USD";

  return "";
};
