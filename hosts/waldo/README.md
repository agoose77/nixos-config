# Waldo

Waldo is an ASUS Zenbook DUO 14 (2014). It has dual touch screens, with a removable keyboard that magnetically attaches to the lower screen. This keyboard uses BLE when disconnected from the chassis, or a USB-over-magsafe-like connecter.

## Dual-boot Keyboard

To support dual-booting without re-pairing the keyboard, the following steps (adapted from https://gist.github.com/japgolly/e6a08fbac9b1b254b5227dd61ee8c36f) were taken:

1. Pair keyboard in linux (it is to have the files you will need to edit later)
2. Pair keyboard in Windows (11).
3. Reboot and go back to Linux
4. Mount the Windows partition, This step will prompt you for the Bitlocker recovery key:
   ```shell
   sudo mkdir /tmp/bitlocker
   sudo dislocker -r -V /dev/nvme0n1p3 -p -- /tmp/bitlocker/
   sudo mount mount -t ntfs3 -r -o loop /tmp/bitlocker/dislocker-file /tmp/mount
   ```
5. As root, switch to the `config` folder

   ```
   su
   cd /tmp/mount/Windows/System32/config
   ```

6. Execute `chntpw`

   ```
   chntpw -e SYSTEM
   ```

7. In the `chntpw` console, enter in the bluetooth registry keys list like this:

   ```
   cd \ControlSet001\Services\BTHPORT\Parameters\Keys
   ```

8. Run `ls` to list the `Unique id`s

   ```
   (...)\Services\BTHPORT\Parameters\Keys> ls
   Node has 1 subkeys and 0 values
     key name
     <dc45469190c8>
   ```

   E.g. `00:F4:8D:9E:41:AA`

9. `cd` into each `Unique id` folder to search for your MAC address of your bluetooth device in each `value name`
   ```
   (...)\Services\BTHPORT\Parameters\Keys> cd dc45469190c8
   (...)\BTHPORT\Parameters\Keys\dc45469190c8> ls
   Node has 1 subkeys and 2 values
     key name
     <f61a5bb60ad3>
     size     type              value name             [value if type DWORD]
       16  3 REG_BINARY         <CentralIRK>
       16  3 REG_BINARY         <08bfa0f9f03b>
   ```
10. `cd` into the key

    ```
    (...)\BTHPORT\Parameters\Keys\dc45469190c8> cd f61a5bb60ad3

    (...)\Parameters\Keys\dc45469190c8\f61a5bb60ad3> ls
    Node has 0 subkeys and 9 values
      size     type              value name             [value if type DWORD]
        16  3 REG_BINARY         <LTK>
         4  4 REG_DWORD          <KeyLength>               16 [0x10]
         8  b REG_QWORD          <ERand>
         4  4 REG_DWORD          <EDIV>                     0 [0x0]
        16  3 REG_BINARY         <IRK>
         8  b REG_QWORD          <Address>
         4  4 REG_DWORD          <AddressType>              1 [0x1]
         4  4 REG_DWORD          <CEntralIRKStatus>         1 [0x1]
         4  4 REG_DWORD          <AuthReq>                 45 [0x2d]
    ```

11. Pull out the hex codes for `IRK` and `LTK` with `hex IRK`, etc.
    ```
    (...)\Parameters\Keys\dc45469190c8\f61a5bb60ad3> hex IRK
    Value <IRK> of type REG_BINARY (3), data length 16 [0x10]
    :00000  02 D3 C9 3B FD C7 ED 5A 17 D0 F6 1A 5B B6 0A D3 ...;...Z....[...
    ```
12. `cd` to the following directory `/var/lib/bluetooth/<UNIQUE-ID>/` where `<UNIQUE-ID>` is a placeholder which should be replaced by the proper hex-form `AA:BB:...` form of the ID in step 9, e.g. `DC:45:46:91:90:C8`
13. `mv` the existing subdirectory, which will have a similar but non-equal name to the Windows MAC address, so that it has the name given in step 10, e.g. `F6:1A:5B:B6:0A:D3` instead of `F6:1A:5B:B6:09:D3`
14. Edit the `info` file, and set:

- The `IdentityResolvingKey` to the proper hex-form of `IRK`.
- The `SlaveLongTermKey` and `PeripheralLongTermKey` to the proper hex-form of `LTK`.

14. Save and restart the bluetooth service in Linux and you are ready to go
    ```
    sudo systemctl restart bluetooth.service
    ```
