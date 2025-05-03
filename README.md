# MacOS Input Source Manager

This tool manages macOS input sources from the command line, ideal for
integration with `vim` and `emacs`(e.g. 
[sis](https://github.com/laishulu/emacs-smart-input-source)). 

`macism`'s main advantage over other similar tools is that it can reliably 
select CJKV(Chinese/Japanese/Korean/Vietnamese) input source, while with other 
tools (such as
[input-source-switcher](https://github.com/vovkasm/input-source-switcher),
[im-select from smartim](https://github.com/ybian/smartim),
[swim](https://github.com/mitsuse/swim)), when you switch to CJKV input source,
you will see that the input source icon has already changed in the menu bar, but
unless you activate other applications and then switch back, the input source is
actually still the same as before.

## Install

You can get the executable in any of the following ways:

- Install from brew
    ```
    brew tap laishulu/homebrew
    brew install macism
    brew install --cask temporary-window
    ```

- compile by yourself
    ```
    git clone https://github.com/laishulu/macism
    cd macism
    make
    ```
- download the executable directly from 
    [github](https://github.com/laishulu/macism/releases)
    
## Usage
1. `macism`: output the current input source
2. `macism SOME_INPUT_SOURCE_ID`: switch to `SOME_INPUT_SOURCE_ID`.
3. `macism SOME_INPUT_SOURCE_ID mSECONDS` (in case *#2* dos not work): switch to
   `SOME_INPUT_SOURCE_ID`, then open `TemporaryWindow.app` with envrionmen
   variable `MACISM_WAIT_TIME_MS` of value `mSECONDS`. You will see a small
   purple bar on the bottom right of the screen lasting `mSECONDS`. `mSECONDS=1`
   should work in most cases, if it does not work, increase it and test until it
   works. 
4. Add an extra option `--noKeyboardOnly` to command pattern *#2* and *#3* will 
   also enable none-keyboard input sources.
5. `TemporaryWindow.app` can be used out of `macism`, e.g.
   `MACISM_WAIT_TIME_MS=5000 open /Applications/TemporaryWindow.app` to switch
   focus away from your current application to the temporary window for 5s and
   then switch back. So you can use it with other tools lacking this ability. 

## Thanks
- [LuSrackhall](https://github.com/LuSrackhall) for his key insight in this
  [discussion](
    https://github.com/rime/squirrel/issues/866#issuecomment-2800561092
  ). Based on this insight, macism upgraded from v1 to v2.

