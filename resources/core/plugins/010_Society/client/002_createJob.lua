---newJob
---@param job string
---@param data table
function Society.newJob(job, data)
    Society.Jobs[job] = {
        name = job,
        Blips = data.Blips or false,
        Radial = data.Radial or false,
        Stockage = data.Stockage or false,
        Casier = data.Casier or false,
        Catalogue = data.Catalogue or false,
        Farm = data.Farm or false,
        Vetement = data.Vetement or false,
        Garage = data.Garage or false,
        Craft = data.Craft or false,
        Sonnette = data.Sonnette or false,
        Gestion = data.Gestion or false,
        NumberCasier = data.NumberCasier or 100,
        CamGestion = data.CamGestion or false,
    }
    
    if Society.Jobs[job].Radial then
        VFW.Jobs.RadialMenu[job] = Society.Jobs[job].Radial
    end
end
