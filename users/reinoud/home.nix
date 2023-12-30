{ pkgs, inputs, ... }:
# { config, pkgs, inputs, ... }:
{
  imports = [ 
    # inputs.nix-colors.homeManagerModules.default
    # nix-colors.homeManagerModules.default
    # ./features/alacritty.nix
];


  home.username = "reinoud";
  home.homeDirectory = "/home/reinoud";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
  ];

  home.file = {
    ".config/alacritty/alacritty.yml".text = ''
      colors:
        primary:
          background: '#2f302f'
      cursor:
        style:
          shape:
            Beam
      font:
        size: 8.0
   '';

    ".vimrc".source = ./../../programs/vim/vimrc;

    ".config/i3" = {
     source = ~/.dotfiles/programs/i3;
     recursive = true; 
    };

    ".config/dunst" = {
      source = ~/.dotfiles/programs/dunst; 
     recursive = true; 
    };
  };

  home.sessionVariables = {
  };

  programs = {
    git = {
      enable = true;
      userName = "GrannyCadet";
      userEmail = "s141959@ap.be ";
    };
    firefox = {
      enable = true;
      profiles.reinoud = {
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
        ];

        bookmarks = [
          {
            name = "wikipedia";
            tags = [ "wiki" ];
            keyword = "wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
          }
        ];

        search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
        search.force = true;

        settings = {
          "dom.security.https_only_mode" = true;
          "browser.download.panel.shown" = true;
          "identity.fxaccounts.enabled" = false;
          "signon.rememberSignons" = false;
        };
      };

    };
      neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      extraPackages = with pkgs; [
        lua-language-server
        pyright
        shellcheck
        rnix-lsp

        vimPlugins.nvim-cmp

        xclip
      ];
      withPython3 = true;
      viAlias = false;
      vimAlias = false;
      vimdiffAlias = false;
      enable = true;
      extraLuaConfig = ''
        ${builtins.readFile ./../../programs/nvim/options.lua}
      '';
      plugins = with pkgs.vimPlugins; [
        # nvim-telescope
        nvim-lspconfig

        

        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }

        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./../../programs/nvim/plugin/lsp.lua;
        }

        {
          plugin = fugitive;
          config = "";
        }

        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-python
            p.tree-sitter-bash
          ]));
          config = toLuaFile ./../../programs/nvim/plugin/treesitter.lua;
        }
        vim-nix # idk what this does
      ];
    };
    lf = {
      enable = true;
      settings = {
        preview = true;
        drawbox = true;
        icons = true;
       ignorecase = true; 
      };
      keybindings = {
        "<enter>" = "open";
        V = ''$${pkgs.bat}/bin/bat "$f"'';
        "." = "set hidden!";
        c = "mkdir";
        a = ''$$EDITOR'';
      };
      commands = {
        dragon-out = ''${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        e = ''$$EDITOR $f'';
        sh = ''$echo $(pwd) > /tmp/.screenshotpath'';
        mkdir = ''
         ''${{
            printf "Directory Name: " 
            read DIR
            mkdir $DIR
          }}
        '';
        extract = ''
          ''${{
            set -f
            case $f in
            *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
            *.tar.gz|*.tgz) tar xzvf $f;;
            *.tar.xz|*.txz) tar xJvf $f;;
            *.zip) unzip $f;;
            *.rar) unrar x $f;;
            *.7z) 7z x $f;;
            esac
          }}
        '';
        tar = ''
          ''${{
          set -f
          mkdir $1
          cp -r $fx $1
          tar czf $1.tar.gz $1
          rm -rf $1
        }}'';
        zip = ''
          ''${{
          set -f
          mkdir $1
          cp -r $fx $1
          zip -r $1.zip $1
          rm -rf $1
        }}'';
      }; 

      extraConfig = 
          let 
            previewer = 
              pkgs.writeShellScriptBin "pv.sh" ''
              file=$1
              w=$2
              h=$3
              x=$4
              y=$5
              
              if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
                  ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
                  exit 1
              fi
              
              ${pkgs.pistol}/bin/pistol "$file"
            '';
            cleaner = pkgs.writeShellScriptBin "clean.sh" ''
              ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
            '';
          in
          ''
            set cleaner ${cleaner}/bin/clean.sh
            set previewer ${previewer}/bin/pv.sh
          '';
      };

    home-manager.enable = true;
  };


services = {
  dunst = {
    enable = true;
  };
};

nixpkgs.config = {
  packageOverrides = pkgs: rec{
    dmenu = pkgs.dmenu.override {
      patches = [
        ./../programs/dmenu/insencitive.diff 
        ./../programs/dmenu/lineheight.diff 
      ]; 
    }; 
  }; 
};
}
