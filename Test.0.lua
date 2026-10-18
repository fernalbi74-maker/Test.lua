-- TBSOBR: доступные объекты и сетевые интерфейсы
-- Собирает названия, типы и пути объектов.
-- Не извлекает закрытый серверный исходный код.

local output = {}

local function add(text)
    output[#output + 1] = text
end

local function scan(root)
    local ok, objects = pcall(function()
        return root:GetDescendants()
    end)

    if not ok then
        return
    end

    for _, obj in ipairs(objects) do
        local class = obj.ClassName

        if obj:IsA("LuaSourceContainer")
            or obj:IsA("RemoteEvent")
            or obj:IsA("RemoteFunction") then

            add(
                "Name: " .. obj.Name ..
                "\nType: " .. class ..
                "\nPath: " .. obj:GetFullName() ..
                "\n------------------------"
            )
        end
    end
end

scan(game)

local report = table.concat(output, "\n")

print("Найдено объектов: " .. #output)
print(report)

if setclipboard then
    setclipboard(report)
    print("Отчёт скопирован в буфер обмена.")
end
