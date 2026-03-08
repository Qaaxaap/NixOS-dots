{ pkgs, inputs, ... }:
{
  home-manager.users.Qaaxaap = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = {
        settingsVersion = 55;  # 更新版本号

        bar = {
          barType = "floating";
          position = "top";
          monitors = [ ];
          density = "comfortable";
          showOutline = false;
          showCapsule = true;
          capsuleOpacity = 1;
          capsuleColorKey = "none";
          contentPadding = 2;
          fontScale = 1;
          mouseWheelAction = "none";
          mouseWheelWrap = true;
          backgroundOpacity = 0.93;
          useSeparateOpacity = false;
          widgetSpacing = 6;
          floating = true;
          marginVertical = 4;
          marginHorizontal = 4;
          reverseScroll = false;
          showOnWorkspaceSwitch = true;
          frameThickness = 8;
          frameRadius = 12;
          outerCorners = true;
          hideOnOverview = true;
          displayMode = "always_visible";
          autoHideDelay = 500;
          autoShowDelay = 150;

          # 新增字段
          middleClickAction = "none";
          middleClickCommand = "";
          middleClickFollowMouse = false;
          rightClickAction = "controlCenter";
          rightClickCommand = "";
          rightClickFollowMouse = true;

          widgets = {
            left = [
              {
                icon = "rocket";
                iconColor = "none";
                id = "Launcher";
                colorizeSystemIcon = "none";
                customIconPath = "";
                enableColorization = false;
                useDistroLogo = false;
              }
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "HH:mm ddd, MMM dd";
                id = "Clock";
                formatVertical = "HH mm - dd MM";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useCustomFont = false;
              }
              # 新增 SystemMonitor 小部件 (原 systemMonitor 更新)
              {
                compactMode = true;
                diskPath = "/";
                iconColor = "none";
                id = "SystemMonitor";
                showCpuCores = false;
                showCpuFreq = false;
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskAvailable = false;
                showDiskUsage = false;
                showDiskUsageAsPercent = false;
                showGpuTemp = false;
                showLoadAverage = false;
                showMemoryAsPercent = false;   # 更新为 false
                showMemoryUsage = true;
                showNetworkStats = false;
                showSwapUsage = false;          # 更新为 false
                textColor = "none";
                useMonospaceFont = true;
                usePadding = false;
              }
              {
                compactMode = false;
                hideMode = "hidden";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 145;
                panelShowAlbumArt = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = false;
                textColor = "none";
                useFixedWidth = false;
                visualizerType = "linear";
              }
              # ActiveWindow 移至最后
              {
                colorizeIcons = false;
                hideMode = "hidden";
                id = "ActiveWindow";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                textColor = "none";
                useFixedWidth = false;
              }
            ];
            center = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                groupedBorderOpacity = 1;
                hideUnoccupied = false;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
                pillSize = 0.6;
                showApplications = false;
                showBadge = true;
                showLabelsOnlyWhenOccupied = true;
                unfocusedIconsOpacity = 1;
              }
            ];
            right = [
              {
                blacklist = [];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [];
              }
              {
                hideWhenZero = false;
                hideWhenZeroUnread = false;
                iconColor = "none";
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
              {
                deviceNativePath = "__default__";
                displayMode = "graphic-clean";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = false;
                showPowerProfiles = false;
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Bluetooth";
                textColor = "none";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Network";
                textColor = "none";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                displayMode = "onhover";
                applyToAllMonitors = false;
                iconColor = "none";
                id = "Brightness";
                textColor = "none";
              }
              {
                colorizeDistroLogo = false;
                colorizeSystemIcon = "none";
                customIconPath = "";
                enableColorization = false;
                icon = "noctalia";
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
          screenOverrides = [ ];
        };

        general = {
          avatarImage = "";
          dimmerOpacity = 0.2;
          showScreenCorners = false;
          forceBlackScreenCorners = false;
          scaleRatio = 1;
          radiusRatio = 1;
          iRadiusRatio = 1;
          boxRadiusRatio = 1;
          screenRadiusRatio = 1;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = false;
          lockOnSuspend = true;
          lockScreenAnimations = false;
          lockScreenBlur = 0;
          lockScreenTint = 0;
          lockScreenMonitors = [ ];
          passwordChars = false;
          reverseScroll = false;
          showSessionButtonsOnLockScreen = true;
          showHibernateOnLockScreen = false;
          enableShadows = true;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          enableLockScreenCountdown = true;
          lockScreenCountdownDuration = 10000;
          autoStartAuth = false;
          allowPasswordWithFprintd = false;
          clockStyle = "custom";
          clockFormat = "hh\nmm";
          enableLockScreenMediaControls = false;
          keybinds = {
            keyDown = ["Down"];
            keyEnter = ["Return" "Enter"];
            keyEscape = ["Esc"];
            keyLeft = ["Left"];
            keyRemove = ["Del"];
            keyRight = ["Right"];
            keyUp = ["Up"];
          };
        };

        ui = {
          fontDefault = "Noto sans";
          fontFixed = "Hack";
          fontDefaultScale = 1;
          fontFixedScale = 1;
          tooltipsEnabled = true;
          panelBackgroundOpacity = 0.93;
          panelsAttachedToBar = true;
          settingsPanelMode = "attached";
          settingsPanelSideBarCardStyle = false;
          boxBorderEnabled = false;
        };

        location = {
          name = "Xi'an";
          weatherEnabled = true;
          weatherShowEffects = true;
          useFahrenheit = false;
          use12hourFormat = false;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherTimezone = false;
          hideWeatherCityName = false;
        };

        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
          ];
        };

        wallpaper = {
          enabled = true;
          overviewEnabled = false;
          directory = "";
          monitorDirectories = [ ];
          enableMultiMonitorDirectories = false;
          showHiddenFiles = false;
          viewMode = "single";
          setWallpaperOnAllMonitors = true;
          fillMode = "crop";
          fillColor = "#000000";
          useSolidColor = false;
          solidColor = "#1a1a2e";
          automationEnabled = false;
          wallpaperChangeMode = "random";
          randomIntervalSec = 300;
          transitionDuration = 1500;
          transitionType = "random";
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = false;
          favorites = [];
          overviewBlur = 0.4;
          overviewTint = 0.6;
          skipStartupTransition = false;
          useWallhaven = false;
          wallhavenQuery = "";
          wallhavenSorting = "relevance";
          wallhavenOrder = "desc";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          wallhavenRatios = "";
          wallhavenApiKey = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenResolutionHeight = "";
          sortOrder = "name";
        };

        appLauncher = {
          enableClipboardHistory = true;
          autoPasteClipboard = false;
          density = "default";
          enableClipPreview = true;
          enableSessionSearch = true;
          clipboardWrapText = true;
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          position = "center";
          pinnedApps = [ ];
          useApp2Unit = false;
          sortByMostUsed = true;
          terminalCommand = "alacritty -e";
          customLaunchPrefixEnabled = false;
          customLaunchPrefix = "";
          viewMode = "list";
          showCategories = true;
          iconMode = "tabler";
          showIconBackground = false;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          ignoreMouseInput = false;
          screenshotAnnotationTool = "";
          overviewLayer = false;
        };

        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/";
          # 删除了 openAtMouseOnBarRightClick
          shortcuts = {
            left = [
              { id = "Network"; }
              { id = "Bluetooth"; }
              { id = "NoctaliaPerformance"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "PowerProfile"; }
              { id = "KeepAwake"; }
              { id = "NightLight"; }
            ];
          };
          cards = [
            { enabled = true; id = "profile-card"; }
            { enabled = true; id = "shortcuts-card"; }
            { enabled = true; id = "audio-card"; }
            { enabled = false; id = "brightness-card"; }
            { enabled = true; id = "weather-card"; }
            { enabled = true; id = "media-sysmon-card"; }
          ];
        };

        systemMonitor = {
          cpuWarningThreshold = 80;
          cpuCriticalThreshold = 90;
          tempWarningThreshold = 80;
          tempCriticalThreshold = 90;
          gpuWarningThreshold = 80;
          gpuCriticalThreshold = 90;
          memWarningThreshold = 80;
          memCriticalThreshold = 90;
          swapWarningThreshold = 80;
          swapCriticalThreshold = 90;
          diskWarningThreshold = 80;
          diskCriticalThreshold = 90;
          diskAvailWarningThreshold = 20;
          diskAvailCriticalThreshold = 10;
          batteryWarningThreshold = 20;
          batteryCriticalThreshold = 5;
          enableDgpuMonitoring = false;
          useCustomColors = false;
          warningColor = "";
          criticalColor = "";
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        };

        dock = {
          enabled = false;
          position = "bottom";
          displayMode = "auto_hide";
          dockType = "floating";
          launcherPosition = "end";
          showDockIndicator = false;
          showLauncherIcon = false;
          sitOnFrame = false;
          backgroundOpacity = 1;
          floatingRatio = 1;
          indicatorColor = "primary";
          indicatorOpacity = 0.6;
          indicatorThickness = 3;
          launcherIconColor = "none";
          size = 1;
          onlySameOutput = true;
          monitors = [ ];
          pinnedApps = [ ];
          colorizeIcons = false;
          pinnedStatic = false;
          inactiveIndicators = false;
          deadOpacity = 0.6;
          animationSpeed = 1;
          groupApps = false;
          groupClickAction = "cycle";
          groupContextMenuMode = "extended";
          groupIndicatorStyle = "dots";
        };

        network = {
          wifiEnabled = true;
          airplaneModeEnabled = false;
          disableDiscoverability = false;
          bluetoothRssiPollingEnabled = false;
          bluetoothRssiPollIntervalMs = 10000;
          wifiDetailsViewMode = "grid";
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          networkPanelView = "wifi";
          # 新增字段
          bluetoothAutoConnect = true;
        };

        sessionMenu = {
          enableCountdown = true;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          largeButtonsStyle = true;
          largeButtonsLayout = "single-row";
          showKeybinds = true;
          powerOptions = [
            { action = "lock"; enabled = true; keybind = "1"; }
            { action = "suspend"; enabled = true; keybind = "2"; }
            { action = "hibernate"; enabled = true; keybind = "3"; }
            { action = "reboot"; enabled = true; keybind = "4"; }
            { action = "logout"; enabled = true; keybind = "5"; }
            { action = "shutdown"; enabled = true; keybind = "6"; }
          ];
        };

        notifications = {
          enabled = true;
          monitors = [ ];
          clearDismissed = true;
          density = "default";
          enableMarkdown = false;
          location = "top_right";
          overlayLayer = true;
          backgroundOpacity = 1;
          respectExpireTimeout = false;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
          saveToHistory = {
            low = true;
            normal = true;
            critical = true;
          };
          sounds = {
            enabled = false;
            volume = 0.5;
            separateSounds = false;
            criticalSoundFile = "";
            normalSoundFile = "";
            lowSoundFile = "";
            excludedApps = "discord,firefox,chrome,chromium,edge";
          };
          enableMediaToast = false;
          enableKeyboardLayoutToast = true;
          enableBatteryToast = true;
        };

        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2000;
          overlayLayer = true;
          backgroundOpacity = 1;
          enabledTypes = [ 0 1 2 ];
          monitors = [ ];
        };

        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          cavaFrameRate = 30;
          visualizerType = "linear";
          mprisBlacklist = [ ];
          preferredPlayer = "";
          volumeFeedback = false;
          volumeFeedbackSoundFile = "";
        };

        brightness = {
          backlightDeviceMappings = [];
          brightnessStep = 5;
          enforceMinimum = true;
          enableDdcSupport = false;
        };

        colorSchemes = {
          useWallpaperColors = true;
          predefinedScheme = "Noctalia (default)";
          darkMode = true;
          schedulingMode = "off";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          generationMethod = "tonal-spot";
          monitorForColors = "";
        };

        templates = {
          activeTemplates = [ ];
          enableUserTheming = false;
        };

        nightLight = {
          enabled = false;
          forced = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "06:30";
          manualSunset = "18:30";
        };

        hooks = {
          enabled = false;
          wallpaperChange = "";
          darkModeChange = "";
          screenLock = "";
          screenUnlock = "";
          performanceModeEnabled = "";
          performanceModeDisabled = "";
          startup = "";
          session = "";
        };

        plugins = {
          autoUpdate = false;
        };

        desktopWidgets = {
          enabled = true;
          gridSnap = false;
          overviewEnabled = true;
          monitorWidgets = [
            {
              name = "eDP-1";
              widgets = [
                {
                  clockColor = "primary";
                  clockStyle = "minimal";
                  clockstyle = "minimal";
                  customFont = "Space Grotesk";          # 更新字体
                  format = "HH:mm\\nyyyy M dd";
                  id = "Clock";
                  roundedCorners = true;
                  scale = 3.7598340841232765;
                  showBackground = false;
                  useCustomFont = true;                  # 启用自定义字体
                  x = 337;
                  y = 537;
                }
              ];
            }
          ];
        };

        idle = {
          customCommands = "[]";
          enabled = false;
          fadeDuration = 5;
          lockCommand = "";
          lockTimeout = 660;
          resumeLockCommand = "";
          resumeScreenOffCommand = "";
          resumeSuspendCommand = "";
          screenOffCommand = "";
          screenOffTimeout = 600;
          suspendCommand = "";
          suspendTimeout = 1800;
        };
      };
    };
  };
}
