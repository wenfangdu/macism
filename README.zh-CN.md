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
#### 切换，并**规避**该 MacOS bug
若输入源**会触发**该 bug 时，下列命令可以稳定切换：
```
macism SOME_INPUT_SOURCE_ID
```
#### 切换，**不规避**该 MacOS bug
若输入源**不会**触发该 bug 时，下列命令体验更好：
```
macism SOME_INPUT_SOURCE_ID 0
```
## 致谢
- [LuSrackhall](https://github.com/LuSrackhall) 在此[讨
  论](https://github.com/rime/squirrel/issues/866#issuecomment-2800561092)中提供
  了关键见解。因此我们有了级别 2 和级别 3 模式。 

