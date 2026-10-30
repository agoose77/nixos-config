{
  flake.modules.homeManager.notes = {
    config,
    pkgs,
    ...
  }: let
    notesDir = "${config.xdg.dataHome}/notes";
  in {
    programs.bash.initExtra = ''
      n() {
      (
        set -eu

        local arg="''${1:-0}"

        # Parse argument: supports n 3 or n '~3'
        local days_back=0
        if [[ "$arg" =~ ^~([0-9]+)$ ]]; then
          days_back="''${BASH_REMATCH[1]}"
        elif [[ "$arg" =~ ^[0-9]+$ ]]; then
          days_back="$arg"
        fi

        # Date calculation
        local target_date=$(date -d "$days_back day ago" +%F)

        local file="${notesDir}/$target_date.md"
        mkdir -p "${notesDir}"

        if [[ ! -e "$file" ]]; then
            echo "# $(date -d $target_date '+%a, %-d %b %Y')" >> "$file"
        fi

        ''${EDITOR:-nvim} "$file"
      )
      }
    '';
    home.file."${notesDir}/myst.yml".text = ''
      version: 1
      project:
        id: 6b2e2ad6-9c50-477b-9fa6-53f4fcd6e8a4
        # title:
        # description:
        # keywords: []
        # authors: []
        # github:
        # To autogenerate a Table of Contents, run "myst init --write-toc"
      site:
        template: book-theme
        options:
          logo_text: "Angus' Notes"
        #   favicon: favicon.ico
        #   logo: site_log
    '';

    # Serve notes as MyST project
    systemd.user.services.notes-server = {
      Unit = {
        Description = "Serve Markdown notes as a MyST project.";
        After = ["graphical-session.target"];
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.lib.getExe pkgs.local.myst} start --port 9999 --server-port 9998";
        WorkingDirectory = notesDir;
      };
    };
  };
}
