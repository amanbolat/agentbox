Title: Set up Claude Code - Claude Code Docs

URL Source: http://docs.anthropic.com/en/docs/claude-code/getting-started

Markdown Content:
System requirements
-------------------

*   **Operating System**: 
    *   macOS 13.0+
    *   Windows 10 1809+ or Windows Server 2019+ ([see setup notes](http://docs.anthropic.com/en/docs/claude-code/getting-started#platform-specific-setup))
    *   Ubuntu 20.04+
    *   Debian 10+
    *   Alpine Linux 3.19+ ([additional dependencies required](http://docs.anthropic.com/en/docs/claude-code/getting-started#platform-specific-setup))

*   **Hardware**: 4 GB+ RAM
*   **Network**: Internet connection required (see [network configuration](https://code.claude.com/docs/en/network-config#network-access-requirements))
*   **Shell**: Works best in Bash or Zsh
*   **Location**: [Anthropic supported countries](https://www.anthropic.com/supported-countries)

### Additional dependencies

*   **ripgrep**: Usually included with Claude Code. If search fails, see [search troubleshooting](https://code.claude.com/docs/en/troubleshooting#search-and-discovery-issues).
*   **[Node.js 18+](https://nodejs.org/en/download)**: Only required for [deprecated npm installation](http://docs.anthropic.com/en/docs/claude-code/getting-started#npm-installation-deprecated)

Installation
------------

To install Claude Code, use one of the following methods:

*   Native Install (Recommended)

*   Homebrew

*   WinGet

**macOS, Linux, WSL:**

```
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell:**

```
irm https://claude.ai/install.ps1 | iex
```

**Windows CMD:**

```
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

```
brew install --cask claude-code
```

```
winget install Anthropic.ClaudeCode
```

After the installation process completes, navigate to your project and start Claude Code:

```
cd your-awesome-project
claude
```

If you encounter any issues during installation, consult the [troubleshooting guide](https://code.claude.com/docs/en/troubleshooting).

### Platform-specific setup

**Windows**: Run Claude Code natively (requires [Git Bash](https://git-scm.com/downloads/win)) or inside WSL. Both WSL 1 and WSL 2 are supported, but WSL 1 has limited support and does not support features like Bash tool sandboxing.**Alpine Linux and other musl/uClibc-based distributions**:The native installer on Alpine and other musl/uClibc-based distributions requires `libgcc`, `libstdc++`, and `ripgrep`. Install these using your distribution’s package manager, then set `USE_BUILTIN_RIPGREP=0`.On Alpine:

```
apk add libgcc libstdc++ ripgrep
```

### Authentication

#### For individuals

1.   **Claude Pro or Max plan** (recommended): Subscribe to Claude’s [Pro or Max plan](https://claude.ai/pricing) for a unified subscription that includes both Claude Code and Claude on the web. Manage your account in one place and log in with your Claude.ai account.
2.   **Claude Console**: Connect through the [Claude Console](https://console.anthropic.com/) and complete the OAuth process. Requires active billing in the Anthropic Console. A “Claude Code” workspace is automatically created for usage tracking and cost management. You can’t create API keys for the Claude Code workspace; it’s dedicated exclusively for Claude Code usage.

#### For teams and organizations

1.   **Claude for Teams or Enterprise** (recommended): Subscribe to [Claude for Teams](https://claude.com/pricing#team-&-enterprise) or [Claude for Enterprise](https://anthropic.com/contact-sales) for centralized billing, team management, and access to both Claude Code and Claude on the web. Team members log in with their Claude.ai accounts.
2.   **Claude Console with team billing**: Set up a shared [Claude Console](https://console.anthropic.com/) organization with team billing. Invite team members and assign roles for usage tracking.
3.   **Cloud providers**: Configure Claude Code to use [Amazon Bedrock, Google Vertex AI, or Microsoft Foundry](https://code.claude.com/docs/en/third-party-integrations) for deployments with your existing cloud infrastructure.

### Install a specific version

The native installer accepts either a specific version number or a release channel (`latest` or `stable`). The channel you choose at install time becomes your default for auto-updates. See [Configure release channel](http://docs.anthropic.com/en/docs/claude-code/getting-started#configure-release-channel) for more information.To install the latest version (default):

*   macOS, Linux, WSL

*   Windows PowerShell

*   Windows CMD

```
curl -fsSL https://claude.ai/install.sh | bash
```

```
irm https://claude.ai/install.ps1 | iex
```

```
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

To install the stable version:

*   macOS, Linux, WSL

*   Windows PowerShell

*   Windows CMD

```
curl -fsSL https://claude.ai/install.sh | bash -s stable
```

```
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) stable
```

```
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd stable && del install.cmd
```

To install a specific version number:

*   macOS, Linux, WSL

*   Windows PowerShell

*   Windows CMD

```
curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58
```

```
& ([scriptblock]::Create((irm https://claude.ai/install.ps1))) 1.0.58
```

```
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd 1.0.58 && del install.cmd
```

### Binary integrity and code signing

*   SHA256 checksums for all platforms are published in the release manifests, currently located at `https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/{VERSION}/manifest.json` (example: replace `{VERSION}` with `2.0.30`)
*   Signed binaries are distributed for the following platforms: 
    *   macOS: Signed by “Anthropic PBC” and notarized by Apple
    *   Windows: Signed by “Anthropic, PBC”

NPM installation (deprecated)
-----------------------------

NPM installation is deprecated. Use the [native installation](http://docs.anthropic.com/en/docs/claude-code/getting-started#installation) method when possible. To migrate an existing npm installation to native, run `claude install`.**Global npm installation**

```
npm install -g @anthropic-ai/claude-code
```

Windows setup
-------------

**Option 1: Claude Code within WSL**

*   Both WSL 1 and WSL 2 are supported
*   WSL 2 supports [sandboxing](https://code.claude.com/docs/en/sandboxing) for enhanced security. WSL 1 does not support sandboxing.

**Option 2: Claude Code on native Windows with Git Bash**

*   Requires [Git for Windows](https://git-scm.com/downloads/win)
*   For portable Git installations, specify the path to your `bash.exe`: ```
$env:CLAUDE_CODE_GIT_BASH_PATH="C:\Program Files\Git\bin\bash.exe"
``` 

Update Claude Code
------------------

### Auto updates

Claude Code automatically keeps itself up to date to ensure you have the latest features and security fixes.

*   **Update checks**: Performed on startup and periodically while running
*   **Update process**: Downloads and installs automatically in the background
*   **Notifications**: You’ll see a notification when updates are installed
*   **Applying updates**: Updates take effect the next time you start Claude Code

### Configure release channel

Configure which release channel Claude Code follows for both auto-updates and `claude update` with the `autoUpdatesChannel` setting:

*   `"latest"` (default): Receive new features as soon as they’re released
*   `"stable"`: Use a version that is typically about one week old, skipping releases with major regressions

Configure this via `/config` → **Auto-update channel**, or add it to your [settings.json file](https://code.claude.com/docs/en/settings):

```
{
  "autoUpdatesChannel": "stable"
}
```

For enterprise deployments, you can enforce a consistent release channel across your organization using [managed settings](https://code.claude.com/docs/en/permissions#managed-settings).

### Disable auto-updates

Set the `DISABLE_AUTOUPDATER` environment variable in your shell or [settings.json file](https://code.claude.com/docs/en/settings):

```
export DISABLE_AUTOUPDATER=1
```

### Update manually

```
claude update
```

Uninstall Claude Code
---------------------

If you need to uninstall Claude Code, follow the instructions for your installation method.

### Native installation

Remove the Claude Code binary and version files:**macOS, Linux, WSL:**

```
rm -f ~/.local/bin/claude
rm -rf ~/.local/share/claude
```

**Windows PowerShell:**

```
Remove-Item -Path "$env:USERPROFILE\.local\bin\claude.exe" -Force
Remove-Item -Path "$env:USERPROFILE\.local\share\claude" -Recurse -Force
```

**Windows CMD:**

```
del "%USERPROFILE%\.local\bin\claude.exe"
rmdir /s /q "%USERPROFILE%\.local\share\claude"
```

### Homebrew installation

```
brew uninstall --cask claude-code
```

### WinGet installation

```
winget uninstall Anthropic.ClaudeCode
```

### NPM installation

```
npm uninstall -g @anthropic-ai/claude-code
```

### Clean up configuration files (optional)

To remove Claude Code settings and cached data:**macOS, Linux, WSL:**

```
# Remove user settings and state
rm -rf ~/.claude
rm ~/.claude.json

# Remove project-specific settings (run from your project directory)
rm -rf .claude
rm -f .mcp.json
```

**Windows PowerShell:**

```
# Remove user settings and state
Remove-Item -Path "$env:USERPROFILE\.claude" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\.claude.json" -Force

# Remove project-specific settings (run from your project directory)
Remove-Item -Path ".claude" -Recurse -Force
Remove-Item -Path ".mcp.json" -Force
```

**Windows CMD:**

```
REM Remove user settings and state
rmdir /s /q "%USERPROFILE%\.claude"
del "%USERPROFILE%\.claude.json"

REM Remove project-specific settings (run from your project directory)
rmdir /s /q ".claude"
del ".mcp.json"
```
