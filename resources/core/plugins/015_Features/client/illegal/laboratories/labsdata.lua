FormattedDrugDataNeeds = {
    ['weed'] = {
        levelthree = {
            engrais = 30,
            fertilisant = 30,
            grainescannabis = 90,
        },
        levelfour = {
            --engrais = 35,
            --fertilisant = 35,
            --grainescannabis = 140,
            engrais = 30,
            fertilisant = 30,
            grainescannabis = 90,
        },
        levelfive = {
            --engrais = 40,
            --fertilisant = 40,
            --grainescannabis = 160,
            engrais = 30,
            fertilisant = 30,
            grainescannabis = 90,
        },
    },
    ['fentanyl'] = {
        levelthree = {
            pavosomnifere = 60,
            chlorureammonium = 60,
            phenylacetone = 30,
        },
        levelfour = {
            --pavosomnifere = 280,
            --chlorureammonium = 70,
            --phenylacetone = 70,
            pavosomnifere = 60,
            chlorureammonium = 60,
            phenylacetone = 30,
        },
        levelfive = {
            --pavosomnifere = 320,
            --chlorureammonium = 80,
            --phenylacetone = 80,
            pavosomnifere = 60,
            chlorureammonium = 60,
            phenylacetone = 30,
        },
    },
    ['coke'] = {
        levelthree = {
            essence = 1,
            feuilledecoca = 90,
            acidesulfurique = 45,
        },
        levelfour = {
            --essence = 70,
            --feuilledecoca = 560,
            --acidesulfurique = 70,
            essence = 1,
            feuilledecoca = 90,
            acidesulfurique = 45,
        },
        levelfive = {
            --essence = 80,
            --feuilledecoca = 640,
            --acidesulfurique = 80,
            essence = 1,
            feuilledecoca = 90,
            acidesulfurique = 45,
        },
    },
    ['meth'] = {
        levelthree = {
            ephedrine = 30,
            lithium = 60,
            phenylacetone = 60,
        },
        levelfour = {
            --ephedrine = 40,
            --lithium = 70,
            --phenylacetone = 70,
            ephedrine = 30,
            lithium = 60,
            phenylacetone = 60,
        },
        levelfive = {
            --ephedrine = 40,
            --lithium = 80,
            --phenylacetone = 80,
            ephedrine = 30,
            lithium = 60,
            phenylacetone = 60,
        },
    },
}

MaxTimeProductions = {
    [0] = 70,
    [1] = 70,
    [2] = 70,
    [3] = 70,
    [4] = 60,
    [5] = 45,
}

function GetPercentageLabo(item, ItemCount, notify, crewlevel, dtype)
    -- ## Systeme de pourcentage a refaire
    if ItemCount == 0 or ItemCount == nil or ItemCount == false then 
        if notify then
            VFW.ShowNotification({
                type = 'ROUGE',
                content = "Il vous manque l'ingrédient "..VFW.Labs.LabNames[item].." !"
            })
        end
        return 0
    end
    local value = 5
    if crewlevel == 3 then
        value = FormattedDrugDataNeeds[dtype].levelthree[item]
    elseif crewlevel == 2 or crewlevel == 1 then
        value = FormattedDrugDataNeeds[dtype].levelthree[item]
    elseif crewlevel == 4 then
        value = FormattedDrugDataNeeds[dtype].levelfour[item]
    elseif crewlevel == 5 then
        value = FormattedDrugDataNeeds[dtype].levelfive[item]
    end
    local percentage = math.floor((ItemCount/value)*100)
    if percentage > 100 then percentage = 100 end
    return percentage
end

function HasExceedMaxValue(value, crewlevel, dtype, item)
    if crewlevel == 3 then
        if value and value > FormattedDrugDataNeeds[dtype].levelthree[item] then 
            value = FormattedDrugDataNeeds[dtype].levelthree[item]
        end
    elseif crewlevel == 2 then
        if value and value > FormattedDrugDataNeeds[dtype].levelthree[item] then 
            value = FormattedDrugDataNeeds[dtype].levelthree[item]
        end
    elseif crewlevel == 4 then
        if value and value > FormattedDrugDataNeeds[dtype].levelfour[item] then 
            value = FormattedDrugDataNeeds[dtype].levelfour[item]
        end
    elseif crewlevel == 5 then
        if value and value > FormattedDrugDataNeeds[dtype].levelfive[item] then 
            value = FormattedDrugDataNeeds[dtype].levelfive[item]
        end
    end
    return value
end

function GetNeededAmountForItem(item, crewLevel, labType)
    if crewLevel <= 3 then
        return FormattedDrugDataNeeds[labType].levelthree[item]
    elseif crewLevel == 4 then
        return FormattedDrugDataNeeds[labType].levelfour[item]
    elseif crewLevel >= 5 then
        return FormattedDrugDataNeeds[labType].levelfive[item]
    end
end