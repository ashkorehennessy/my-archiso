# 自用 Arch ISO

自用 Arch Linux ISO 的配置与脚本。生成一个预配置的 live/安装环境，包含 KDE、常用工具。

## 结构

- `build.sh`：构建脚本。
- `packages.x86_64`：要打包进 ISO 的软件包列表
- `pacman.conf`：ISO 内使用的 pacman 配置，添加了 `archlinuxcn` 源。
- `airootfs/`：根文件系统模板：
	- `airootfs/root/customize_airootfs.sh`：mkarchiso 构建时会执行的脚本，负责调用 `setup_custom.sh`。
	- `airootfs/root/setup_custom.sh`：自定义安装脚本，设置镜像源、创建用户、配置自动登录、安装 AUR 包。
- `.github/workflows/build.yml`：CI

## 本地构建

```bash
sudo bash build.sh
```

成功后，生成的 ISO 文件会在仓库下的 `out/` 目录中。

## 修改说明

- 用户：创建了一个用户名为 `archiso` 的普通用户，密码为 `archiso`，配置 `sudo` 免密码访问，tty下自动登陆该用户。

- 桌面：使用 `plasma` 桌面、添加 `pipewire`、`输入法` `蓝牙` `kde分区管理器`，在tty界面下输入`sudo systemctl start sddm`启动桌面。

- AUR：`google-chrome` `v2rayn-bin` `fcitx5-input-support`，在 `airootfs/root/setup_custom.sh` 中修改。
