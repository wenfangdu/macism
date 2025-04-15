# MacOS Input Source Manager

This tool manages MacOS input source from command line, can be integrated with 
`vim` and `emacs` (e.g.
[emacs-smart-input-source](https://github.com/laishulu/emacs-smart-input-source)).
It is based on the codes from [kawa](https://github.com/utatti/kawa).

`macism`'s main advantage over other similar tools is that it can reliably 
select CJKV(Chinese/Japanese/Korean/Vietnamese) input source, while with other 
tools (such as
[input-source-switcher](https://github.com/vovkasm/input-source-switcher),
[im-select from smartim](https://github.com/ybian/smartim),
[swim](https://github.com/mitsuse/swim)), when you switch to CJKV input source,
you will see that the input source icon has already changed in the menu bar, but
unless you activate other applications and then switch back, you input source is
actually still the same as before.

## Install

You can get the executable in any of the following ways:

- Install from brew
    ```
    brew tap laishulu/homebrew
    brew install macism
    ```

- compile by yourself
    ```
    git clone https://github.com/laishulu/macism
    cd macism
    swiftc macism.swift
    ```
- download the executable directly from 
    [github](https://github.com/laishulu/macism/releases)
    
## Usage

1. `macism` will output the current input source
2. `macism SOME_INPUT_SOURCE_ID` will select to `SOME_INPUT_SOURCE_ID`.
4. Add an extra option `--noKeyboardOnly` to command pattern *#2* will also 
   enable none-keyboard input sources.

## Thanks
- [LuSrackhall](https://github.com/LuSrackhall) for his key insight in this
  [discussion](https://github.com/rime/squirrel/issues/866#issuecomment-2800561092)
  . Based on this insight, macism upgraded from v1 to v2.

