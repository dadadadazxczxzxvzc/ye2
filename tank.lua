getgenv().S_Hold = {
    Enabled = false;
    Notifications = true;
    Keybind = 'k';
}

-- [[ ======================================================================================== ]]
local ChildAdded = function(Child)
    if (not S_Hold.Enabled) then return end
    if (not Child:IsA('Tool')) then return end

    local Handle = Child.Handle
    if (not Handle) then return end

    for _, Descendant in next, Handle:GetDescendants() do
        if (Descendant:IsA('TouchTransmitter')) then
            Descendant:Destroy()
        end
    end
end

for _, Player in next, game.Players:GetPlayers() do
    if (Player == game.Players.LocalPlayer) then continue end

    Player.CharacterAdded:Connect(function(Character)
        Character.ChildAdded:Connect(ChildAdded)
    end)
end

game.Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        Character.ChildAdded:Connect(ChildAdded)
    end)
end)

-- [[ ======================================================================================== ]]

local SendNotification = function(Message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "S Hold",
        Text = Message,
        Duration = 2
    })
end


local Notify = function(Message)
    if (not S_Hold.Notifications) then return end

    SendNotification(Message)
end

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(Key)
    if (Key:lower() == S_Hold.Keybind:lower()) then
        S_Hold.Enabled = not S_Hold.Enabled
        Notify('S Hold: '..(S_Hold.Enabled and 'Enabled' or 'Disabled'))
    end
end)
