# ~/.config/fish/config.fish: DO NOT EDIT -- this file has been generated
# automatically by home-manager.

# Only execute this file once per shell.
set -q __fish_home_manager_config_sourced; and exit
set -g __fish_home_manager_config_sourced 1

set --prepend fish_function_path /nix/store/nmm849yckcinrwfyjd46pis8664pnlr7-fishplugin-foreign-env-unstable-2020-02-09/share/fish/vendor_functions.d
fenv source /home/reinoud/.nix-profile/etc/profile.d/hm-session-vars.sh >/dev/null
set -e fish_function_path[1]



status --is-login; and begin

    # Login shell initialisation


end

status --is-interactive; and begin

    # Abbreviations


    # Aliases
    alias applysystem '/home/reinoud/;dotfiles/apply-system.sh'
    alias applyuser '/home/reinoud/;dotfiles/apply-user.sh'
    alias dot 'cd /home/reinoud/.dotfiles/'

    # Interactive shell initialisation
    # add completions generated by Home Manager to $fish_complete_path
    begin
        set -l joined (string join " " $fish_complete_path)
        set -l prev_joined (string replace --regex "[^\s]*generated_completions.*" "" $joined)
        set -l post_joined (string replace $prev_joined "" $joined)
        set -l prev (string split " " (string trim $prev_joined))
        set -l post (string split " " (string trim $post_joined))
        set fish_complete_path $prev "/home/reinoud/.local/share/fish/home-manager_generated_completions" $post
    end


end