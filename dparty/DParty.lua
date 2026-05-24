_addon.name = 'DParty'
_addon.author = 'Modified'
_addon.version = '1.2'

require('tables')
texts = require('texts')
config = require('config')

lastPing = os.clock()

defaults = {
    pos = {x = 1780, y = 800},
    bgVisible = true,
    bgAlpha = 255,
    bgRed = 0,
    bgGreen = 0,
    bgBlue = 0,
    text = {
        font = 'Consolas',
        size = 10,
        alpha = 255,
        red = 255,
        green = 255,
        blue = 255,
    },
}

settings = config.load(defaults)

-- Create window
dp_window = texts.new('', {
    pos = settings.pos,
    bg = {
        visible = true,
        alpha = 255,
        red = 0,
        green = 0,
        blue = 0,
    },
    flags = {
        draggable = true,
    },
    text = settings.text,
})

-- Force solid background
dp_window:bg_visible(true)
dp_window:bg_alpha(255)
dp_window:bg_color(0, 0, 0)

dp_window:show()

-- Distance coloring
local function get_color(distance)
    if distance <= 22 then
        return '\\cs(0,255,0)'
    elseif distance > 40 then
        return '\\cs(255,100,100)'
    else
        return '\\cs(255,255,255)'
    end
end

windower.register_event('prerender', function()
    if os.clock() - lastPing < 1 then return end

    local party = windower.ffxi.get_party()
    local zone = windower.ffxi.get_info().zone

    local lines = {}

    -- Find longest name for tight formatting
    local max_len = 0
    for i = 0, 5 do
        local m = party['p'..i]
        if m and m.name then
            max_len = math.max(max_len, #m.name)
        end
    end

    max_len = math.min(max_len, 10)

	local fmt = ' %-'..max_len..'s  |  %s%s\\cr '

    for i = 0, 5 do
        local member = party['p'..i]

        if member and member.name and member.zone == zone and member.mob then
            local dist = member.mob.distance

            if dist then
                dist = math.sqrt(dist)
                dist = math.floor(dist * 100) / 100

                local color = get_color(dist)

                if dist == 52.97 then
                    dist = '---'
                end

                local formatted = string.format(fmt, member.name, color, tostring(dist))
                table.insert(lines, formatted)
            end
        end
    end

    dp_window:text(table.concat(lines, '\n'))

    lastPing = os.clock()
end)