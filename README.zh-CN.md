# macOS 输入源管理器

这个工具可以从命令行管理 macOS 的输入源，非常适合与 `vim` 和 `emacs` 集成（例如 [sis](https://github.com/laishulu/emacs-smart-input-source)）。

`macism` 相较于其他类似工具的主要优势在于它能够可靠地选择 CJKV（中文/日文/韩文/
越南文）输入源。而使用其他工具（例如
[input-source-switcher](https://github.com/vovkasm/input-source-switcher)、
[smartim 的 im-select](https://github.com/ybian/smartim)、
[swim](https://github.com/mitsuse/swim)）切换到 CJKV 输入源时，你会看到菜单栏中
的输入源图标已经改变，但实际上除非你激活其他应用程序然后再切换回来，输入源仍然是
之前的。 

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
### 获取当前输入源
```sh
macism
```
### 切换输入源
尝试级别 1，如果不起作用，则尝试级别 2，再不行则尝试级别 3。

- 级别 1
  ```
  macism SOME_INPUT_SOURCE_ID
  ```
- 级别 2
  ```
  macism --l2 SOME_INPUT_SOURCE_ID
  ```
- 级别 3

  需先安装 `TemporaryWindow.app`。
  ```
  brew install --cask temporary-window 
  ```
  然后可以使用级别 3。
  ```
  macism --l3 SOME_INPUT_SOURCE_ID
  ```

额外的参数 `mSECONDS` 是可选的，例如 `macism SOME_INPUT_SOURCE_ID mSECONDS`。屏
幕右下角会出现一个小的紫色条，持续 `mSECONDS` 毫秒。大多数情况下 `mSECONDS=1` 即
可生效，如果不起作用，可以增加数值并自行测试。 

额外的选项 `--noKeyboardOnly` 还将启用非键盘输入源。

### TemporaryWindow.app
`TemporaryWindow.app` 可以在 `macism` 之外独立使用，例如
`MACISM_WAIT_TIME_MS=5000 open /Applications/TemporaryWindow.app`，将焦点从当前
应用程序切换到临时窗口，持续 5 秒后切换回来。因此，你可以将其与其他缺乏此功能的
工具一起使用。 

## 感谢
- [LuSrackhall](https://github.com/LuSrackhall) 在此[讨
  论](https://github.com/rime/squirrel/issues/866#issuecomment-2800561092)中提供
  的关键见解。基于这一见解，macism 从 v1 升级到了 v2。
