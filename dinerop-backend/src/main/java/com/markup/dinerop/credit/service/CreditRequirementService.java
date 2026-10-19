package com.markup.dinerop.credit.service;

import com.markup.dinerop.credit.domain.model.CreditRequirement;
import com.markup.dinerop.credit.dto.CreditRequirementDto;
import com.markup.dinerop.credit.infrastructure.repository.CreditRequirementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CreditRequirementService {
    private final CreditRequirementRepository repository;

    public List<CreditRequirement> findForOffer(Long offerId) {
        List<CreditRequirement> items = repository.findBySolicitudCooperativaIdOrderByDisplayOrderAsc(offerId);
        return items.isEmpty() ? defaultRequirements(offerId) : items;
    }

    @Transactional
    public void replaceForOffer(Long offerId, List<CreditRequirementDto> requested) {
        repository.deleteBySolicitudCooperativaId(offerId);
        List<CreditRequirementDto> items = requested == null || requested.isEmpty()
                ? defaultDtos() : requested;
        for (int i = 0; i < items.size(); i++) {
            CreditRequirementDto item = items.get(i);
            repository.save(CreditRequirement.builder()
                    .solicitudCooperativaId(offerId)
                    .title(item.title().trim())
                    .description(item.description())
                    .category(item.category() == null || item.category().isBlank() ? "OTROS" : item.category())
                    .mandatory(item.mandatory() == null || item.mandatory())
                    .displayOrder(item.displayOrder() == null ? i : item.displayOrder())
                    .build());
        }
    }

    private List<CreditRequirement> defaultRequirements(Long offerId) {
        return defaultDtos().stream().map(item -> CreditRequirement.builder()
                .solicitudCooperativaId(offerId).title(item.title()).description(item.description())
                .category(item.category()).mandatory(true).displayOrder(item.displayOrder()).build()).toList();
    }

    private List<CreditRequirementDto> defaultDtos() {
        return List.of(
                new CreditRequirementDto("Cédula de ciudadanía", "Original y copia", "IDENTIDAD", true, 0),
                new CreditRequirementDto("Papeleta de votación", "Actualizada, si aplica", "IDENTIDAD", false, 1),
                new CreditRequirementDto("Planilla de servicio básico", "Agua, luz o teléfono de los últimos 2 meses", "DOMICILIO", true, 2),
                new CreditRequirementDto("Roles de pago o respaldo de ingresos", "Según tu actividad económica", "INGRESOS", true, 3),
                new CreditRequirementDto("Constancia de referencia Dinerop", "Documento PDF generado por la aplicación", "DINEROP", true, 4)
        );
    }
}
