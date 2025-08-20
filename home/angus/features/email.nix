{
  accounts.email = {
    accounts."goosey15@gmail.com" = {
      primary = true;
      address = "goosey15@gmail.com";
      flavor = "gmail.com";
      realName = "Angus Hollands";
      thunderbird.enable = true;
    };
    accounts."ahollands@2i2c.org" = {
      address = "ahollands@2i2c.org";
      flavor = "gmail.com";
      realName = "Angus Hollands";
      thunderbird.enable = true;
    };
    accounts."angus.hollands@outlook.com" = {
      address = "angus.hollands@outlook.com";
      flavor = "outlook.office365.com";
      realName = "Angus Hollands";
      thunderbird.enable = true;
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };
}
