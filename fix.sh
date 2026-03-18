#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

HOSTNAME="Qaaxaap"
HOME_MANAGER_USER="Qaaxaap"
HOME_MANAGER_PATH="home-manager/users/$HOME_MANAGER_USER"

echo -e "${YELLOW}开始修复和收尾工作（假设文件移动已完成）${NC}"

# -------------------- 辅助函数：检查文件是否包含特定内容 --------------------
file_contains() {
    grep -q "$2" "$1" 2>/dev/null
}

# -------------------- 确保关键目录存在 --------------------
mkdir -p modules/{i18n,networking,boot,services,programs,wm}
mkdir -p "$HOME_MANAGER_PATH"/{dotfiles,programs,features}

# -------------------- 拆分 niri.nix（如果尚未拆分）--------------------
NIRI_SYSTEM_MODULE="modules/wm/niri.nix"
NIRI_HM_MODULE="$HOME_MANAGER_PATH/features/niri.nix"

if [ -f "$NIRI_SYSTEM_MODULE" ] && ! file_contains "$NIRI_SYSTEM_MODULE" "home-manager\.users\.Qaaxaap"; then
    echo "niri.nix 似乎已经拆分过，跳过。"
else
    echo "拆分 niri.nix..."
    if [ -f "$NIRI_SYSTEM_MODULE" ]; then
        cp "$NIRI_SYSTEM_MODULE" "$NIRI_SYSTEM_MODULE.bak"
        # 提取系统部分
        awk '/^[[:space:]]*\{[[:space:]]*pkgs,[[:space:]]*inputs,[[:space:]]*\.\.\.[[:space:]]*\}[[:space:]]*:[[:space:]]*$/,/^[[:space:]]*home-manager\.users\.Qaaxaap =/ { if (!/home-manager\.users\.Qaaxaap =/) print }' "$NIRI_SYSTEM_MODULE" > "$NIRI_SYSTEM_MODULE.tmp"
        sed -i '/^$/d' "$NIRI_SYSTEM_MODULE.tmp"
        echo "}" >> "$NIRI_SYSTEM_MODULE.tmp"
        mv "$NIRI_SYSTEM_MODULE.tmp" "$NIRI_SYSTEM_MODULE"

        # 提取 home-manager 部分
        awk '/^[[:space:]]*home-manager\.users\.Qaaxaap =/,/};/ { print }' "$NIRI_SYSTEM_MODULE.bak" | sed 's/^[[:space:]]*home-manager\.users\.Qaaxaap = //' > "$NIRI_HM_MODULE"
        # 包装
        echo "{ config, lib, pkgs, ... }:" > "$NIRI_HM_MODULE.tmp"
        echo "{" >> "$NIRI_HM_MODULE.tmp"
        cat "$NIRI_HM_MODULE" >> "$NIRI_HM_MODULE.tmp"
        echo "}" >> "$NIRI_HM_MODULE.tmp"
        mv "$NIRI_HM_MODULE.tmp" "$NIRI_HM_MODULE"

        # 清理系统模块中的 home-manager 部分
        sed -i '/home-manager\.users\.Qaaxaap =/,/};/d' "$NIRI_SYSTEM_MODULE"
        echo -e "${GREEN}niri.nix 拆分完成${NC}"
    fi
fi

# -------------------- 拆分 zsh.nix（如果尚未拆分）--------------------
ZSH_SYSTEM_MODULE="modules/programs/zsh.nix"
ZSH_HM_MODULE="$HOME_MANAGER_PATH/programs/zsh.nix"

if [ -f "$ZSH_SYSTEM_MODULE" ] && ! file_contains "$ZSH_SYSTEM_MODULE" "home-manager\.users\.Qaaxaap"; then
    echo "zsh.nix 似乎已经拆分过，跳过。"
else
    echo "拆分 zsh.nix..."
    if [ -f "$ZSH_SYSTEM_MODULE" ]; then
        cp "$ZSH_SYSTEM_MODULE" "$ZSH_SYSTEM_MODULE.bak"
        # 提取系统部分
        awk '/^[[:space:]]*\{[[:space:]]*config,[[:space:]]*pkgs,[[:space:]]*\.\.\.[[:space:]]*\}[[:space:]]*:[[:space:]]*$/,/^[[:space:]]*home-manager\.users\.Qaaxaap =/ { if (!/home-manager\.users\.Qaaxaap =/) print }' "$ZSH_SYSTEM_MODULE" > "$ZSH_SYSTEM_MODULE.tmp"
        sed -i '/^$/d' "$ZSH_SYSTEM_MODULE.tmp"
        echo "}" >> "$ZSH_SYSTEM_MODULE.tmp"
        mv "$ZSH_SYSTEM_MODULE.tmp" "$ZSH_SYSTEM_MODULE"

        # 提取 home-manager 部分
        awk '/^[[:space:]]*home-manager\.users\.Qaaxaap =/,/};/ { print }' "$ZSH_SYSTEM_MODULE.bak" | sed 's/^[[:space:]]*home-manager\.users\.Qaaxaap = //' > "$ZSH_HM_MODULE"
        echo "{ config, pkgs, ... }:" > "$ZSH_HM_MODULE.tmp"
        echo "{" >> "$ZSH_HM_MODULE.tmp"
        cat "$ZSH_HM_MODULE" >> "$ZSH_HM_MODULE.tmp"
        echo "}" >> "$ZSH_HM_MODULE.tmp"
        mv "$ZSH_HM_MODULE.tmp" "$ZSH_HM_MODULE"

        # 清理系统模块中的 home-manager 部分
        sed -i '/home-manager\.users\.Qaaxaap =/,/};/d' "$ZSH_SYSTEM_MODULE"

        # 更新 zsh.nix 中引用的 p10k.zsh 路径
        sed -i 's|source = \.\./\.\./home-manager/users/'"$HOSTNAME"'/dotfiles/p10k\.zsh;|source = ../../dotfiles/p10k.zsh;|g' "$ZSH_HM_MODULE"
        echo -e "${GREEN}zsh.nix 拆分完成${NC}"
    fi
fi

# -------------------- 确保 home-manager 入口文件包含正确的 imports --------------------
HM_ENTRY="$HOME_MANAGER_PATH/default.nix"
if [ -f "$HM_ENTRY" ]; then
    cp "$HM_ENTRY" "$HM_ENTRY.bak"
    # 如果还没有 imports，添加
    if ! grep -q "imports = \[" "$HM_ENTRY"; then
        sed -i '1i\imports = [\n\  ./programs/zsh.nix\n\  ./features/niri.nix\n\  ./features/noctalia.nix\n];\n' "$HM_ENTRY"
    else
        # 确保包含必要模块
        for mod in "./programs/zsh.nix" "./features/niri.nix" "./features/noctalia.nix"; do
            if ! grep -q "$mod" "$HM_ENTRY"; then
                sed -i "/imports = \[/a \  $mod" "$HM_ENTRY"
            fi
        done
    fi

    # 更新 nvim-dots 路径（如果尚未更新）
    if grep -q "source = config\.lib\.file\.mkOutOfStoreSymlink \"/home/Qaaxaap/nixos/nvim-dots\"" "$HM_ENTRY"; then
        sed -i "s|source = config\.lib\.file\.mkOutOfStoreSymlink \"/home/Qaaxaap/nixos/nvim-dots\"|source = config.lib.file.mkOutOfStoreSymlink (toString ./features/nvim-dots)|g" "$HM_ENTRY"
    fi

    # 更新 xdg-desktop-portal 路径（如果尚未更新）
    if grep -q "source = config\.lib\.file\.mkOutOfStoreSymlink \"/home/Qaaxaap/nixos/xdg-desktop-portal\"" "$HM_ENTRY"; then
        sed -i "s|source = config\.lib\.file\.mkOutOfStoreSymlink \"/home/Qaaxaap/nixos/xdg-desktop-portal\"|source = config.lib.file.mkOutOfStoreSymlink (toString ./dotfiles/xdg-desktop-portal)|g" "$HM_ENTRY"
    fi

    echo -e "${GREEN}home-manager 入口文件已同步${NC}"
else
    echo -e "${RED}错误：未找到 $HM_ENTRY，请检查前半部分是否已正确执行。${NC}"
    exit 1
fi

# -------------------- 重新生成正确的 flake.nix --------------------
FLAKE="flake.nix"
echo "重新生成 $FLAKE ..."
cp "$FLAKE" "$FLAKE.bak3" 2>/dev/null || true

# 使用单引号 heredoc 防止变量展开
cat > "$FLAKE" <<'EOF'
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

echo -e "${GREEN}flake.nix 已重新生成${NC}"

# -------------------- 最后检查和建议 --------------------
echo -e "${YELLOW}所有修复和收尾工作完成。建议执行以下检查："
echo "1. git status 查看改动，确认没有意外修改。"
echo "2. 运行 'nix flake check' 测试配置。"
echo "3. 如果配置有效，可以删除所有 .bak 文件。"
echo "4. 如果仍有问题，请根据错误提示手动调整。${NC}"
