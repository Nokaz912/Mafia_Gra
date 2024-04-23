package pl.mafia.backend.models.dto;

import lombok.Data;
import lombok.NonNull;

@Data
public class GameStartDTO {
  @NonNull Long id;
  @NonNull String role;
}
