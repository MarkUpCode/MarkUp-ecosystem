package com.markup.dinerop.visits.domain.repository;

import com.markup.dinerop.visits.domain.entity.PageVisit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface PageVisitRepository extends JpaRepository<PageVisit, Long> {

    @Query("""
    SELECT COALESCE(SUM(p.totalVisits),0)
    FROM PageVisit p
    """)
    Long getTotalVisits();
}
