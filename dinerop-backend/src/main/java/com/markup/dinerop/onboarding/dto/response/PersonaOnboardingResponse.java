package com.markup.dinerop.onboarding.dto.response;

import com.markup.dinerop.onboarding.domain.enums.EstadoFormulario;
import com.markup.dinerop.onboarding.domain.enums.RolPersona;
import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PersonaOnboardingResponse {
    private Long id;
    private RolPersona rol;
    private EstadoFormulario estadoFormulario;
    private String nombres;
    private String apellidos;
    private String cedula;
    private LocalDate fechaNacimiento;
    private String estadoCivil;
    private String ocupacion;
    private String empresaTrabajo;
    private String telefono;
    private DireccionOnboardingResponse direccion;
    private ActividadEconomicaResponse actividadEconomica;
    private IngresoEgresoResponse ingresoEgreso;
    private List<ReferenciaPersonalResponse> referencias;
}
