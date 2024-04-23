package pl.mafia.backend.models.dto;

import java.util.List;

public record VotingSummary(
  List<VotingResult> results
) {}
