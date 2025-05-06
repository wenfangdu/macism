![CI](https://github.com/laishulu/macism/actions/workflows/release.yml/badge.svg)

[[English](https://github.com/laishulu/macism/blob/master/README.md)]
# MacOS 输入源管理器 

这个工具可以从命令行管理 macOS 的输入源，非常适合与 `vim` 和 `emacs` 集成（例如
[sis](https://github.com/laishulu/emacs-smart-input-source)）。 

`macism` 相较于其他类似工具的主要优势在于，它可以可靠地选择 CJKV（中文/日文/韩文
/越南文）输入源。而使用其他工具（例如
[input-source-switcher](https://github.com/vovkasm/input-source-switcher)、
[smartim 的 im-select](https://github.com/ybian/smartim)、
[swim](https://github.com/mitsuse/swim)）切换到 CJKV 输入源时，你会看到菜单栏中
的输入源图标已经改变，但实际上除非你激活其他应用程序然后再切回来，输入源仍然是之
前的。 

## 安装

你可以通过以下任一方式获取可执行文件：

- 通过 brew 安装
    ```
    brew tap laishulu/homebrew
    brew install macism
    ```

- 自行编译
    ```
    git clone https://github.com/laishulu/macism
    cd macism
    make
    ```
- 直接从 [GitHub](https://github.com/laishulu/macism/releases) 下载可执行文件
    
## 使用方法
### 显示版本
```sh
macism --version
```
### 显示前输入源
```sh
macism
```
### 切换输入源
尝试级别 1，如果不起作用，则尝试级别 2，再尝试级别 3。

- 级别 1：在 JIS 键盘上模拟 japanese_kana
  ```
  macism SOME_INPUT_SOURCE_ID
  ```
- 级别 2：切换焦点。进程内操作，轻量但同步。
  ```
  macism --l2 SOME_INPUT_SOURCE_ID
  ```
- 级别 3：切换焦点。独立应用程序，重量级但异步。

  需先安装 `TemporaryWindow.app`。
  ```
  brew install --cask temporary-window 
  ```
  然后可以使用级别 3。
  ```
  macism --l3 SOME_INPUT_SOURCE_ID
  ```

有一个可选的额外参数 `mSECONDS`，例如 `macism SOME_INPUT_SOURCE_ID mSECONDS`，默
认为 `50`。对于级别 2 和 3，还会在屏幕右下角显示一个小的紫色条。 

额外选项 `--noKeyboardOnly` 还将启用非键盘输入源。

### TemporaryWindow.app
`TemporaryWindow.app` 可以在 `macism` 之外使用，例如：
`MACISM_WAIT_TIME_MS=5000 open /Applications/TemporaryWindow.app`，将焦点从当前
应用程序切换到临时窗口，持续 *5 秒*，然后切回。因此，你可以将其与其他缺乏此功能
的工具一起使用。 

## 致谢
- [zzzchuu](https://github.com/zzzchuu) 在此[讨
  论](https://github.com/laishulu/macism/issues/24#issuecomment-2849317891)中介
  绍了一种新方法。因此我们有了级别 1 模式。 
- [LuSrackhall](https://github.com/LuSrackhall) 在此[讨
  论](https://github.com/rime/squirrel/issues/866#issuecomment-2800561092)中提供
  了关键见解。因此我们有了级别 2 和级别 3 模式。 

