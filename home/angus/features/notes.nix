{...}: {
  programs.bash.initExtra = ''
    n() {
      local logdir="$HOME/notes"
      local days_back=0

      # Parse argument: supports n 3 or n '~3'
      if [[ "$1" =~ ^~([0-9]+)$ ]]; then
        days_back="''${BASH_REMATCH[1]}"
      elif [[ "$1" =~ ^[0-9]+$ ]]; then
        days_back="$1"
      fi

      # Date calculation
      local target_date=$(date -d "$days_back day ago" +%F)

      local file="$logdir/$target_date.md"
      mkdir -p "$logdir"
      touch "$file"

      ''${EDITOR:-nvim} "$file"
    }
  '';
}
