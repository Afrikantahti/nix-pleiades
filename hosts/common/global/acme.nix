{ lib, ... }:
{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "eu@da.me";
    acceptTerms = true;
  };

  environment.persistence = {
    "/persist" = {
      directories = [
        "/var/lib/acme"
      ];
    };
  };
}
