enum SystemStatus {
  healthy,
  unhealthy,
  dead
}

SystemStatus stringToStatus(String? value) {
  if (value == null) return SystemStatus.dead;

  String statusString = value.toLowerCase();

  switch (statusString) {
    case "healthy":
      return SystemStatus.healthy;
    case "unhealthy":
      return SystemStatus.unhealthy;
    case "dead":
      return SystemStatus.dead;
    default:
      return SystemStatus.dead;
  }
 }