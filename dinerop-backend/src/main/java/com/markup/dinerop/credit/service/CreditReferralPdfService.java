package com.markup.dinerop.credit.service;

import com.lowagie.text.Document;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfWriter;
import com.markup.dinerop.auth.entity.User;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.cooperative.domain.entity.Cooperative;
import com.markup.dinerop.cooperative.domain.service.CooperativeService;
import com.markup.dinerop.credit.domain.model.CreditRequest;
import com.markup.dinerop.credit.domain.model.SolicitudCooperativa;
import com.markup.dinerop.credit.infrastructure.repository.CreditRequestRepository;
import com.markup.dinerop.credit.infrastructure.repository.SolicitudCooperativaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CreditReferralPdfService {
    private final SolicitudCooperativaRepository offerRepository;
    private final CreditRequestRepository creditRequestRepository;
    private final UserRepository userRepository;
    private final CooperativeService cooperativeService;

    @Transactional(readOnly = true)
    public byte[] generate(Long clientId, Long solicitudId, Long cooperativaId) {
        User user = userRepository.findById(clientId).orElseThrow();
        CreditRequest request = creditRequestRepository.findById(solicitudId).orElseThrow();
        if (!clientId.equals(request.getClientId())) throw new IllegalArgumentException("Solicitud no pertenece al usuario");
        SolicitudCooperativa offer = offerRepository.findBySolicitudIdAndCooperativaId(solicitudId, cooperativaId).orElseThrow();
        Cooperative cooperative = cooperativeService.getById(cooperativaId);
        try {
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            Document document = new Document();
            PdfWriter.getInstance(document, output);
            document.open();
            document.add(new Paragraph("DINEROP"));
            document.add(new Paragraph("CONSTANCIA DE REFERENCIA DE CREDITO"));
            document.add(new Paragraph(" "));
            document.add(new Paragraph("Este documento confirma que la persona indicada fue referida desde la plataforma Dinerop."));
            document.add(new Paragraph(" "));
            document.add(new Paragraph("Codigo de validacion: " + UUID.randomUUID()));
            document.add(new Paragraph("Solicitud: #" + request.getId()));
            document.add(new Paragraph("Fecha: " + request.getFechaSolicitud().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))));
            document.add(new Paragraph("Cliente: " + user.getEmail()));
            document.add(new Paragraph("Cooperativa: " + cooperative.getNombre()));
            document.add(new Paragraph("Monto solicitado: $" + request.getAmount()));
            document.add(new Paragraph(" "));
            document.add(new Paragraph("Presentar esta constancia junto con los requisitos solicitados en la oficina de la cooperativa."));
            document.add(new Paragraph(" "));
            document.add(new Paragraph("Sello y firma de la cooperativa: ______________________________"));
            document.close();
            return output.toByteArray();
        } catch (Exception exception) {
            throw new IllegalStateException("No se pudo generar la constancia PDF", exception);
        }
    }
}
