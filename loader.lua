--! Delta
local WS = workspace

-- 1. coba matikan streaming
for _, f in ipairs({
    function() return sethiddenproperty(WS, "StreamingEnabled", false) end,
    function() return setproperty(WS, "StreamingEnabled", false) end,
}) do pcall(f) end
pcall(function() WS.StreamingEnabled = false end)

-- 2. grid scan — paksa server stream tiap area
local EXTENT = 9000      -- setengah lebar peta, sesuaikan
local STEP   = 9000       -- radius stream per panggilan
local n      = 0

for x = -EXTENT, EXTENT, STEP do
    for z = -EXTENT, EXTENT, STEP do
        pcall(function()
            WS:RequestStreamAroundAsync(Vector3.new(x, 0, z), 1)
        end)
        n = n + 1
        if n % 25 == 0 then
            task.wait(0.1)
            print(("[scan] %d titik | descendants=%d"):format(n, #WS:GetDescendants()))
        end
    end
end

task.wait(8)  -- biar chunk terakhir selesai masuk

-- 3. simpan
for _, opt in ipairs({
    {FileName = "workspace_full.rbxl", Mode = "full", noscripts = false},
    "full",
}) do
    if pcall(function() saveinstance(opt) end) then break end
end

print(("[done] descendants=%d"):format(#WS:GetDescendants()))
