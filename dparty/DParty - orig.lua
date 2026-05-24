_addon.name = 'DParty'
_addon.author = 'Miang'
_addon.version = '0.1'

require('sets')
require('functions')
texts = require('texts')
config = require('config')

lastPing = os.clock()

defaults = {}
defaults.ShowPartyDistance = true
defaults.bgVisible = true
defaults.bgRed = 120
defaults.bgGreen = 120
defaults.bgBlue = 120
defaults.bgAlpha = 120

-- Default text properties and per-distance groups
defaults.default_text = {
    size_small = 10,
    size_large = 8,
    alpha = 185,
    red = 255,
    green = 255,
    blue = 255,
}

-- Properties for distances <=22
defaults.text_lt22 = {
    textRed = 0,
    textGreen = 255,
    textBlue = 0,
    bgVisible = false,
    bgRed = defaults.bgRed,
    bgGreen = defaults.bgGreen,
    bgBlue = defaults.bgBlue,
    bgAlpha = defaults.bgAlpha,
}

-- Properties for distances between 22 and 40
defaults.text_22_40 = {
    textRed = 255,
    textGreen = 255,
    textBlue = 255,
    bgVisible = false,
    bgRed = defaults.bgRed,
    bgGreen = defaults.bgGreen,
    bgBlue = defaults.bgBlue,
    bgAlpha = defaults.bgAlpha,
}

-- Properties for distances > 40
defaults.text_gt40 = {
    textRed = 255,
    textGreen = 255,
    textBlue = 255,
    bgVisible = true,
    bgRed = defaults.bgRed,
    bgGreen = defaults.bgGreen,
    bgBlue = defaults.bgBlue,
    bgAlpha = defaults.bgAlpha,
}

settings = config.load(defaults)

dp = T{}

do
    local x_pos = windower.get_windower_settings().ui_x_res - 164

    for i = 0, 17 do
        local party = (i / 6):floor() + 1
        local key = {'p%i', 'a1%i', 'a2%i'}[party]:format(i % 6)
        local pos_base = {-34, -389, -288}
        dp[key] = texts.new('${distance}', {
            pos = {
                x = x_pos,
                y = pos_base[party] + 16 * (i % 6)
            },
            bg = {
                visible = settings.bgVisible,
                alpha = settings.bgAlpha,
                red = settings.bgRed,
                green = settings.bgGreen,
                blue = settings.bgBlue,
            },
            flags = {
                right = false,
                bottom = true,
                bold = true,
                draggable = false,
                italic = true,
            },
            text = {
                size = i < 6 and settings.default_text.size_small or settings.default_text.size_large,
                alpha = settings.default_text.alpha,
                red = settings.default_text.red,
                green = settings.default_text.green,
                blue = settings.default_text.blue,
            },
        })
    end
end

key_indices = {
    p0 = 1,
    p1 = 2,
    p2 = 3,
    p3 = 4,
    p4 = 5,
    p5 = 6,
}
tp_y_pos = {}
for i = 1, 6 do
    tp_y_pos[i] = -34 - 20 * (6 - i)
end

if settings.ShowPartyDistance then
windower.register_event('prerender', function()
    if os.clock()-lastPing < 1 then
        return
    end

    local party = T(windower.ffxi.get_party())
    local zone = windower.ffxi.get_info().zone

    for text, key in dp:it() do
        local member = party[key]
        if member and member.zone == zone and member.mob ~= nil and member.mob.distance ~= nil then
            member.distance = math.floor(math.sqrt(member.mob.distance) * 100)/ 100
            -- Adjust position for party member count
            if key:startswith('p') then
                text:pos_y(tp_y_pos[key_indices[key] + 6 - party.party1_count])
            end

            -- Select text appearance based on distance groups loaded from settings
            local grp
            if member.distance <= 22 then
                grp = settings.text_lt22
            elseif member.distance > 40 then
                grp = settings.text_gt40
            else
                grp = settings.text_22_40
            end

            text:bg_visible(grp.bgVisible)
            text:color(grp.textRed, grp.textGreen, grp.textBlue)
            text:bg_color(grp.bgRed, grp.bgGreen, grp.bgBlue)
            text:bg_alpha(grp.bgAlpha)

            if member.distance == 52.97 then
                member.distance = '---'
            end

            text:update(member)
            text:show()
        else
            text:bg_visible(false)
            text:hide()
        end
    end

    lastPing = os.clock()
end)
end
--[[
Copyright © 2014-2015, Windower
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Windower nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Windower BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]
