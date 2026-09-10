# 1. 自动获取并修正 nvim 和 nvim-qt 的路径
$NVIM_EXE_PATH = (where.exe nvim.exe | Select-Object -First 1)
$NVIM_QT_PATH  = (where.exe nvim-qt.exe | Select-Object -First 1)

if ($NVIM_EXE_PATH) { $NVIM_EXE_PATH = $NVIM_EXE_PATH.Trim() } else { $NVIM_EXE_PATH = "C:\Program Files\Neovim\bin\nvim.exe" }
if ($NVIM_QT_PATH)  { $NVIM_QT_PATH  = $NVIM_QT_PATH.Trim() } else { $NVIM_QT_PATH  = "C:\Program Files\Neovim\bin\nvim-qt.exe" }

# 2. 正确获取 Vivado 传入的参数
$FILE = $args[0]
$LINE = $args[1]

# 额外处理：如果 Vivado 传过来的行号自带了 "+" 号（如 +10），去掉正号只留数字
if ($LINE -match '^\+(.+)$') { $LINE = $Matches[1] }

# 定义本地 TCP 监听服务器
$NVIM_SERVER = "127.0.0.1:55432"

Write-Host "--- 调试与路径验证 ---" -ForegroundColor Cyan
Write-Host "探测到 nvim-qt 路径: $NVIM_QT_PATH"
Write-Host "收到的文件路径: $FILE"
Write-Host "收到的行号: $LINE"

if (-not $FILE) {
    Write-Host "错误：未收到有效的文件路径参数！" -ForegroundColor Red
    Exit
}

# 【核心修改点 1】同时检查网络端口和前台 GUI 进程
$PortActive = $true
try {
    $socket = New-Object System.Net.Sockets.TcpClient
    $socket.Connect("127.0.0.1", 55432)
    $socket.Close()
} catch {
    $PortActive = $false
}

# 检查系统里有没有正在运行的 nvim-qt 界面
$GUIActive = Get-Process -Name "nvim-qt" -ErrorAction SilentlyContinue

# 【核心修改点 2】只有当端口活着 且 前台窗口也活着，才判定为“服务器真正可用”
if ($PortActive -and $GUIActive) {
    Write-Host "服务器已在运行，正在直接将新文件投递到已有窗口..." -ForegroundColor Green
    
    # 将带有反斜杠的 Windows 路径和行号封装为纯文本，通过 remote-send 强制灌入正在前台运行的服务器
    & $NVIM_EXE_PATH --server $NVIM_SERVER --remote-send ":e $FILE<CR>:$LINE<CR>"
    
    # 强行把已有窗口提到前台
    try {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.AppActivate("nvim-qt") | Out-Null
    } catch {}

} else {
    Write-Host "服务器未启动（或窗口已被手动关闭），正在重新初始化 nvim-qt 并清理残留进程..." -ForegroundColor Yellow
    
    # 【核心修改点 3】防患于未然：如果窗口关了但后台有残留的隐藏 nvim 进程，先强行清理，释放端口
    Get-Process -Name "nvim" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 100
    
    # 重新拉起精美的前台 GUI 窗口，并让其亲自监听端口，加载第一个文件和行号
    & $NVIM_QT_PATH -- --listen $NVIM_SERVER $FILE "+$LINE"
}