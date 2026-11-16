package com.markup.dinerop.credit.infrastructure.repository;

import com.markup.dinerop.credit.domain.model.CreditGuarantorEvaluation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CreditGuarantorEvaluationRepository extends JpaRepository<CreditGuarantorEvaluation, Long> {
    List<CreditGuarantorEvaluation> findBySubmissionIdInOrderByCreatedAtAscIdAsc(List<Long> submissionIds);
    List<CreditGuarantorEvaluation> findBySubmissionIdOrderByCreatedAtAscIdAsc(Long submissionId);
}
