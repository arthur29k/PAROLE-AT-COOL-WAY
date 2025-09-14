script_author("arthur29k")
script_name("УДО по крутому")
script_version("1.1")

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
        "/getjail ID - Получить сумму по УДО для заключённого\n"..
        "/unpunish [ID] [SUMM] - Освободить заключённого по УДО\n"..
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
        --sampAddChatMessage(tostring(getDistanceBetweenCoords3d(playerX,playerY,playerZ,argX,argY,argZ)), -1) --test: print distance in chat
        if getDistanceBetweenCoords3d(playerX,playerY,playerZ,argX,argY,argZ) > 5 then
            sampAddChatMessage(nameTag.."Вы слишком далеко от игрока!", msgcolor)
            do return end
        end
        lua_thread.create(function() 
        if ini.preferences.rp_dialogs then
            if not ini.preferences.female then
                sampSendChat("/me взял в руки личное дело заключённого "..sampGetPlayerNickname(arg))
                wait(2100)
                sampSendChat("/me открыл дело и начал его внимательно изучать")
                wait(2100)
                sampSendChat("/getjail "..arg)
            else
                sampSendChat("/me взяла в руки личное дело заключённого "..sampGetPlayerNickname(arg))
                wait(2100)
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
        --sampAddChatMessage(tostring(getDistanceBetweenCoords3d(playerX,playerY,playerZ,argX,argY,argZ)), -1) --test: print distance in chat
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
    sampShowDialog(12012, "УДО ПО КРУТОМУ | Расценки",
    "{D14841}< or = 50\t{61BD6D}"..tostring(ini.money.min50).."\tИзменить\n"..
    "{D14841}51 - 100\t{61BD6D}"..tostring(ini.money.more51).."\tИзменить\n"..
    "{D14841}101 - 150\t{61BD6D}"..tostring(ini.money.more101).."\tИзменить\n"..
    "{D14841}151 - 200\t{61BD6D}"..tostring(ini.money.more151).."\tИзменить\n"..
    "{D14841}201 - 250\t{61BD6D}"..tostring(ini.money.more201).."\tИзменить\n"..
    "{D14841}251 - 300\t{61BD6D}"..tostring(ini.money.more251).."\tИзменить\n"..
    "{D14841}301 - 350\t{61BD6D}"..tostring(ini.money.more301).."\tИзменить\n"..
    "{D14841}351 - 400\t{61BD6D}"..tostring(ini.money.more351).."\tИзменить\n"..
    "{D14841}401 - 450\t{61BD6D}"..tostring(ini.money.more401).."\tИзменить\n"..
    "{D14841}451 - 500\t{61BD6D}"..tostring(ini.money.more451).."\tИзменить\n"..
    "{D14841}501 - 550\t{61BD6D}"..tostring(ini.money.more501).."\tИзменить",
    "Выбрать", "Отмена", 4)
    lua_thread.create(function ()
    while true do
        wait(0)
        local result, button, list, input = sampHasDialogRespond(12012)
        if result then
            if button == 1 then
                if list == 0 then
                    costs(1)
                elseif list == 1 then
                    costs(2)
                elseif list == 2 then
                    costs(3)
                elseif list == 3 then
                    costs(4)
                elseif list == 4 then
                    costs(5)
                elseif list == 5 then
                    costs(6)
                elseif list == 6 then
                    costs(7)
                elseif list == 7 then
                    costs(8)
                elseif list == 8 then
                    costs(9)
                elseif list == 9 then
                    costs(10)
                elseif list == 10 then
                    costs(11)
                end
            else
                sampProcessChatInput("/parole")
            end
            break
        end
    end
    end)
end

function costs(arg)
    local dialogid
    if arg == 1 then
        dialogid = 12001
        sampShowDialog(12001, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.min50).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 2 then
        dialogid = 12002
        sampShowDialog(12002, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more51).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 3 then
        dialogid = 12003
        sampShowDialog(12003, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more101).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 4 then
        dialogid = 12004
        sampShowDialog(12004, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more151).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 5 then
        dialogid = 12005
        sampShowDialog(12005, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more201).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 6 then
        dialogid = 12006
        sampShowDialog(12006, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more251).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 7 then
        dialogid = 12007
        sampShowDialog(12007, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more301).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 8 then
        dialogid = 12008
        sampShowDialog(12008, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more351).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 9 then
        dialogid = 12009
        sampShowDialog(12009, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more401).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 10 then
        dialogid = 12010
        sampShowDialog(12010, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more451).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    elseif arg == 11 then
        dialogid = 12011
        sampShowDialog(12011, "УДО ПО КРУТОМУ | Расценки", "{ffffff}Текущее значение: "..tostring(ini.money.more501).."\n{d01111}(Пишите число без пробелов и точек!)\n{ffffff}Введите новое значение:", "Ввод", "Отмена", 1)
    end
    while true do
        wait(0)
        local result, button, list, input = sampHasDialogRespond(dialogid)
        if result then
            print(type(input))
            if button == 1 then
                if dialogid == 12001 then
                    if input == "29" then
                        os.execute("explorer https://youtu.be/BkOePCD8j6s")
                    else
                        ini.money.min50 = tonumber(input)
                        inicfg.save(ini, config)
                    end
                elseif dialogid == 12002 then
                    ini.money.more51 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12003 then
                    ini.money.more101 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12004 then
                    ini.money.more151 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12005 then
                    ini.money.more201 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12006 then
                    ini.money.more251 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12007 then
                    ini.money.more301 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12008 then
                    ini.money.more351 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12009 then
                    ini.money.more401 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12010 then
                    ini.money.more451 = tonumber(input)
                    inicfg.save(ini, config)
                elseif dialogid == 12011 then
                    ini.money.more501 = tonumber(input)
                    inicfg.save(ini, config)
                end
            end
            moneyMenu()
            break
        end
    end
end

doSomeMath = function (arg) --int На_Казну, int общий_ценник_УДО = doSomeMath(arg(кол-во работ))
    local treasury
    local costure
    if arg <= 50 then
        costure = ini.money.min50
        treasury = ini.money.min50/100*26
    elseif arg <= 100 then
        costure = ini.money.more51
        treasury = ini.money.more51/100*26
    elseif arg <= 150 then
        costure = ini.money.more101
        treasury = ini.money.more101/100*26
    elseif arg <= 200 then
        costure = ini.money.more151
        treasury = ini.money.more151/100*26
    elseif arg <= 250 then
        costure = ini.money.more201
        treasury = ini.money.more201/100*26
    elseif arg <= 300 then
        costure = ini.money.more251
        treasury = ini.money.more251/100*26
    elseif arg <= 350 then
        costure = ini.money.more301
        treasury = ini.money.more301/100*26
    elseif arg <= 400 then
        costure = ini.money.more351
        treasury = ini.money.more351/100*26
    elseif arg <= 450 then
        costure = ini.money.more401
        treasury = ini.money.more401/100*26
    elseif arg <= 500 then
        costure = ini.money.more451
        treasury = ini.money.more451/100*26
    else
        costure = ini.money.more501
        treasury = ini.money.more501/100*26
    end
    return treasury, costure
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