{
  writers,
  pkgs,
}:
writers.writePython3Bin "hass-dashboard" {libraries = [pkgs.python3Packages.pyyaml];} ''
  import yaml
  import sys
  import argparse

  parser = argparse.ArgumentParser()
  parser.add_argument("dashboard", type=argparse.FileType("r"))
  parser.add_argument("section", type=argparse.FileType("r"))
  args = parser.parse_args()

  dashboard = yaml.safe_load(args.dashboard.read())
  for section in dashboard['views']:
      if section.get('path') != "automations":
          continue

      section['sections'] = yaml.safe_load(args.section.read())

  yaml.dump(dashboard, sys.stdout)
''
