{ config, pkgs, ...}:

{
  programs.firefox = {
    enable = true;
    profiles.reinoud = {

            extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
      ];

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/Packages";  
            params = [
              { name = "type"; value = "Packages";} 
              { name = "query"; value = "{searchTerms}";}
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
      };
      search.force = true;

      bookmarks = [
        {
          name = "wikipedia";
          tags = [ "wiki" ];
          keyword = "wiki";
          url = "https://wikipedia.org/wiki/Special:Search?search=%s&go/Go";

        } 
      ];
         
    };
};
}
