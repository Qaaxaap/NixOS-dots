#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

HOSTNAME="Qaaxaap"
HOME_MANAGER_USER="Qaaxaap"
HOME_MANAGER_PATH="home-manager/users/$HOME_MANAGER_USER"

echo -e "${YELLOW}开始进一步优化配置内容（拆分模块、移动 dotfiles、更新引用）${NC}"

# -------------------- 辅助函数 --------------------
# 检查文件是否在 Git 中
is_git_tracked() {
    git ls-files --error-unmatch "$1" &>/dev/null
}

# 安全移动：如果是 Git 跟踪则用 git mv，否则用普通 mv
safe_move() {
    local src="$1"
    local dst="$2"
    if [ -e "$src" ]; then
        if is_git_tracked "$src"; then
            echo "Git 跟踪文件 $src -> $dst (使用 git mv)"
            mkdir -p "$(dirname "$dst")"
            git mv "$src" "$dst"
        else
            echo "普通文件 $src -> $dst"
            mkdir -p "$(dirname "$dst")"
            mv "$src" "$dst"
        fi
    fi
}

# -------------------- 移动 dotfiles --------------------
echo "处理 nvim-dots (子模块)..."
# 检测是否为子模块
if [ -f .gitmodules ] && grep -q "nvim-dots" .gitmodules; then
    echo -e "${YELLOW}检测到 nvim-dots 是 Git 子模块，脚本将不会自动移动它。"
    echo "请手动执行以下命令移动子模块："
    echo "  git mv nvim-dots $HOME_MANAGER_PATH/features/nvim-dots"
    echo "  然后编辑 .gitmodules，将 'path = nvim-dots' 改为 'path = $HOME_MANAGER_PATH/features/nvim-dots'"
    echo "  最后运行: git add .gitmodules && git commit -m 'move nvim-dots submodule'"
    echo -e "移动完成后，继续运行本脚本以更新引用。${NC}"
    read -p "是否已手动移动 nvim-dots？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "跳过 nvim-dots 移动，请稍后手动处理。"
    else
        # 更新 home-manager 中的路径引用
        sed -i "s|source = config\.lib\.file\.mkOutOfStoreSymlink \"/home/Qaaxaap/nixos/nvim-dots\"|source = config.lib.file.mkOutOfStoreSymlink (toString ./features/nvim-dots)|g" "$HOME_MANAGER_PATH/default.nix"
        echo "已更新 nvim-dots 引用为相对路径。"
    fi
else
    echo "nvim-dots 不是子模块，尝试移动..."
    mkdir -p "$HOME_MANAGER_PATH/features/nvim-dots"
    safe_move "nvim-dots" "$HOME_MANAGER_PATH/features/nvim-dots"
    # 更新 home-manager 中的路径引用
    sed -i "s|source = config\.lib\.file\.mkOutOfStoreSymlink \"/home/Qaaxaap/nixos/nvim-dots\"|source = config.lib.file.mkOutOfStoreSymlink (toString ./features/nvim-dots)|g" "$HOME_MANAGER_PATH/default.nix"
fi

echo "移动 xdg-desktop-portal..."
mkdir -p "$HOME_MANAGER_PATH/dotfiles/xdg-desktop-portal"
safe_move "xdg-desktop-portal" "$HOME_MANAGER_PATH/dotfiles/xdg-desktop-portal"
# 更新 home-manager 中的路径引用
sed -i "s|source = config\.lib\.file\.mkOutOfStoreSymlink \"/home/Qaaxaap/nixos/xdg-desktop-portal\"|source = config.lib.file.mkOutOfStoreSymlink (toString ./dotfiles/xdg-desktop-portal)|g" "$HOME_MANAGER_PATH/default.nix"

# -------------------- 拆分 niri.nix --------------------
echo "拆分 niri.nix 为系统模块和 home-manager 模块..."

NIRI_SYSTEM_MODULE="modules/wm/niri.nix"
NIRI_HM_MODULE="$HOME_MANAGER_PATH/features/niri.nix"

if [ -f "$NIRI_SYSTEM_MODULE" ]; then
    cp "$NIRI_SYSTEM_MODULE" "$NIRI_SYSTEM_MODULE.bak"
    # 提取系统配置部分
    awk '/^[[:space:]]*\{[[:space:]]*pkgs,[[:space:]]*inputs,[[:space:]]*\.\.\.[[:space:]]*\}[[:space:]]*:[[:space:]]*$/,/^[[:space:]]*home-manager\.users\.Qaaxaap =/ { if (!/home-manager\.users\.Qaaxaap =/) print }' "$NIRI_SYSTEM_MODULE" >"$NIRI_SYSTEM_MODULE.tmp"
    sed -i '/^$/d' "$NIRI_SYSTEM_MODULE.tmp"
    # 确保系统模块以 } 结尾
    echo "}" >>"$NIRI_SYSTEM_MODULE.tmp"
    mv "$NIRI_SYSTEM_MODULE.tmp" "$NIRI_SYSTEM_MODULE"

    # 提取 home-manager 部分
    awk '/^[[:space:]]*home-manager\.users\.Qaaxaap =/,/};/ { print }' "$NIRI_SYSTEM_MODULE.bak" | sed 's/^[[:space:]]*home-manager\.users\.Qaaxaap = //' >"$NIRI_HM_MODULE"
    # 包装成模块格式
    echo "{ config, lib, pkgs, ... }:" >"$NIRI_HM_MODULE.tmp"
    echo "{" >>"$NIRI_HM_MODULE.tmp"
    cat "$NIRI_HM_MODULE" >>"$NIRI_HM_MODULE.tmp"
    echo "}" >>"$NIRI_HM_MODULE.tmp"
    mv "$NIRI_HM_MODULE.tmp" "$NIRI_HM_MODULE"

    # 清理原系统模块中的 home-manager 部分
    sed -i '/home-manager\.users\.Qaaxaap =/,/};/d' "$NIRI_SYSTEM_MODULE"
    echo -e "${GREEN}niri.nix 拆分完成${NC}"
fi

# -------------------- 拆分 zsh.nix --------------------
echo "拆分 zsh.nix 为系统模块和 home-manager 模块..."

ZSH_SYSTEM_MODULE="modules/programs/zsh.nix"
ZSH_HM_MODULE="$HOME_MANAGER_PATH/programs/zsh.nix"

if [ -f "$ZSH_SYSTEM_MODULE" ]; then
    cp "$ZSH_SYSTEM_MODULE" "$ZSH_SYSTEM_MODULE.bak"
    # 提取系统配置部分
    awk '/^[[:space:]]*\{[[:space:]]*config,[[:space:]]*pkgs,[[:space:]]*\.\.\.[[:space:]]*\}[[:space:]]*:[[:space:]]*$/,/^[[:space:]]*home-manager\.users\.Qaaxaap =/ { if (!/home-manager\.users\.Qaaxaap =/) print }' "$ZSH_SYSTEM_MODULE" >"$ZSH_SYSTEM_MODULE.tmp"
    sed -i '/^$/d' "$ZSH_SYSTEM_MODULE.tmp"
    echo "}" >>"$ZSH_SYSTEM_MODULE.tmp"
    mv "$ZSH_SYSTEM_MODULE.tmp" "$ZSH_SYSTEM_MODULE"

    # 提取 home-manager 部分
    awk '/^[[:space:]]*home-manager\.users\.Qaaxaap =/,/};/ { print }' "$ZSH_SYSTEM_MODULE.bak" | sed 's/^[[:space:]]*home-manager\.users\.Qaaxaap = //' >"$ZSH_HM_MODULE"
    # 包装
    echo "{ config, pkgs, ... }:" >"$ZSH_HM_MODULE.tmp"
    echo "{" >>"$ZSH_HM_MODULE.tmp"
    cat "$ZSH_HM_MODULE" >>"$ZSH_HM_MODULE.tmp"
    echo "}" >>"$ZSH_HM_MODULE.tmp"
    mv "$ZSH_HM_MODULE.tmp" "$ZSH_HM_MODULE"

    # 清理系统模块中的 home-manager 部分
    sed -i '/home-manager\.users\.Qaaxaap =/,/};/d' "$ZSH_SYSTEM_MODULE"

    # 更新 zsh.nix 中引用的 p10k.zsh 路径（现在 p10k.zsh 在 home-manager 的 dotfiles 下）
    sed -i 's|source = \.\./\.\./home-manager/users/'"$HOSTNAME"'/dotfiles/p10k\.zsh;|source = ../../dotfiles/p10k.zsh;|g' "$ZSH_HM_MODULE"
    echo -e "${GREEN}zsh.nix 拆分完成${NC}"
fi

# -------------------- 更新 home-manager 的 default.nix 导入 --------------------
echo "更新 home-manager 入口文件 $HOME_MANAGER_PATH/default.nix ..."

if [ -f "$HOME_MANAGER_PATH/default.nix" ]; then
    cp "$HOME_MANAGER_PATH/default.nix" "$HOME_MANAGER_PATH/default.nix.bak"

    # 添加 imports 列表（如果还没有）
    if ! grep -q "imports = \[" "$HOME_MANAGER_PATH/default.nix"; then
        # 在文件开头插入 imports
        sed -i '1i\imports = [\n\  ./programs/zsh.nix\n\  ./features/niri.nix\n\  ./features/noctalia.nix\n];\n' "$HOME_MANAGER_PATH/default.nix"
    else
        # 确保已包含新模块
        for mod in "./programs/zsh.nix" "./features/niri.nix" "./features/noctalia.nix"; do
            if ! grep -q "$mod" "$HOME_MANAGER_PATH/default.nix"; then
                sed -i "/imports = \[/a \  $mod" "$HOME_MANAGER_PATH/default.nix"
            fi
        done
    fi

    echo -e "${GREEN}home-manager 入口文件已更新${NC}"
fi

# -------------------- 整理 flake.nix --------------------
echo "整理 flake.nix 导入结构..."

FLAKE="flake.nix"
if [ -f "$FLAKE" ]; then
    cp "$FLAKE" "$FLAKE.bak2"

    # 生成新的 flake.nix（保持输入不变，精简 modules 列表）
    cat >flake.nix.new <<EOF
{
  description = "NixOS flake-configuration with Noctalia";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }; 

  outputs = inputs@{ self, winapps, nixpkgs, home-manager, grub2-themes, ... }: let
    system = "x86_64-linux";
  in
  {
    packages.x86_64-linux.space-grotesk = import ./packages/space-grotesk/default.nix {
      inherit (nixpkgs.legacyPackages.x86_64-linux) lib stdenv fetchzip;
    };
    nixosConfigurations.Qaaxaap = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit self inputs winapps; };
      modules = [
        ./hosts/Qaaxaap/hardware-configuration.nix
        ./hosts/Qaaxaap/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.Qaaxaap = import ./home-manager/users/Qaaxaap/default.nix;
        }
        inputs.distro-grub-themes.nixosModules.${system}.default
      ];
    }; 
  };
}
EOF

    mv flake.nix.new "$FLAKE"
    echo -e "${GREEN}flake.nix 已精简，现在只需导入主机配置和 home-manager 入口${NC}"
fi

# -------------------- 清理临时文件 --------------------
echo "清理备份文件（可选）..."

echo -e "${GREEN}所有优化完成！"
echo "请检查以下可能仍需手动调整的地方："
echo "1. hosts/Qaaxaap/configuration.nix 应该只包含主机特定的配置，可以考虑将其余通用模块移到 modules/ 下并在该文件中 imports。"
echo "2. 检查 home-manager 中所有 dotfiles 的软链接路径是否正确（使用了相对路径表达式，应自动适应）。"
echo "3. 运行 'nix flake check' 测试配置有效性。"
echo "4. 如果 nvim-dots 是子模块且尚未移动，请按提示手动操作。${NC}"
