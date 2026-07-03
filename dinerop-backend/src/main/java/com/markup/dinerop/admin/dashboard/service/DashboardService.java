package com.markup.dinerop.admin.dashboard.service;

import com.markup.dinerop.admin.dashboard.dto.*;
import com.markup.dinerop.auth.entity.Role;
import com.markup.dinerop.auth.repository.UserRepository;
import com.markup.dinerop.cooperative.domain.repository.CooperativeRepository;
import com.markup.dinerop.credit.domain.model.CreditRequest;
import com.markup.dinerop.credit.domain.model.enums.CreditRequestStatus;
import com.markup.dinerop.credit.infrastructure.repository.CreditRequestRepository;
import com.markup.dinerop.visits.domain.repository.PageVisitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final UserRepository userRepository;
    private final CooperativeRepository cooperativeRepository;
    private final CreditRequestRepository creditRequestRepository;
    private final PageVisitRepository pageVisitRepository;

    public DashboardResponseDto getDashboard() {

        // ============================
        // USERS
        // ============================

        UserStatsDto users = new UserStatsDto(
                userRepository.count(),
                userRepository.countByRole(Role.CLIENT),
                userRepository.countByRole(Role.COOPERATIVE),
                userRepository.countByRole(Role.ADMIN)
        );

        // ============================
        // COOPERATIVES
        // ============================

        CooperativeStatsDto cooperatives =
                new CooperativeStatsDto(
                        cooperativeRepository.count()
                );

        // ============================
        // CREDITS
        // ============================

        CreditStatsDto credits = new CreditStatsDto(
                creditRequestRepository.count(),
                creditRequestRepository.countByEstado(CreditRequestStatus.CREADA),
                creditRequestRepository.countByEstado(CreditRequestStatus.ENVIADA)
        );

        // ============================
        // VISITS
        // ============================

        Long visits = pageVisitRepository.getTotalVisits();

        VisitStatsDto visitStats =
                new VisitStatsDto(
                        visits == null ? 0 : visits
                );

        // ============================
        // LAST USERS
        // ============================

        List<RecentUserDto> recentUsers =
                userRepository.findTop10ByOrderByCreatedAtDesc()
                        .stream()
                        .map(user -> new RecentUserDto(
                                user.getIdUser(),
                                user.getEmail(),
                                user.getRole(),
                                user.getStatus(),
                                user.getCreatedAt()
                        ))
                        .toList();

        // ============================
        // LAST CREDITS
        // ============================

        List<RecentCreditDto> recentCredits =
                creditRequestRepository.findTop10ByOrderByFechaSolicitudDesc()
                        .stream()
                        .map(this::toRecentCredit)
                        .toList();

        return new DashboardResponseDto(
                users,
                cooperatives,
                credits,
                visitStats,
                recentUsers,
                recentCredits
        );
    }

    private RecentCreditDto toRecentCredit(CreditRequest credit) {

        return new RecentCreditDto(
                credit.getId(),
                credit.getEmail(),
                credit.getAmount(),
                credit.getEstado(),
                credit.getFechaSolicitud()
        );
    }

}