{ pkgs, ... }:
{
  channel = "stable-24.05";
  packages = [ pkgs.python311 pkgs.nodejs_20 ];
  idx.previews = {
    enable = true;
    previews = {
      web = {
        command = [ "python" "-m" "http.server" "$PORT" ];
        manager = "web";
      };
    };
  };
}
