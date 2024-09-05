if game.PlaceId == 6938764986 then
    local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
    local Window = OrionLib:MakeWindow({
        Name = "Absalute Hub | Airplane Simulator",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "Absalute Hub",
        IntroText = "By pigpizza#0"
    })

    local planeChosen = "Cessna Skyhawk"
    local planeSpawnMethod = "Original"
    local autoStartEngine = false
    local autoDriveForward = false
    local exitBeforeTeleport = false
    local teleportDelay = 0.25
    local autoDelay = 2
    local autoDriveForwardTimer = 0,
    local planeSpawnerNum = "1"
    local planeSpawner

    -- Plane Tab
    local PlaneTab = Window:MakeTab({
        Name = "Plane",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    PlaneTab:AddDropdown({
        Name = "Plane Spawner",
        Default = "1",
        Options = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"},
        Callback = function(Value)
            planeSpawnerNum = Value
        end    
    })

    PlaneTab:AddToggle({
        Name = "Auto start engine",
        Default = false,
        Callback = function(Value)
            
            autoStartEngine = Value
        end
    })
    PlaneTab:AddToggle({
        Name = "Auto drive forward",
        Default = false,
        Callback = function(Value)
            autoDriveForward = Value
        end
    })


    -- Get the list of planes from ReplicatedStorage
    local planeOptions = {}
    local vehiclesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Vehicles")
    for _, plane in ipairs(vehiclesFolder:GetChildren()) do
        table.insert(planeOptions, plane.Name)
    end

    PlaneTab:AddDropdown({
        Name = "Select Plane",
        Default = planeChosen,
        Options = planeOptions,
        Callback = function(Value)
            planeChosen = Value
        end
    })

    PlaneTab:AddButton({
        Name = "Spawn Selected Plane",
        Callback = function()
            if planeChosen then
                -- Construct the correct planeSpawner string
                if planeSpawnerNum == "1" then
                    planeSpawner = "Spawners"
                else
                    planeSpawner = "Spawners" .. planeSpawnerNum
                end
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()

                -- Ensure the character's HumanoidRootPart exists before proceeding
                local rootPart = character:WaitForChild("HumanoidRootPart")

                -- Make sure the player is seated in a vehicle
                if character:FindFirstChildOfClass("Humanoid").Sit then
                    -- Force the player to stand up, effectively exiting the vehicle
                    character:FindFirstChildOfClass("Humanoid").Sit = false
                    
                    -- Wait for a brief moment to ensure the player has exited the vehicle
                    wait(0.5)
                    local player = game:GetService("Players").LocalPlayer
                    

                end
                local planeGui = player:WaitForChild("PlayerGui"):FindFirstChild("PlaneGui")

                if planeGui then
                    planeGui.Enabled = false
                end
                -- Get the current position of the player
                local currentPosition = rootPart.Position

                -- Subtract 5 from the current Y-coordinate
                local newPosition = Vector3.new(currentPosition.X, currentPosition.Y - 5, currentPosition.Z)

                -- Teleport the character to the new position
                rootPart.CFrame = CFrame.new(newPosition)
                local args = {
                    planeChosen,
                    workspace:WaitForChild(planeSpawner),
                    planeSpawnMethod,
                    true
                }
    
                local spawnVehicle = game:GetService("ReplicatedStorage"):WaitForChild("SpawnVehicle")
    
                if spawnVehicle then
                    spawnVehicle:FireServer(unpack(args))
                    OrionLib:MakeNotification({
                        Name = "Plane Spawned!",
                        Content = "Successfully spawned a " .. planeChosen,
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                    
                    if autoStartEngine then 
                        wait(autoDelay)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        wait(0.25)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                    if autoDriveForward then
                        wait(autoDelay)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
                        if autoDriveForwardTimer ~= 99 then
                            wait(autoDriveForwardTimer)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.W, false, game)
                else
                    warn("SpawnVehicle not found in ReplicatedStorage.")
                    OrionLib:MakeNotification({
                        Name = "Error: SpawnVehicle Not Found!",
                        Content = "Refresh the game or try using another executor.",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                end
            else
                warn("No plane chosen.")
                OrionLib:MakeNotification({
                    Name = "No Plane Selected!",
                    Content = "Please select a plane before spawning.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    })

    PlaneTab:AddButton({
        Name = "Exit the Plane",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            -- Ensure the character's HumanoidRootPart exists before proceeding
            local rootPart = character:WaitForChild("HumanoidRootPart")

            -- Make sure the player is seated in a vehicle
            if character:FindFirstChildOfClass("Humanoid").Sit then
                -- Force the player to stand up, effectively exiting the vehicle
                character:FindFirstChildOfClass("Humanoid").Sit = false
                
                -- Wait for a brief moment to ensure the player has exited the vehicle
                wait(0.5)
                local player = game:GetService("Players").LocalPlayer
                

            end
            local planeGui = player:WaitForChild("PlayerGui"):FindFirstChild("PlaneGui")

            if planeGui then
                planeGui.Enabled = false
            end
            -- Get the current position of the player
            local currentPosition = rootPart.Position

            -- Subtract 5 from the current Y-coordinate
            local newPosition = Vector3.new(currentPosition.X, currentPosition.Y - 5, currentPosition.Z)

            -- Teleport the character to the new position
            rootPart.CFrame = CFrame.new(newPosition)
        end
    })

    -- Teleport Tab
    local TeleportTab = Window:MakeTab({
        Name = "Teleport",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    TeleportTab:AddToggle({
        Name = "Exit plane before teleporting",
        Default = false,
        Callback = function(Value)
            exitBeforeTeleport = Value
        end    
    })

    local placesId = {
        ["Fin Whale"] = 1,
        ["Timbuktu"] = 2,
        ["Princess Juliana"] = 3,
        ["Tower"] = 4,
        ["Garge"] = 5,
        ["Speed Circuit"] = 6,
        ["Grenveld Iceberg"] = 7,
        ["Mujeres"] = 8,
        ["Grand Case"] = 9,
        ["Redang Island"] = 10,
        ["Castille Isle"] = 11,
        ["Male Velana"] = 12,
        ["Sentosa Island"] = 13,
        ["Tok Bali Island"] = 14
    }

    TeleportTab:AddDropdown({
        Name = "Place",
        Options = {
            "Tower",
            "Garge",
            "Fin Whale",
            "Timbuktu",
            "Princess Juliana",
            "Speed Circuit",
            "Grenveld Iceberg",
            "Mujeres",
            "Grand Case",
            "Redang Island",
            "Castille Isle",
            "Male Velana",
            "Sentosa Island",
            "Tok Bali Island"
        },
        Callback = function(Value)
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            local rootPart = character:WaitForChild("HumanoidRootPart")

            if exitBeforeTeleport and character:FindFirstChildOfClass("Humanoid").Sit then
                character:FindFirstChildOfClass("Humanoid").Sit = false
                wait(teleportDelay)
            end

            local placeName = Value
            local placeId = placesId[placeName]
            
            if placeId then
                local spawnPlayer = game:GetService("ReplicatedStorage"):WaitForChild("SpawnPlayer")
                if spawnPlayer then
                    spawnPlayer:InvokeServer(placeId)
                else
                    warn("SpawnPlayer not found in ReplicatedStorage.")
                    OrionLib:MakeNotification({
                        Name = "Error: SpawnPlayer Not Found!",
                        Content = "Refresh the game or try using another executor.",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                end
            else
                warn("Place ID not found for: " .. placeName)
            end            
        end
    })

    -- Settings Tab
    local SettingsTab = Window:MakeTab({
        Name = "Settings",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    SettingsTab:AddDropdown({
        Name = "Plane Spawn Method",
        Options = {"Original", "New"},
        Default = "Original",
        Callback = function(Value)
            planeSpawnMethod = Value
        end
    })

    SettingsTab:AddSlider({
        Name = "Delay before teleport",
        Min = 0,
        Max = 5,
        Default = 0,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 0.25,
        ValueName = "secs",
        Callback = function(Value)
            teleportDelay = Value
        end
    })

    SettingsTab:AddSlider({
        Name = "Delay before auto features",
        Min = 0,
        Max = 5,
        Default = 2,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 0.25,
        ValueName = "secs",
        Callback = function(Value)
            autoForwardDriveTimer = Value
        end
    })
    SettingsTab:AddSlider({
        Name = "Timer of auto drive forward(99 for infinite)",
        Min = 0,
        Max = 99,
        Default = 0,
        Color = Color3.fromRGB(255, 255, 255),
        Increment = 0.25,
        ValueName = "secs",
        Callback = function(Value)
            autoDriveForwardTimer = Value
        end
    })

    -- Initialize the window
    Window:Init()
end
