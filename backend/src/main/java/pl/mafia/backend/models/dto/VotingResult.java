package pl.mafia.backend.models.dto;

public record VotingResult(
  String username,
  Long voteCount
) {}
