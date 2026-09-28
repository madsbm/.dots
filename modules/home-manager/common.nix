{ config, pkgs, ... }:

{
  imports = [
    ./theming/default.nix
    ./programs/spicetify/mod.nix
    ./programs/kitty/mod.nix
    ./programs/zsh/mod.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    fzf
  ];

  services.polkit-gnome.enable = true;
  services.mpris-proxy.enable = true;

  programs.ssh = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
      "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";

      "workbench.colorTheme" = "GitHub Dark (Web Based)";
      "workbench.iconTheme" = "vscode-icons";

      "glassit.alpha" = 255;
      "security.workspace.trust.untrustedFiles" = "open";
      "security.workspace.trust.startupPrompt" = "never";
      "security.workspace.trust.enabled" = false;
      "redhat.telemetry.enabled" = true;
      "terminal.integrated.defaultProfile.windows" = "Git Bash";
      "terminal.external.linuxExec" = "kitty";
      "tailwindCSS.emmetCompletions" = true;
      "tailwindCSS.inspectPort" = 3000;
      "editor.quickSuggestions" = {
        "strings" = "on";
      };
      "editor.quickSuggestionsDelay" = 0;
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "java.compile.nullAnalysis.nonnull" = [
        "javax.annotation.Nonnull"
        "org.eclipse.jdt.annotation.NonNull"
        "org.springframework.lang.NonNull"
      ];
      "gitlens.codeLens.enabled" = false;
      "gitlens.hovers.enabled" = false;
      "gitlens.views.repositories.pullRequests.enabled" = false;
      "gitlens.views.repositories.showCommits" = false;
      "gitlens.views.repositories.showBranches" = false;
      "gitlens.views.repositories.showStashes" = false;
      "gitlens.views.repositories.showTags" = false;
      "gitlens.views.repositories.showContributors" = false;
      "gitlens.views.repositories.autoRefresh" = false;
      "gitlens.views.repositories.autoReveal" = false;
      "gitlens.views.repositories.avatars" = false;
      "gitlens.views.repositories.files.compact" = false;
      "vscord.app.name" = "Visual Studio Code";
      "[python]" = {
        "editor.formatOnType" = true;
      };
      "git.enabled" = false;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "editor.largeFileOptimizations" = false;
      "editor.minimap.enabled" = false;
      "gitlens.advanced.messages" = {
        "suppressGitDisabledWarning" = true;
        "suppressGitMissingWarning" = true;
      };
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "remote.SSH.remotePlatform" = {
        "192.121.118.64" = "linux";
        "188.34.166.18" = "linux";
      };
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "github.copilot.editor.enableAutoCompletions" = true;
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "explorer.confirmDragAndDrop" = false;
      "editor.detectIndentation" = false;
      "editor.insertSpaces" = false;
      "dotnet.server.useOmnisharp" = true;
      "vscord.status.idle.enabled" = false;
      "vscord.status.idle.check" = false;
      "vscord.status.problems.enabled" = false;
      "LaravelExtraIntellisense.modelAccessorCase" = "camel";
      "intelliphp.inlineSuggestionsEnabled" = false;
      "files.associations" = {
        "*.blade.php" = "php";
      };
      "laraphense.disableCurlyBracesSpacer" = true;
      "php.validate.enable" = true;
      "[dart]" = {
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.rulers" = [ 80 ];
        "editor.selectionHighlight" = false;
        "editor.tabCompletion" = "onlySnippets";
        "editor.wordBasedSuggestions" = "off";
      };
      "kotlin.languageServer.enabled" = false;
      "kotlin.debugAdapter.enabled" = false;
      "laravel-pint.enable" = true;
      "editor.formatOnSave" = true;
      "terminal.integrated.profiles.linux" = {
        "bash" = {
          "path" = "bash";
          "icon" = "terminal-bash";
        };
        "zsh" = {
          "path" = "zsh";
        };
        "fish" = {
          "path" = "fish";
        };
        "tmux" = {
          "path" = "tmux";
          "icon" = "terminal-tmux";
        };
        "pwsh" = {
          "path" = "pwsh";
          "icon" = "terminal-powershell";
        };
      };
      "terminal.integrated.profiles.windows" = {
        "PowerShell" = {
          "source" = "PowerShell";
          "icon" = "terminal-powershell";
        };
        "Command Prompt" = {
          "path" = [
            "\${env:windir}\\Sysnative\\cmd.exe"
            "\${env:windir}\\System32\\cmd.exe"
          ];
          "args" = [ ];
          "icon" = "terminal-cmd";
        };
        "Git Bash" = {
          "source" = "Git Bash";
        };
        "MSYS2" = {
          "path" = "C:\\msys64\\usr\\bin\\bash.exe";
          "args" = [ "--login" "-i" ];
          "env" = {
            "CHERE_INVOKING" = "1";
          };
        };
      };
      "vscord.status.idle.timeout" = 300000;
      "prettier.tabWidth" = 4;
      "prettier.useTabs" = true;
      "liveServer.settings.donotShowInfoMsg" = true;
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[vue]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "docker.extension.enableComposeLanguageServer" = false;
      "[php]" = {
        "editor.defaultFormatter" = "DEVSENSE.phptools-vscode";
      };
      "security.promptForLocalFileProtocolHandling" = false;
      "prettier.printWidth" = 60;
      "database-client.autoSync" = true;
      "better-comments.highlightPlainText" = true;
      "better-comments.tags" = [
        {
          "tag" = "FIXME";
          "color" = "#ff3c00";
          "strikethrough" = false;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = true;
        }
        {
          "tag" = "TODO";
          "color" = "#00aaff";
          "strikethrough" = false;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = true;
        }
        {
          "tag" = "NOTE";
          "color" = "#fffb00";
          "strikethrough" = false;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = true;
        }
      ];
      "terminal.integrated.stickyScroll.enabled" = false;
      "[dockercompose]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
        "editor.autoIndent" = "advanced";
        "editor.quickSuggestions" = {
          "other" = true;
          "comments" = false;
          "strings" = true;
        };
        "editor.defaultFormatter" = "redhat.vscode-yaml";
      };
      "[github-actions-workflow]" = {
        "editor.defaultFormatter" = "redhat.vscode-yaml";
      };
      "workbench.startupEditor" = "none";
      "settingsSync.ignoredSettings" = [
        "terminal.integrated.fontFamily"
      ];
      "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
      "terminal.integrated.unicodeVersion" = "11";
      "terminal.integrated.gpuAcceleration" = "on";
      "material-code.primaryColor" = "#52517E";
      "terminal.integrated.initialHint" = false;
      "terminal.integrated.allowedLinkSchemes" = [
        "file"
        "http"
        "https"
        "mailto"
        "vscode"
        "vscode-insiders"
        "ms-settings"
      ];
      "chat.disableAIFeatures" = true;
      "claudeCode.preferredLocation" = "panel";
      "css.lint.unknownAtRules" = "ignore";
      "claudeCode.hideOnboarding" = true;
      "js/ts.experimental.useTsgo" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      github.github-vscode-theme
      vscode-icons-team.vscode-icons

      jnoortheen.nix-ide

      redhat.vscode-yaml
      redhat.vscode-xml

      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-java-dependency
      vscjava.vscode-java-pack
      vscjava.vscode-gradle
      vscjava.vscode-maven

      vue.volar
      rust-lang.rust-analyzer
      ms-python.python
      ms-python.debugpy
      ms-python.vscode-pylance
      ms-python.vscode-python-envs
      dart-code.flutter
      dart-code.dart-code
      prisma.prisma
      tamasfe.even-better-toml
      bmewburn.vscode-intelephense-client

      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      ms-dotnettools.vscode-dotnet-runtime
      visualstudiotoolsforunity.vstuc

      docker.docker
      ms-azuretools.vscode-docker
      ms-azuretools.vscode-containers
      ms-vscode-remote.remote-wsl

      graphql.vscode-graphql
      graphql.vscode-graphql-syntax
      dbaeumer.vscode-eslint
      ecmel.vscode-html-css
      editorconfig.editorconfig
      bierner.github-markdown-preview

      esbenp.prettier-vscode

      anthropic.claude-code
    ];
  };
}
