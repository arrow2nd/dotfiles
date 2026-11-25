{ config, pkgs, lib, ... }:

let
  dictionaries = import ../../pkgs/skk-dictionaries.nix { inherit pkgs; };
in
{
  home.file = {
    ".skk/SKK-JISYO.L".source = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
    ".skk/skk-jisyo.imas.utf8".source = dictionaries.imas;
    ".skk/skk-jisyo-emoji-ja.utf8".source = dictionaries.emoji;
  };

  # AltTriggerKeys（デフォルトは Shift_L）が大文字入力や範囲選択のたびに
  # 英/かなを切り替えて誤爆するため、空にして無効化する
  xdg.configFile."fcitx5/config".text = ''
    [Hotkey]
    # Enumerate when holding modifier of Toggle key
    EnumerateWithTriggerKeys=True
    # Enumerate Input Method Forward
    EnumerateForwardKeys=
    # Enumerate Input Method Backward
    EnumerateBackwardKeys=
    # Skip first input method while enumerating
    EnumerateSkipFirst=False
    # Time limit in milliseconds for triggering modifier key shortcuts
    ModifierOnlyKeyTimeout=250

    [Hotkey/TriggerKeys]
    0=Control+space
    1=Zenkaku_Hankaku

    [Hotkey/AltTriggerKeys]

    [Hotkey/EnumerateGroupForwardKeys]
    0=Super+space

    [Hotkey/EnumerateGroupBackwardKeys]
    0=Shift+Super+space

    [Hotkey/PrevPage]
    0=Up

    [Hotkey/NextPage]
    0=Down

    [Hotkey/PrevCandidate]
    0=Shift+Tab

    [Hotkey/NextCandidate]
    0=Tab

    [Hotkey/TogglePreedit]
    0=Control+Alt+P

    [Behavior]
    # Active By Default
    ActiveByDefault=False
    # Reset state on Focus In
    resetStateWhenFocusIn=No
    # Share Input State
    ShareInputState=No
    # Show preedit in application
    PreeditEnabledByDefault=True
    # Show Input Method Information when switch input method
    ShowInputMethodInformation=True
    # Show Input Method Information when changing focus
    showInputMethodInformationWhenFocusIn=False
    # Show compact input method information
    CompactInputMethodInformation=True
    # Show first input method information
    ShowFirstInputMethodInformation=True
    # Default page size
    DefaultPageSize=5
    # Override XKB Option
    OverrideXkbOption=False
    # Custom XKB Option
    CustomXkbOption=
    # Force Enabled Addons
    EnabledAddons=
    # Force Disabled Addons
    DisabledAddons=
    # Preload input method to be used by default
    PreloadInputMethod=True
    # Allow input method in the password field
    AllowInputMethodForPassword=False
    # Show preedit text when typing password
    ShowPreeditForPassword=False
    # Interval of saving user data in minutes
    AutoSavePeriod=30
  '';

  # fcitx5-skk は ~/.local/share/fcitx5/skk/dictionary_list を読む
  xdg.dataFile."fcitx5/skk/dictionary_list".text = ''
    type=file,file=${config.home.homeDirectory}/.local/share/fcitx5/skk/user.dict,mode=readwrite
    type=file,file=${config.home.homeDirectory}/.skk/SKK-JISYO.L,mode=readonly
    type=file,file=${config.home.homeDirectory}/.skk/skk-jisyo.imas.utf8,mode=readonly,encoding=UTF-8
    type=file,file=${config.home.homeDirectory}/.skk/skk-jisyo-emoji-ja.utf8,mode=readonly,encoding=UTF-8
  '';
}
