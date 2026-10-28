package com.markup.dinerop.credit.infrastructure.web;

import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.credit.domain.service.*;
import com.markup.dinerop.credit.dto.ClientCreditResponseDto;
import com.markup.dinerop.credit.dto.CooperativeDecisionRequestDto;
import com.markup.dinerop.credit.dto.CooperativeStatusItemDto;
import com.markup.dinerop.credit.dto.ClientCreditRequestDto;
import com.markup.dinerop.credit.dto.PublicCreditRequestDto;
import com.markup.dinerop.credit.dto.GuaranteeDecisionRequestDto;
import org.springframework.security.access.prepost.PreAuthorize;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;


import java.util.List;
import java.util.Map;
import com.markup.dinerop.credit.service.CreditRequirementService;
import com.markup.dinerop.credit.service.CreditReferralPdfService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;

@RestController
@RequestMapping("/api/credits")
@RequiredArgsConstructor
public class CreditController {

    private final CreditService creditService;
    private final ClientCreditQueryService clientCreditQueryService;
    private final CooperativeCreditQueryService cooperativeCreditQueryService;
    private final CooperativeCreditDecisionService cooperativeCreditDecisionService;
    private final ClientCreditCooperativeStatusService clientCreditCooperativeStatusService;
    private final ClientCreditAcceptanceService clientCreditAcceptanceService;
        private final CreditRequirementService creditRequirementService;
        private final CreditReferralPdfService creditReferralPdfService;




    @PostMapping("/public-request")
    public ResponseEntity<Map<String, Object>> createPublicRequest(
            @Valid @RequestBody PublicCreditRequestDto dto
    ) {
        CreditService.PublicCreditRequestResult result = creditService.createPublicRequest(dto);
        return ResponseEntity.ok(
                result.requestId() == null
                        ? Map.of(
                                "message", result.message(),
                                "status", result.status()
                        )
                        : Map.of(
                                "requestId", result.requestId(),
                                "message", result.message(),
                                "status", result.status()
                        )
        );
    }

    @GetMapping(value = "/me/{solicitudId}/cooperatives/{cooperativaId}/referral.pdf", produces = MediaType.APPLICATION_PDF_VALUE)
    public ResponseEntity<byte[]> referralPdf(
            @AuthenticationPrincipal User user,
            @PathVariable Long solicitudId,
            @PathVariable Long cooperativaId
    ) {
        byte[] pdf = creditReferralPdfService.generate(user.getIdUser(), solicitudId, cooperativaId);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=dinerop-referencia-" + solicitudId + ".pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdf);
    }


    @PostMapping("/me")
    @PreAuthorize("hasRole('CLIENT')")
    public ResponseEntity<Map<String, Object>> createMyRequest(
            @Valid @RequestBody ClientCreditRequestDto dto,
            @AuthenticationPrincipal User user
    ) {
        CreditService.AuthenticatedRequestResult result = creditService.createAuthenticatedRequest(
                dto, user.getIdUser(), user.getEmail()
        );

        String message = switch (result.cooperativasNotificadas()) {
            case 0 -> "Solicitud creada. Aún no hay cooperativas disponibles en tu zona, te notificaremos cuando una pueda atenderte.";
            case 1 -> "Solicitud enviada a 1 cooperativa de tu zona.";
            default -> "Solicitud enviada a " + result.cooperativasNotificadas() + " cooperativas de tu zona.";
        };

        return ResponseEntity.ok(
                Map.of(
                        "requestId", result.requestId(),
                        "estado", result.estado(),
                        "cooperativasNotificadas", result.cooperativasNotificadas(),
                        "message", message
                )
        );
    }

    @GetMapping("/me")
    @PreAuthorize("hasRole('CLIENT')")
    public ResponseEntity<List<ClientCreditResponseDto>> getMyCredits(@AuthenticationPrincipal User user) {
        Long clientId = user.getIdUser();
        return ResponseEntity.ok(clientCreditQueryService.getMyCredits(clientId));
    }



    @GetMapping("/cooperative/me/requests")
    @PreAuthorize("hasRole('COOPERATIVE')")
    public ResponseEntity<Object> getMyCooperativeRequests(
            @AuthenticationPrincipal User user
    ) {
        Long cooperativaId = user.getCooperativaId();
        return ResponseEntity.ok(
                cooperativeCreditQueryService.getRequestsForCooperative(cooperativaId)
        );
    }


    @PutMapping("/cooperative/me/requests/{solicitudId}/decision")
    @PreAuthorize("hasRole('COOPERATIVE')")
    public ResponseEntity<Map<String, Object>> decideRequest(
            @PathVariable Long solicitudId,
            @Valid @RequestBody CooperativeDecisionRequestDto dto,
            @AuthenticationPrincipal User user
    ) {
        Long cooperativaId = user.getCooperativaId();

        cooperativeCreditDecisionService.decide(
                solicitudId,
                cooperativaId,
                dto.decision(),
                dto.tasaAnual(),
                dto.plazoMeses(),
                dto.requisitos()
        );

        return ResponseEntity.ok(
                Map.of("message", "Decisión registrada correctamente")
        );
    }

    @GetMapping("/cooperative/me/requests/{solicitudId}/offer-defaults")
    @PreAuthorize("hasRole('COOPERATIVE')")
    public ResponseEntity<com.markup.dinerop.credit.dto.CooperativeOfferDefaultsDto> getOfferDefaults(
            @PathVariable Long solicitudId,
            @AuthenticationPrincipal User user
    ) {
        return ResponseEntity.ok(
                cooperativeCreditDecisionService.getOfferDefaults(
                        solicitudId,
                        user.getCooperativaId()
                )
        );
    }
    //----------------------------------------------------------------------------------------
    //Cambiar estado de una solicitd cuando se solicite garante
    //----------------------------------------------------------------------------------------

    @PutMapping("/cooperative/me/requests/{solicitudId}/solicitar-garante")
    @PreAuthorize("hasRole('COOPERATIVE')")
    public ResponseEntity<Map<String, Object>> solicitarGarante(
            @PathVariable Long solicitudId,
            @AuthenticationPrincipal User user,
            @RequestBody(required = false) List<com.markup.dinerop.credit.dto.CreditRequirementDto> requisitos
    ) {
        Long cooperativaId = user.getCooperativaId();

        creditService.solicitarGarante(
                solicitudId,
                cooperativaId,
                requisitos
        );

        return ResponseEntity.ok(
                Map.of("message", "Solicitud de garante registrada correctamente")
        );
    }

    @PutMapping("/cooperative/me/requests/{solicitudId}/garante-decision")
    @PreAuthorize("hasRole('COOPERATIVE')")
    public ResponseEntity<Map<String, Object>> decidirGarante(
            @PathVariable Long solicitudId,
            @Valid @RequestBody GuaranteeDecisionRequestDto dto,
            @AuthenticationPrincipal User user
    ) {
        creditService.decidirGarante(
                solicitudId,
                user.getCooperativaId(),
                dto.decision()
        );
        return ResponseEntity.ok(
                Map.of("message", "Decisión del garante registrada correctamente")
        );
    }


    //----------------------------------------------------------------------------------------
    //Para saber solicitudes aprobadas el detalle
    //----------------------------------------------------------------------------------------
    @GetMapping("/me/{solicitudId}/pre-approved")
    public ResponseEntity<List<CooperativeStatusItemDto>> getMyPreApprovedCooperatives(
            @AuthenticationPrincipal User user,
            @PathVariable Long solicitudId
    ) {
        Long clientId = user.getIdUser();
        return ResponseEntity.ok(
                clientCreditCooperativeStatusService.getPreApprovedCooperatives(clientId, solicitudId)
        );
    }

    //----------------------------------------------------------------------------------------
    //Para aceptar una solicitud pre aprobada
    //----------------------------------------------------------------------------------------

    @PutMapping("/me/{solicitudId}/cooperatives/{cooperativaId}/accept")
    public ResponseEntity<Map<String, Object>> acceptPreApproved(
            @AuthenticationPrincipal User user,
            @PathVariable Long solicitudId,
            @PathVariable Long cooperativaId
    ) {
        Long clientId = user.getIdUser();
        clientCreditAcceptanceService.acceptPreApproved(clientId, solicitudId, cooperativaId);
        return ResponseEntity.ok(Map.of("message", "Solicitud aceptada correctamente"));
    }



}
