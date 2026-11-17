package com.markup.dinerop.cooperative.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "investment_acceptance_responses", uniqueConstraints =
        @UniqueConstraint(name = "uk_investment_acceptance_request", columnNames = "request_id"))
@Getter @Setter @NoArgsConstructor
public class InvestmentAcceptanceRecord {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "request_id", nullable = false) private Long requestId;
    @Column(name = "cooperative_id", nullable = false) private Long cooperativeId;
    @Column(name = "actor_user_id", nullable = false) private Long actorUserId;
    @Column(name = "acceptance_message", nullable = false, length = 2000) private String acceptanceMessage;
    @Column(name = "confirmed_annual_rate", precision = 7, scale = 4) private java.math.BigDecimal confirmedAnnualRate;
    @Column(name = "agency_name", nullable = false, length = 160) private String agencyName;
    @Column(name = "agency_address", nullable = false, length = 300) private String agencyAddress;
    @Column(name = "agency_city", nullable = false, length = 120) private String agencyCity;
    @Column(name = "maps_url", length = 1000) private String mapsUrl;
    @Column(name = "contact_phone", length = 40) private String contactPhone;
    @Column(name = "opening_hours", length = 300) private String openingHours;
    @Column(name = "contact_department", length = 160) private String contactDepartment;
    @Column(name = "response_deadline") private LocalDate responseDeadline;
    @Column(length = 2000) private String instructions;
    @Column(name = "responded_at", nullable = false) private Instant respondedAt;
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "investment_acceptance_requirements", joinColumns = @JoinColumn(name = "acceptance_id"))
    @OrderColumn(name = "display_order")
    private List<Requirement> requirements = new ArrayList<>();

    @PrePersist void onCreate() { if (respondedAt == null) respondedAt = Instant.now(); }

    @Embeddable @Getter @Setter @NoArgsConstructor
    public static class Requirement {
        @Column(name = "description", nullable = false, length = 250) private String description;
        @Column(name = "mandatory", nullable = false) private boolean mandatory;
        public Requirement(String description, boolean mandatory) { this.description = description; this.mandatory = mandatory; }
    }
}

