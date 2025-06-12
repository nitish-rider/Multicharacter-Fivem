Config = {}

Config.Framework = "qb"
Config.Core = "qb-core"
Config.Mysql = "oxmysql"

Config.Link = "YOUR_DISCORD_TICKET_LINK"

Config.MaxCharSlot = 4
Config.DefaultOpenCharSlot = 1

Config.UseQbApartments = false

Config.Interior = vector3(937.22, 20.06, 112.55)
Config.DefaultSpawn = vector4(937.22, 20.06, 112.55, 60.92)
Config.PedCoords = vector4(937.22, 20.06, 112.55, 60.92)
Config.HiddenCoords = vector4(-294.725, -804.576, 86.01, 162.469)
Config.CamCoords = vector4(932.12, 23.09, 112.55, 236.24)
Config.EnableDeleteButton = true

Config.PlayersNumberOfCharacters = {
    { license = "license:XXX", numberOfChars = 3 },
}

Config.StarterItems = {
    { item = "phone", amount = 1 },
}

Config.PlayerLoaded = function(citizenId)

end

-- Camera Config
Config.CameraFoV = 10.0
Config.CameraNearDof = 0.8
Config.CameraFarDof = 3.0
Config.CameraDofStrength = 0.2

-- Shake Config
Config.ShakeType = "HAND_SHAKE"
Config.CameraShake = 0.3

Config.Ban = true   ---- Set To True To Ban Player or False To Kick Player