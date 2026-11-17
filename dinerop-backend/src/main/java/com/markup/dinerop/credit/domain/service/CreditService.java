package com.markup.dinerop.credit.domain.service;

import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.service.AuthService;
import com.markup.dinerop.credit.domain.model.CreditRequest;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativaCotizacion;
import com.markup.dinerop.credit.domain.model.enums.CreditRequestStatus;
import com.markup.dinerop.credit.domain.model.enums.CreditRequestType;
import com.markup.dinerop.credit.domain.model.enums.CreditRejectionReason;
import com.markup.dinerop.credit.domain.model.enums.SolicitudCooperativaStatus;
import com.markup.dinerop.credit.domain.service.calculation.LoanCalculator;
import com.markup.dinerop.credit.dto.ClientCreditRequestDto;
import com.markup.dinerop.credit.dto.PublicCreditRequestDto;
import com.markup.dinerop.credit.infrastructure.repository.CreditRequestRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaCotizacionRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import com.markup.dinerop.credit.infrastructure.repository.CreditProcessEventRepository;
import com.markup.dinerop.credit.domain.model.CreditProcessEvent;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.cooperative.domain.service.CooperativeService;
import com.markup.dinerop.notification.service.NotificationService;
import com.markup.dinerop.notification.service.PushNotificationService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import com.markup.dinerop.auth.dto.PublicRegistrationRequest;
import com.markup.dinerop.auth.entity.Role;




import java.util.List;
import java.util.Optional;
import java.math.BigDecimal;
import com.markup.dinerop.credit.service.CreditRequirementService;
import com.markup.dinerop.credit.dto.CreditRequirementDto;

@Slf4j
@Service
@RequiredArgsConstructor
public class CreditService {

    private final CreditRequestRepository creditRequestRepository;
    private final AuthService authService;
    private final CreditDistributionService creditDistributionService;
    private final SolicitudCooperativaRepository solicitudCooperativaRepository;
        private final SolicitudCooperativaCotizacionRepository cotizacionRepository;
    private final UserRepository userRepository;
    private final CooperativeService cooperativeService;
    private final NotificationService notificationService;
    private final PushNotificationService pushNotificationService;
    private final CreditProcessEventRepository creditProcessEventRepository;
        private final CreditRequirementService creditRequirementService;
    private final CreditGuarantorWorkflowService guarantorWorkflowService;



    // =========================
    // Solicitud publica loging dinerup
    // =========================

    @Transactional
        public PublicCreditRequestResult createPublicRequest(PublicCreditRequestDto dto) {

        // =========================
        // 1. NORMALIZAR EMAIL
        // =========================

        String normalizedEmail = dto.getEmail()
                .toLowerCase()
                .trim();

        Optional<User> existingUser = userRepository.findByEmail(normalizedEmail);

        if (existingUser.isPresent()) {
                User user = authService.preRegisterClient(
                        PublicRegistrationRequest.builder()
                                .email(normalizedEmail)
                                .firstName(dto.getFirstName())
                                .lastName(dto.getLastName())
                                .identification(dto.getIdentification())
                                .phone(dto.getPhone())
                                .province(dto.getProvince())
                                .city(dto.getCity())
                                .build()
                );

                return new PublicCreditRequestResult(
                        null,
                        user.getStatus(),
                        "Ya existe un registro pendiente. Hemos enviado un nuevo código de verificación."
                );
        }

        // =========================
        // 2. VALIDAR SOLICITUD ACTIVA
        // =========================

        boolean exists =
                creditRequestRepository.existsByEmailAndEstado(
                        normalizedEmail,
                        CreditRequestStatus.CREADA
                );

        if (exists) {
                throw new IllegalStateException(
                        "EXISTING_ACTIVE_REQUEST"
                );
        }

        // =========================
        // 3. VALIDACIONES DE DOMINIO
        // =========================

        if (dto.getType() == CreditRequestType.CREDITO
                && dto.getCreditType() == null) {

                throw new IllegalArgumentException(
                        "CREDIT_TYPE_REQUIRED_FOR_CREDITO"
                );
        }

        if (dto.getType() == CreditRequestType.INVERSION
                && dto.getCreditType() != null) {

                throw new IllegalArgumentException(
                        "CREDIT_TYPE_NOT_ALLOWED_FOR_INVERSION"
                );
        }

        if (dto.getPlazoMeses() != null
                && (
                        dto.getPlazoMeses() < 1
                        || dto.getPlazoMeses() > 360
                )) {

                throw new IllegalArgumentException(
                        "INVALID_PLAZO_MESES"
                );
        }

        // =========================
        // 4. GUARDAR PREREGISTRO
        // =========================

        PublicRegistrationRequest registrationRequest =
                PublicRegistrationRequest.builder()
                        .email(normalizedEmail)
                        .firstName(dto.getFirstName())
                        .lastName(dto.getLastName())
                        .identification(dto.getIdentification())
                        .phone(dto.getPhone())
                        .province(dto.getProvince())
                        .city(dto.getCity())
                        .build();

        User user = authService.preRegisterClient(
                registrationRequest
        );

        // =========================
        // 5. GUARDAR SOLICITUD
        // =========================

        CreditRequest request = CreditRequest.builder()
                .clientId(user.getIdUser())
                .email(normalizedEmail)
                .identification(dto.getIdentification())
                .amount(dto.getAmount())
                .province(dto.getProvince())
                .city(dto.getCity())
                .tipo(dto.getType())
                .creditType(
                        dto.getType() == CreditRequestType.CREDITO
                                ? dto.getCreditType()
                                : null
                )
                .plazoMeses(dto.getPlazoMeses())
                .estado(CreditRequestStatus.CREADA)
                .build();

        creditRequestRepository.save(request);

        log.info(
                "[CREDIT] Solicitud pública creada | " +
                "requestId={} userId={} email={}",
                request.getId(),
                user.getIdUser(),
                normalizedEmail
        );

        return new PublicCreditRequestResult(
                request.getId(),
                "PENDING_ACTIVATION",
                "Solicitud enviada correctamente. Revisa tu correo para activar tu cuenta."
        );
        }

    public record PublicCreditRequestResult(
            Long requestId,
            String status,
            String message
    ) {}


    // =========================
    // Solicitud desde cliente autenticado
    // =========================

    public record AuthenticatedRequestResult(
            Long requestId,
            CreditRequestStatus estado,
            int cooperativasNotificadas
    ) {}

    @Transactional
    public AuthenticatedRequestResult createAuthenticatedRequest(ClientCreditRequestDto dto, Long clientId, String email) {

        // 1. Validar que no exista solicitud activa para este cliente
        boolean exists = !creditRequestRepository
                .findByClientIdAndEstado(clientId, CreditRequestStatus.CREADA)
                .isEmpty();

        if (exists) {
            throw new IllegalStateException("EXISTING_ACTIVE_REQUEST");
        }

        // 2. Validaciones de dominio
        if (dto.getType() == CreditRequestType.CREDITO && dto.getCreditType() == null) {
            throw new IllegalArgumentException("CREDIT_TYPE_REQUIRED_FOR_CREDITO");
        }

        if (dto.getType() == CreditRequestType.INVERSION && dto.getCreditType() != null) {
            throw new IllegalArgumentException("CREDIT_TYPE_NOT_ALLOWED_FOR_INVERSION");
        }

        if (dto.getPlazoMeses() != null &&
                (dto.getPlazoMeses() < 1 || dto.getPlazoMeses() > 360)) {
            throw new IllegalArgumentException("INVALID_PLAZO_MESES");
        }

        // 3. Persistir solicitud_credito ya vinculada al cliente
        CreditRequest request = CreditRequest.builder()
                .clientId(clientId)
                .email(email)
                .identification("")
                .amount(dto.getMonto())
                .province(dto.getProvince())
                .city(dto.getCity())
                .tipo(dto.getType())
                .creditType(
                        dto.getType() == CreditRequestType.CREDITO
                                ? dto.getCreditType()
                                : null
                )
                .plazoMeses(dto.getPlazoMeses())
                .estado(CreditRequestStatus.CREADA)
                .build();

        creditRequestRepository.save(request);

        // 4. Intentar distribuir
        int distributed = 0;
        boolean tieneUbicacion =
                (dto.getCity() != null && !dto.getCity().isBlank())
                        || (dto.getProvince() != null && !dto.getProvince().isBlank());

        if (tieneUbicacion) {
            distributed = creditDistributionService.distributeToCityCooperatives(request);
        }

        // 5. Reglas de estado:
        //    - Si hay distribuciones: ENVIADA (flujo feliz)
        //    - Si NO hay distribuciones pero la solicitud trae ubicación válida: ENVIADA igualmente,
        //      ya que el cliente sí envió la solicitud; quedará a la espera de cooperativas elegibles.
        //    - Si la solicitud no tiene ubicación: se queda en CREADA hasta que el flujo de onboarding
        //      complete los datos y la distribuya (completeOnboardingAndDispatch).
        if (distributed > 0 || tieneUbicacion) {
            request.setEstado(CreditRequestStatus.ENVIADA);
            creditRequestRepository.save(request);
            log.info(
                    "[CREDIT] Authenticated request {} marked as ENVIADA (distributed={}, withLocation={})",
                    request.getId(), distributed, tieneUbicacion
            );
        } else {
            log.warn(
                    "[CREDIT] Authenticated request {} stays as CREADA (no location, no distributions)",
                    request.getId()
            );
        }

        return new AuthenticatedRequestResult(
                request.getId(),
                request.getEstado(),
                distributed
        );
    }

    // =========================
    // Vincular solicitud con cliente.
    // =========================


    @Transactional
    public int linkClientToRequests(String email, Long clientId) {
        return creditRequestRepository.linkClientIdByEmail(email, clientId);
    }


    // ===================================================================
    // ACTUALIZAR ESTADO DE SOLICITUD LUEGO DE ONBOARDING COMPLETO
    // ===================================================================

    @Transactional
    public int markRequestsAsSent(Long clientId) {

        log.info(
                "[CREDIT] Marking requests as ENVIADA | clientId={}",
                clientId
        );

        int updated = creditRequestRepository.updateStatusByClientId(
                clientId,
                CreditRequestStatus.CREADA,
                CreditRequestStatus.ENVIADA
        );

        log.info(
                "[CREDIT] Requests updated | clientId={} count={}",
                clientId,
                updated
        );

        return updated;
    }


    // =========================
    // Listado por cliente
    // =========================

    public List<CreditRequest> getRequestsByClient(Long clientId) {
        return creditRequestRepository.findByClientId(clientId);
    }



    // =========================
    // ENVIO DE SOLICITUDES A COOPERATIVAS POR CLIENTE
    // =========================

    @Transactional
    public int completeOnboardingAndDispatch(Long clientId) {

        // Vincular email → clientId antes de buscar solicitudes
        // (necesario cuando la solicitud fue creada de forma pública sin clientId)
        creditRequestRepository.linkClientIdByEmail(
                authService.getEmailByClientId(clientId),
                clientId
        );

        List<CreditRequest> createdRequests =
                creditRequestRepository.findByClientIdAndEstado(clientId, CreditRequestStatus.CREADA);

        if (createdRequests.isEmpty()) {
            log.info("[CREDIT] No CREADA requests to send | clientId={}", clientId);
            return 0;
        }

        int totalDistributions = 0;

        for (CreditRequest req : createdRequests) {

            int distributed =
                    creditDistributionService.distributeToCityCooperatives(req);

            if (distributed > 0) {
                req.setEstado(CreditRequestStatus.ENVIADA);
                creditRequestRepository.save(req);
                totalDistributions += distributed;

                log.info(
                        "[CREDIT] Request {} marked as ENVIADA (distributed={})",
                        req.getId(), distributed
                );
            } else {
                log.warn(
                        "[CREDIT] Request {} NOT sent (no eligible cooperatives)",
                        req.getId()
                );
                // se queda en CREADA
            }
        }

        log.info("[CREDIT] Onboarding completion processed | clientId={} requests={} distributions={}",
                clientId, createdRequests.size(), totalDistributions);

        return totalDistributions;
    }
    // =========================
    // Actualizar solicitud a solicitando garante por refactorizar
    // =========================

    @Transactional
    public void actualizarEstadoSolicitudCooperativa(
            Long solicitudId,
            Long cooperativaId,
            SolicitudCooperativaStatus nuevoEstado
    ) {
        SolicitudCooperativa sc = solicitudCooperativaRepository
                .findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId)
                .orElseThrow(() ->
                        new IllegalStateException("Solicitud cooperativa no encontrada")
                );

        // Validar transiciÃ³n mÃ­nima
        if (sc.getEstado() != SolicitudCooperativaStatus.ENVIADA) {
            throw new IllegalStateException(
                    "No se puede solicitar garante desde el estado " + sc.getEstado()
            );
        }

        sc.setEstado(nuevoEstado);
        // fechaActualizacion se setea por @PreUpdate
    }

    // =========================
    // Actualizar solicitud a solicitando garante nueva funcionalidad solo desde credit service
    // =========================
    @Transactional
        public void solicitarGarante(Long solicitudId, Long cooperativaId) {
                solicitarGarante(solicitudId, cooperativaId, null);
        }

        @Transactional
    public void solicitarGarante(
            Long solicitudId,
            Long cooperativaId,
            List<CreditRequirementDto> requisitos
    ) {
        SolicitudCooperativa sc = solicitudCooperativaRepository
                .findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId)
                .orElseThrow(() ->
                        new IllegalStateException("Solicitud cooperativa no encontrada")
                );

        // Idempotencia
        if (sc.getEstado() == SolicitudCooperativaStatus.SOLICITANDO_GARANTE) {
            return;
        }

        // Validar transiciÃ³n
        if (sc.getEstado() != SolicitudCooperativaStatus.ENVIADA) {
            throw new IllegalStateException(
                    "No se puede solicitar garante desde el estado " + sc.getEstado()
            );
        }

        CreditRequest creditRequest = sc.getCreditRequest();
        if (creditRequest == null || creditRequest.getAmount() == null
                || creditRequest.getCreditType() == null
                || creditRequest.getPlazoMeses() == null
                || creditRequest.getPlazoMeses() <= 0) {
            throw new IllegalStateException("La solicitud no tiene datos suficientes para calcular la oferta");
        }

        if (cotizacionRepository.findBySolicitudCooperativaId(sc.getId()).isEmpty()) {
            BigDecimal tasaAnual = BigDecimal.valueOf(
                    cooperativeService.getOfferRate(cooperativaId, creditRequest.getAmount(), creditRequest.getPlazoMeses(), creditRequest.getCreditType())
            );
            var calculation = LoanCalculator.calculate(
                    creditRequest.getAmount(),
                    tasaAnual,
                    creditRequest.getPlazoMeses()
            );

            var cotizacion = SolicitudCooperativaCotizacion.builder()
                    .solicitudCooperativaId(sc.getId())
                    .monto(creditRequest.getAmount())
                    .plazoMeses(creditRequest.getPlazoMeses())
                    .tipoCredito(creditRequest.getCreditType())
                    .tasaAnual(tasaAnual)
                    .tasaMensual(calculation.tasaMensual())
                    .cuotaMensual(calculation.cuotaMensual())
                    .totalPagar(calculation.totalPagar())
                    .interesTotal(calculation.interesTotal())
                    .build();
            cotizacionRepository.save(cotizacion);
        }

        sc.setEstado(SolicitudCooperativaStatus.SOLICITANDO_GARANTE);
        creditRequirementService.replaceForOffer(sc.getId(), requisitos);
        addEvent(
                solicitudId,
                sc.getId(),
                "GARANTE_SOLICITADO",
                "La cooperativa solicitó información de un garante."
        );
        notificationService.sendGuaranteeRequiredEmail(
                sc.getCreditRequest().getEmail(),
                cooperativeService.getById(cooperativaId).getNombre()
        );
        if (sc.getCreditRequest().getClientId() != null) {
            pushNotificationService.sendGuaranteeRequired(
                    sc.getCreditRequest().getClientId(),
                    cooperativeService.getById(cooperativaId).getNombre(),
                    solicitudId
            );
        }
    }

    @Transactional
    public void decidirGarante(
            Long solicitudId,
            Long cooperativaId,
            String decision,
            List<CreditRejectionReason> motivosRechazo,
            String motivoRechazoOtro,
            String observacion,
            Long actorId
    ) {
        log.info("[CREDIT_GUARANTEE] Processing decision: requestId={}, cooperativeId={}, decision={}, reasonCount={}",
                solicitudId, cooperativaId, decision, motivosRechazo == null ? 0 : motivosRechazo.size());
        SolicitudCooperativa sc = solicitudCooperativaRepository
                .findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId)
                .orElseThrow(() -> new IllegalStateException("Solicitud cooperativa no encontrada"));

        if (sc.getEstado() != SolicitudCooperativaStatus.SOLICITANDO_GARANTE) {
            throw new IllegalStateException(
                    "La solicitud no está esperando la revisión de un garante"
            );
        }
        String normalizedDecision = normalizeGuarantorDecision(decision);
        var activeSubmission = guarantorWorkflowService.latestSubmission(sc.getId());
        if (activeSubmission == null) {
            if ("SOLICITAR_CORRECCION".equals(normalizedDecision)) {
                List<CreditRejectionReason> reasons = normalizeGuaranteeDecisionReasons(motivosRechazo);
                boolean selectedOther = reasons.contains(CreditRejectionReason.OTROS);
                String other = motivoRechazoOtro == null ? "" : motivoRechazoOtro.trim();
                if (selectedOther && (other.isBlank() || other.length() > 250)) {
                    throw new IllegalArgumentException("Describe el otro motivo (máximo 250 caracteres)");
                }
                if (!selectedOther && !other.isEmpty()) {
                    throw new IllegalArgumentException("Selecciona Otros motivos para enviar una descripción");
                }
                List<String> labels = reasons.stream().map(reason -> reason == CreditRejectionReason.OTROS ? other : reason.getLabel()).toList();
                String cooperativeName = cooperativeService.getById(cooperativaId).getNombre();
                addEvent(solicitudId, sc.getId(), "GARANTE_CORRECCION_SOLICITADA",
                        "Actualiza y vuelve a enviar la información del garante para registrar una evaluación vinculada a este crédito. Motivos: "
                                + String.join("; ", labels) + (observacion == null || observacion.isBlank() ? "" : ". Observación: " + observacion),
                        actorId, "COOPERATIVE");
                try { notificationService.sendGuaranteeReviewUpdateEmail(sc.getCreditRequest().getEmail(), cooperativeName, labels, true, observacion); }
                catch (RuntimeException failure) { log.error("Legacy guarantor resubmission email failed for request {}", solicitudId, failure); }
                if (sc.getCreditRequest().getClientId() != null) {
                    pushNotificationService.sendGuaranteeEvaluationUpdate(sc.getCreditRequest().getClientId(), cooperativeName, labels, solicitudId, true);
                }
                return;
            }
            throw new IllegalStateException("Este garante pertenece al historial anterior. Solicita al cliente reenviar sus datos para crear una evaluación vinculada a este crédito.");
        }
        if (activeSubmission.getStatus() != com.markup.dinerop.credit.domain.model.enums.CreditGuarantorStatus.EN_REVISION) {
            throw new IllegalStateException("La evaluación del garante ya fue resuelta");
        }
        if ("ACEPTAR".equals(normalizedDecision)) {
            Long clientId = sc.getCreditRequest().getClientId();
            if (clientId == null) {
                throw new IllegalStateException("La solicitud no tiene un cliente asociado");
            }
            guarantorWorkflowService.recordDecision(activeSubmission.getId(), "ACEPTAR", List.of(), null,
                    observacion, actorId, "COOPERATIVE");
            sc.setEstado(SolicitudCooperativaStatus.PRE_APROBADA);
            solicitudCooperativaRepository.save(sc);
            addEvent(
                    solicitudId,
                    sc.getId(),
                    "GARANTE_ACEPTADO",
                    "La cooperativa aceptó la información del garante."
            );
            String cooperativeName = cooperativeService.getById(cooperativaId).getNombre();
            var cotizacion = cotizacionRepository.findBySolicitudCooperativaId(sc.getId())
                    .orElseThrow(() -> new IllegalStateException("No existe la oferta calculada para esta solicitud"));
            notificationService.sendCreditOfferEmail(
                    sc.getCreditRequest().getEmail(),
                    cooperativeName,
                    cotizacion.getMonto(),
                    cotizacion.getTasaAnual(),
                    cotizacion.getPlazoMeses(),
                    cotizacion.getCuotaMensual()
            );
            pushNotificationService.sendCreditAccepted(
                    clientId,
                    "Garante aprobado y crédito preaprobado",
                    cooperativeName + " aprobó el garante. Ya puedes revisar la oferta, los requisitos y la constancia en la app.",
                    solicitudId
            );
            return;
        }

        if ("RECHAZAR_SOLICITUD".equals(normalizedDecision)) {
            Long clientId = sc.getCreditRequest().getClientId();
            List<CreditRejectionReason> normalizedReasons = normalizeGuaranteeDecisionReasons(motivosRechazo);
            boolean selectedOther = normalizedReasons.contains(CreditRejectionReason.OTROS);
            String otherReason = motivoRechazoOtro == null ? "" : motivoRechazoOtro.trim();
            if (selectedOther && (otherReason.isBlank() || otherReason.length() > 500)) {
                throw new IllegalArgumentException("Describe el otro motivo (máximo 500 caracteres)");
            }
            if (!selectedOther && !otherReason.isEmpty()) {
                throw new IllegalArgumentException("Selecciona Otros motivos para enviar una descripción");
            }
            guarantorWorkflowService.recordDecision(activeSubmission.getId(), "RECHAZAR_SOLICITUD",
                    normalizedReasons.stream().map(reason -> reason == CreditRejectionReason.OTROS ? otherReason : reason.getLabel()).toList(), selectedOther ? otherReason : null,
                    observacion, actorId, "COOPERATIVE");
            sc.setEstado(SolicitudCooperativaStatus.RECHAZADA);
            sc.setMotivosRechazo(new java.util.ArrayList<>(normalizedReasons));
            sc.setMotivoRechazoOtro(selectedOther ? otherReason : null);
            solicitudCooperativaRepository.save(sc);
            List<String> reasonLabels = normalizedReasons.stream()
                    .map(reason -> reason == CreditRejectionReason.OTROS ? otherReason : reason.getLabel())
                    .toList();
            addEvent(solicitudId, sc.getId(), "CREDITO_RECHAZADO_DURANTE_REVISION_GARANTE",
                    "La cooperativa rechazó la solicitud después de revisar la información del garante.", actorId, "COOPERATIVE");
            String cooperativeName = cooperativeService.getById(cooperativaId).getNombre();
            notificationService.sendCreditRejectionEmail(
                    sc.getCreditRequest().getEmail(), cooperativeName, reasonLabels
            );
            if (clientId != null) {
                pushNotificationService.sendCreditRejected(clientId, cooperativeName, reasonLabels, solicitudId);
            }
            return;
        }

        if ("SOLICITAR_CORRECCION".equals(normalizedDecision) || "RECHAZAR_GARANTE".equals(normalizedDecision)) {
            List<CreditRejectionReason> normalizedReasons = normalizeGuaranteeDecisionReasons(motivosRechazo);
            boolean selectedOther = normalizedReasons.contains(CreditRejectionReason.OTROS);
            String otherReason = motivoRechazoOtro == null ? "" : motivoRechazoOtro.trim();
            if (selectedOther && (otherReason.isBlank() || otherReason.length() > 250)) {
                throw new IllegalArgumentException("Describe el otro motivo (máximo 250 caracteres)");
            }
            if (!selectedOther && !otherReason.isEmpty()) {
                throw new IllegalArgumentException("Selecciona Otros motivos para enviar una descripción");
            }
            Long clientId = sc.getCreditRequest().getClientId();
            if (clientId == null) throw new IllegalStateException("La solicitud no tiene un cliente asociado");
            guarantorWorkflowService.recordDecision(activeSubmission.getId(), normalizedDecision,
                    normalizedReasons.stream().map(reason -> reason == CreditRejectionReason.OTROS ? otherReason : reason.getLabel()).toList(), selectedOther ? otherReason : null,
                    observacion, actorId, "COOPERATIVE");
            sc.setEstado(SolicitudCooperativaStatus.SOLICITANDO_GARANTE);
            addEvent(
                    solicitudId,
                    sc.getId(),
                    "SOLICITAR_CORRECCION".equals(normalizedDecision) ? "GARANTE_CORRECCION_SOLICITADA" : "GARANTE_RECHAZADO",
                    buildGuaranteeRejectionDetail(normalizedReasons, otherReason, normalizedDecision)
                            + (observacion == null || observacion.isBlank() ? "" : ". Observación: " + observacion),
                    actorId, "COOPERATIVE"
            );
            String cooperativeName = cooperativeService.getById(cooperativaId).getNombre();
            List<String> reasonLabels = normalizedReasons.stream()
                    .map(reason -> reason == CreditRejectionReason.OTROS ? otherReason : reason.getLabel())
                    .toList();
            try {
                notificationService.sendGuaranteeReviewUpdateEmail(sc.getCreditRequest().getEmail(), cooperativeName,
                        reasonLabels, "SOLICITAR_CORRECCION".equals(normalizedDecision), observacion);
            } catch (RuntimeException notificationFailure) {
                log.error("[CREDIT_GUARANTEE] Decision saved but retry email failed: requestId={}, cooperativeId={}",
                        solicitudId, cooperativaId, notificationFailure);
            }
            try {
                pushNotificationService.sendGuaranteeEvaluationUpdate(clientId, cooperativeName, reasonLabels,
                        solicitudId, "SOLICITAR_CORRECCION".equals(normalizedDecision));
            } catch (RuntimeException notificationFailure) {
                log.error("[CREDIT_GUARANTEE] Decision saved but push notification failed: requestId={}, cooperativeId={}",
                        solicitudId, cooperativaId, notificationFailure);
            }
            log.info("[CREDIT_GUARANTEE] Decision recorded: requestId={}, cooperativeId={}, decision={}",
                    solicitudId, cooperativaId, normalizedDecision);
            return;
        }

        throw new IllegalArgumentException("Decisión de garante no válida");
    }

    private void addEvent(Long solicitudId, Long solicitudCooperativaId, String tipo, String detalle) {
        addEvent(solicitudId, solicitudCooperativaId, tipo, detalle, null, null);
    }

    private void addEvent(Long solicitudId, Long solicitudCooperativaId, String tipo, String detalle,
                          Long actorId, String actorRole) {
        creditProcessEventRepository.save(CreditProcessEvent.builder()
                .solicitudId(solicitudId)
                .solicitudCooperativaId(solicitudCooperativaId)
                .tipo(tipo)
                .detalle(detalle)
                .actorId(actorId)
                .actorRole(actorRole)
                .build());
    }

    private String normalizeGuarantorDecision(String decision) {
        String normalized = decision == null ? "" : decision.trim().toUpperCase(java.util.Locale.ROOT);
        return switch (normalized) {
            case "SOLICITAR_NUEVO" -> "SOLICITAR_CORRECCION"; // Compatibilidad con el contrato anterior.
            case "RECHAZAR_CREDITO" -> "RECHAZAR_SOLICITUD";
            case "ACEPTAR", "SOLICITAR_CORRECCION", "RECHAZAR_GARANTE", "RECHAZAR_SOLICITUD" -> normalized;
            default -> throw new IllegalArgumentException("Decisión de garante no válida");
        };
    }

    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public List<com.markup.dinerop.credit.dto.CreditGuarantorHistoryItemDto> getGuarantorHistoryForCooperative(
            Long solicitudId, Long cooperativaId) {
        return guarantorWorkflowService.historyForCooperative(solicitudId, cooperativaId);
    }

    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public List<com.markup.dinerop.credit.dto.CreditGuarantorHistoryItemDto> getGuarantorHistoryForClient(
            Long clientId, Long solicitudId, Long cooperativaId) {
        return guarantorWorkflowService.historyForClient(clientId, solicitudId, cooperativaId);
    }

    private String buildGuaranteeRejectionDetail(List<CreditRejectionReason> reasons, String otherReason, String decision) {
        String labels = reasons.stream()
                .map(reason -> reason == CreditRejectionReason.OTROS ? otherReason : reason.getLabel())
                .collect(java.util.stream.Collectors.joining("; "));
        String title = "SOLICITAR_CORRECCION".equals(decision)
                ? "La cooperativa solicita corregir la información del garante. Motivos: "
                : "La cooperativa rechazó al garante. Motivos: ";
        return title + labels;
    }

    private List<CreditRejectionReason> normalizeGuaranteeDecisionReasons(
            List<CreditRejectionReason> reasons
    ) {
        if (reasons == null || reasons.stream().anyMatch(java.util.Objects::isNull)) {
            throw new IllegalArgumentException("Selecciona los motivos correspondientes");
        }
        List<CreditRejectionReason> normalized = reasons.stream().distinct().toList();
        if (normalized.isEmpty() || normalized.size() > 4) {
            throw new IllegalArgumentException("Selecciona entre uno y cuatro motivos");
        }
        return normalized;
    }

}
