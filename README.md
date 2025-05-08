![CI](https://github.com/laishulu/macism/actions/workflows/release.yml/badge.svg)

[[中文](https://github.com/laishulu/macism/blob/master/README.zh-CN.md)]
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
### Show version
```sh
macism --version
```
### Show current input source
```sh
macism
```
### Switch input source
#### Switch, with workaround for the MacOS bug
```
macism SOME_INPUT_SOURCE_ID
```
#### Switch, without workaround for the MacOS bug
```
macism SOME_INPUT_SOURCE_ID 0
```
## Thanks
- [LuSrackhall](https://github.com/LuSrackhall) for his key insight in this
  [discussion](
    https://github.com/rime/squirrel/issues/866#issuecomment-2800561092
  ).

