script_author("arthur29k")
script_name("УДО по крутому")
script_version("1.0")

local inicfg = require "inicfg"
require "kurmanin.kys"
local sampev = require "samp.events"

local msgcolor = ('0xFFDA72EE')
local nameTag = ("[УДО ПО КРУТОМУ]{ffffff} ")

local config = "parole.ini"
local ini = inicfg.load({
    preferences = {
        rp_dialogs = true,
        female = false
    },
    money = {
        min50 = 21000000,
        more51 = 26250000,
        more101 = 31500000,
        more151 = 36750000,
        more201 = 42000000,
        more251 = 47250000,
        more301 = 52500000,
        more351 = 57750000,
        more401 = 63000000,
        more451 = 68250000,
        more501 = 73500000
    }
}, config)

function main()
    while not isSampAvailable() do wait(100) end
    sampAddChatMessage(nameTag.."Скриптик загружен, для помощи вводите /parole_help, для настройки /parole", msgcolor)
    sampAddChatMessage(nameTag.."Автор: arthur29k, версия: "..tostring(thisScript().version), msgcolor)
    sampRegisterChatCommand("fuckoff", function ()
        fuckoff = true
        thisScript():unload()
    end)
    sampRegisterChatCommand("comeback", function ()
        comeback = true
        thisScript():reload()
    end)
    sampRegisterChatCommand("parole_help", function ()
        sampShowDialog(12101, "УДО ПО КРУТОМУ | Помощь", "{ffffff}«Пасибочки, что используете скрипт, мне очень приятно :3», сказал arthur29k.\n\nВот для вас команды:\n/fuckoff и /comeback - выключить/перезапустить скрипт\n"..
        "/parole - меню настроек скрипта\n"..
        "/getjail ID - Получить сумму по удо для заключённого\n"..
        "/unpunish [ID] [SUMM] - Освободить заключённого по удо\n"..
        "/jinfo - Оповещение о проведении УДО", "Ок", nil, 0)
    end)
    sampRegisterChatCommand("parole", function ()
        local rpd_color
        local fem_color
        if ini.preferences.rp_dialogs then
            rpd_color = "{2deb36}"
        else
            rpd_color = "{f31b23}"
        end
        if ini.preferences.female then
            fem_color = "{2deb36}"
        else
            fem_color = "{f31b23}"
        end
        sampShowDialog(12100, "УДО ПО КРУТОМУ | Настройки", "Настройка\tОписание\tАктивность\nРп диалоги\tРпшить в /me /do и т.д при использовании команд\t"..rpd_color..tostring(ini.preferences.rp_dialogs)..
            "\nЖенский пол\tОписывать действия в женском роде\t"..fem_color..tostring(ini.preferences.female)..
            "\nНастройка расценок\tОткрыть меню настройки расценок\tОткрыть",
            "Выбор", "Отмена", 5)
        lua_thread.create(function ()
        while true do
            wait(0)
            local result, button, list, input = sampHasDialogRespond(12100)
            if result then
                if button == 1 and list == 0 then
                    ini.preferences.rp_dialogs = not ini.preferences.rp_dialogs
                    inicfg.save(ini, config)
                    sampProcessChatInput("/parole")
                elseif button == 1 and list == 1 then
                    ini.preferences.female = not ini.preferences.female
                    inicfg.save(ini, config)
                    sampProcessChatInput("/parole")
                elseif button == 1 and list == 2 then
                    moneyMenu()
                end
                break
            end
        end
        end)
    end)

    sampRegisterChatCommand("getjail", function (arg)
        if not arg:match("(%d+)") then
            sampAddChatMessage(nameTag.."Используйте: /getjail [ID игрока]", msgcolor)
            do return end
        end
        local result, hped = sampGetCharHandleBySampPlayerId(arg)
        if not result then
            sampAddChatMessage(nameTag.."Не удалось получить hped игрока, перепроверьте введённый ID", msgcolor)
            do return end
        end
        local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
        local argX, argY, argZ = getCharCoordinates(hped)
        sampAddChatMessage(tostring(getDistanceBetweenCoords3d(playerX,playerY,playerZ,argX,argY,argZ)), -1)
        if getDistanceBetweenCoords3d(playerX,playerY,playerZ,argX,argY,argZ) > 5 then
            sampAddChatMessage(nameTag.."Вы слишком далеко от игрока!", msgcolor)
            do return end
        end
        lua_thread.create(function() 
        if ini.preferences.rp_dialogs then
            if not ini.preferences.female then
                --sampAddChatMessage("/me взял в руки личное дело заключённого "..sampGetPlayerNickname(arg), -1) -- test
                sampSendChat("/me взял в руки личное дело заключённого "..sampGetPlayerNickname(arg))
                wait(2100)
                --sampAddChatMessage("/me открыл дело и начал его внимательно изучать", -1)
                sampSendChat("/me открыл дело и начал его внимательно изучать")
                wait(2100)
                sampSendChat("/getjail "..arg)
            else
                --sampAddChatMessage("/me взяла в руки личное дело заключённого "..sampGetPlayerNickname(arg), -1) -- test
                sampSendChat("/me взяла в руки личное дело заключённого "..sampGetPlayerNickname(arg))
                wait(2100)
                --sampAddChatMessage("/me открыла дело и начала его внимательно изучать", -1)
                sampSendChat("/me открыла дело и начала его внимательно изучать")
                wait(2100)
                sampSendChat("/getjail "..arg)
            end
        else
            sampSendChat("/getjail "..arg)
        end
        end)
    end)

    sampRegisterChatCommand("unpunish", function (arg)
        if not arg:match("(%d+) (%d+)") then
            sampAddChatMessage(nameTag.."Используйте: /unpunish [ID игрока] [Сумма УДО]", msgcolor)
            do return end
        end
        local id, summ = arg:match("(%d+) (%d+)")
        local result, hped = sampGetCharHandleBySampPlayerId(id)
        if not result then
            sampAddChatMessage(nameTag.."Не удалось получить hped игрока, перепроверьте введённый ID", msgcolor)
            do return end
        end
        local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
        local argX, argY, argZ = getCharCoordinates(hped)
        sampAddChatMessage(tostring(getDistanceBetweenCoords3d(playerX,playerY,playerZ,argX,argY,argZ)), -1)
        if getDistanceBetweenCoords3d(playerX,playerY,playerZ,argX,argY,argZ) > 5 then
            sampAddChatMessage(nameTag.."Вы слишком далеко от игрока!", msgcolor)
            do return end
        end
        lua_thread.create(function ()
        if ini.preferences.rp_dialogs then
            if ini.preferences.female then
                sampSendChat("/me открыла базу данных, начала проверять информацию о заключённом")
                wait(2100)
                sampSendChat("/me достала бланк инвойса и заполнила информацию")
                wait(2100)
                sampSendChat("/todo Распишитесь вот здесь, пожалуйста*передавая инвойс человеку")
                wait(1500)
                sampSendChat("/unpunish "..id.." "..summ)
            else
                sampSendChat("/me открыл базу данных, начал проверять информацию о заключённом")
                wait(2100)
                sampSendChat("/me достал бланк инвойса и заполнил информацию")
                wait(2100)
                sampSendChat("/todo Распишитесь вот здесь, пожалуйста*передавая инвойс человеку")
                wait(1500)
                sampSendChat("/unpunish "..id.." "..summ)
            end
        end
        end)
    end)

    sampRegisterChatCommand("jinfo", function ()
        lua_thread.create(function()
        sampSendChat("/rjail [Тюремная информация]: Уважаемые заключённые, прошу обратить внимание!")
        wait(2100)
        sampSendChat("/rjail [Тюремная информация]: Сейчас будет проходить выпуск заключённых по УДО!")
        wait(2100)
        sampSendChat("/rjail [Тюремная информация]: Услуга платная! Всех заинтересованных ждём в переговорной!")
        wait(2100)
        sampSendChat("/rjail [Тюремная информация]: Переговорная находится рядом со столовой. Благодарю за внимание!")
    end)end)
    wait(-1)
end

moneyMenu = function ()
    sampShowDialog(12002, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Здесь должно быть крутое меню настройки расценок, \nно в данной версии этот функционал не реализован 3:\nВ случае, если расценки поменяют, а автор не допилит это, то меняйте расценки через конфиг :/", "Эхх...", nil, 0)
    do return end
    sampShowDialog(12002, "УДО ПО КРУТОМУ | Расценки",
    "Кол-во заданий\tСумма за УДО\tПроцент на казну(Авто)\n\
    < 50\t",
    "Выбрать", "Отмена", 5)
end

doSomeMath = function (arg) --int На_Казну, int общий_ценник_УДО = doSomeMath(arg(кол-во работ))
    local treasury
    local costure
    if arg <= 50 then
        costure = ini.money.min50
        treasury = ini.money.min50/100*26
        return treasury, costure
    elseif arg <= 100 then
        costure = ini.money.more51
        treasury = ini.money.more51/100*26
        return treasury, costure
    elseif arg <= 150 then
        costure = ini.money.more101
        treasury = ini.money.more101/100*26
        return treasury, costure
    elseif arg <= 200 then
        costure = ini.money.more201
        treasury = ini.money.more201/100*26
        return treasury, costure
    elseif arg <= 250 then
        costure = ini.money.more251
        treasury = ini.money.more251/100*26
        return treasury, costure
    elseif arg <= 300 then
        costure = ini.money.more301
        treasury = ini.money.more301/100*26
        return treasury, costure
    elseif arg <= 350 then
        costure = ini.money.more351
        treasury = ini.money.more351/100*26
        return treasury, costure
    elseif arg <= 400 then
        costure = ini.money.more401
        treasury = ini.money.more401/100*26
        return treasury, costure
    elseif arg <= 450 then
        costure = ini.money.more451
        treasury = ini.money.more451/100*26
        return treasury, costure
    elseif arg <= 500 then
        costure = ini.money.more451
        treasury = ini.money.more451/100*26
        return treasury, costure
    else
        costure = ini.money.more501
        treasury = ini.money.more501/100*26
        return treasury, costure
    end
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    text = text:gsub('{.-}','') --удаление хексов
    if text:find("Тюремные наказания") then
        local box = text:match("Перенести (%d+) ящиков")
        local cook = text:match("Приготовить (%d+) порций")
        local wash = text:match("Перестирать (%d+) грязной")
        local trash = text:match("на мусорку (%d+) мусора")
        local works = box+cook+wash+trash
        sampAddChatMessage(nameTag.."Выполнено работ в общем: "..works, msgcolor)
        local tres, cost = doSomeMath(works)
        sampAddChatMessage(nameTag.."Цена на удо: "..cost..". На казну нужно положить: "..tres, msgcolor)
    end
end

function onScriptTerminate(script, quit)
    if script == thisScript() and not quit and not fuckoff and not comeback then
        sampAddChatMessage(nameTag.."Скрипт крашнулся, плачем:(...(чекаем консоль сампфункс)", msgcolor)
    end
end