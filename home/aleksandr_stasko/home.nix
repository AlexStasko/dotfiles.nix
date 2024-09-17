{
  inputs,
  pkgs,
  config,
  ...
}: let
  awscli2 = pkgs.awscli2;
  delta = pkgs.delta;
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  system = pkgs.system;
in {
  home.stateVersion = "24.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      PATH = "$GOPATH/bin:$PATH";
      DOCS_HOME = "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/second-brain";
    };

    packages = with pkgs; [
      _1password
      _1password-gui
      arc-browser
      awscli2
      discord
      doppler
      fd
      gh
      hey
      httpie
      jq
      k9s
      kubectl
      kubernetes-helm
      ripgrep
      rustup
      tenv
      terraform-docs
      tfsec
      tldr
      yq
      raycast
      spotify
      slack
    ];

    file = {
      "Library/Application Support/k9s/skin.yml".source = ../../config/k9s/skin.yml;
    };
  };

  programs = {
    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local wezterm = require 'wezterm'
        local config = wezterm.config_builder()

        config.font = wezterm.font_with_fallback {
          'GeistMono Nerd Font',
          'Font Awesome',
        }
        config.font_size = 20

        config.color_scheme = 'Catppuccin Macchiato'
        config.window_background_opacity = 0.8
        config.macos_window_background_blur = 10

        config.default_prog = { 'zsh', '-c', 'exec ${config.home.profileDirectory}/bin/tmux' }
        config.enable_tab_bar = false

        return config
      '';
    };

    bat = {
      enable = true;
      config = {theme = "catppuccin";};
      themes = {
        catppuccin = {
          src =
            pkgs.fetchFromGitHub
            {
              owner = "catppuccin";
              repo = "bat";
              rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
              sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
            };
          file = "themes/Catppuccin Macchiato.tmTheme";
        };
      };
    };

    bottom.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    pyenv = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;

      userEmail = "aleksandr.stasko@burberry.com";
      userName = "Aleksandr Stasko";

      extraConfig = {
        color.ui = true;
        core.editor = "nvim";
        diff.colorMoved = "zebra";
        fetch.prune = true;
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        pull.rebase = true;
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_rsa";
      };

      delta = {
        enable = true;
        package = delta;
        options = {
          chameleon = {
            blame-code-style = "syntax";
            blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
            blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
            dark = true;
            file-added-label = "[+]";
            file-copied-label = "[==]";
            file-decoration-style = "#434C5E ul";
            file-modified-label = "[*]";
            file-removed-label = "[-]";
            file-renamed-label = "[->]";
            file-style = "#434C5E bold";
            hunk-header-style = "omit";
            keep-plus-minus-markers = true;
            line-numbers = true;
            line-numbers-left-format = " {nm:>1} │";
            line-numbers-left-style = "red";
            line-numbers-minus-style = "red italic black";
            line-numbers-plus-style = "green italic black";
            line-numbers-right-format = " {np:>1} │";
            line-numbers-right-style = "green";
            line-numbers-zero-style = "#434C5E italic";
            minus-emph-style = "bold red";
            minus-style = "bold red";
            plus-emph-style = "bold green";
            plus-style = "bold green";
            side-by-side = true;
            syntax-theme = "Nord";
            zero-style = "syntax";
          };
          features = "chameleon";
          side-by-side = true;
        };
      };
    };

    go = {
      enable = true;
      goPath = "Development/language/go";
    };

    lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --color-only --dark --paging=never";
            useConfig = false;
          };
        };
      };
    };

    neovim = inputs.astasko-nvim.lib.mkHomeManager {inherit system;};

    nnn = {
      enable = true;
      package = pkgs.nnn.override {withNerdIcons = true;};
      plugins = {
        mappings = {
          K = "preview-tui";
        };
        src = pkgs.nnn + "/plugins";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
      };
    };

    tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
      clock24 = true;
      mouse = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor 'macchiato'
            set -g @catppuccin_window_right_separator "█ "
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_window_middle_separator " | "
            set -g @catppuccin_window_default_fill "none"
            set -g @catppuccin_window_current_fill "all"
            set -g @catppuccin_status_modules_right "application session user host date_time"
            set -g @catppuccin_status_left_separator "█"
            set -g @catppuccin_status_right_separator "█"
            set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M:%S"
          '';
        }
      ];
      extraConfig = ''
      '';
      shell = "${pkgs.zsh}/bin/zsh";
      terminal =
        if isDarwin
        then "screen-256color"
        else "xterm-256color";
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;

      initExtra = ''
        n () {
          if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
            echo "nnn is already running"
            return
          fi

          export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

          nnn -adeHo "$@"

          if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
          fi
        }
        qn() {
          pushd $DOCS_HOME
          fileName=$(date +%Y%m%d%H%M)
          if [[ -n $1 ]]; then
            fileName=$fileName-$1.md
          else
            fileName=$fileName.md
          fi
          nvim $fileName
          popd
        }
        sb() {
          pushd $DOCS_HOME
          nvim .
          popd
        }
      '';

      oh-my-zsh = {
        enable = true;
        plugins = ["git" "z" "aws"];
        theme = "robbyrussell";
      };

      shellAliases = {
        cat = "bat";
        lg = "lazygit";
        ll =
          if isDarwin
          then "n"
          else "n -P K";
        nb = "nix build --json --no-link --print-build-logs";
        s = ''doppler run --config "nixos" --project "$(whoami)"'';
        wt = "git worktree";
        v = "nvim";
        k = "kubectl";
      };

      syntaxHighlighting = {
        enable = true;
      };
    };
  };

  # security.pam.enableSudoTouchIdAuth = true;
}
