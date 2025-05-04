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
### Get current input source
```sh
macism
```
### Switch input source
Try level 1, if it does not work, than try level 2, then level 3.

- Level 1
  ```
  macism SOME_INPUT_SOURCE_ID
  ```
- Level 2
  ```
  macism --l2 SOME_INPUT_SOURCE_ID
  ```
- Level 3

  Should install `TemporaryWindow.app` first.
  ```
  brew install --cask temporary-window 
  ```
  Then you can use level 3.
  ```
  macism --l3 SOME_INPUT_SOURCE_ID
  ```

An extra argument `mSECONDS` is optional. e.g. `macism SOME_INPUT_SOURCE_ID
mSECONDS`. A small purple bar on the bottom right of the screen will last for
`mSECONDS`. `mSECONDS=1` should work in most cases, if it does not work, 
increase it and do your own test. 

An extra option `--noKeyboardOnly` will also enable none-keyboard input
sources.

### TemporaryWindow.app
`TemporaryWindow.app` can be used out of `macism`, e.g.
`MACISM_WAIT_TIME_MS=5000 open /Applications/TemporaryWindow.app` to switch
focus away from your current application to the temporary window for *5s* and
then switch back. So you can use it with other tools lacking this ability.

## Thanks
- [LuSrackhall](https://github.com/LuSrackhall) for his key insight in this
  [discussion](
    https://github.com/rime/squirrel/issues/866#issuecomment-2800561092
  ). Based on this insight, macism upgraded from v1 to v2.

