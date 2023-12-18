{ config, pkgs, inputs, ... }:
{
  imports = [ 
];


  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "reinoud";
  home.homeDirectory = "/home/reinoud";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # inputs.xremap-flake.packages.${system}.default
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/reinoud/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    #EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs = {
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
      };
      commands = {
        dragon-out = ''${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        e = ''$$EDITOR $f'';
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


programs = {
  git = {
    enable = true;
    userName = "GrannyCadet";
    userEmail = "s141959@ap.be ";
  };
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
