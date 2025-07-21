VFW.Jobs.Catalogue.Items = {
    ["lspd"] = {
        Nui = {
            defaultCategory = "Équipements",
            lastCategory = "Équipements",
            headCategory = {
                show = true,
                items = {
                    { label = "Équipements", id = "Équipements" },
                    { label = "Armes",       id = "Armes" },
                    { label = "Kevlar",      id = "Kevlar" },
                }
            }
        },

        Items = {
            ["Équipements"] = {
                {
                    name = "radio",
                    label = "Radio"
                },
                {
                    name = "tabletmdt",
                    label = "MDT"
                },
                {
                    name = "badge_lspd",
                    label = "LSPD - Insigne"
                }
            },
            ["Armes"] = {
                {
                    name = "shield",
                    label = "Bouclier anti-émeute",
                    minGrade = "novice"
                },
                {
                    name = "weapon_smokelspd",
                    label = "Fumigene",
                    minGrade = "novice"
                },
                {
                    name = "weapon_flare",
                    label = "Fusée de détresse",
                    minGrade = "novice"
                },
                {
                    name = "weapon_bzgas",
                    label = "GAZ BZ",
                    minGrade = "novice"
                },
                {
                    name = "weapon_pepperspray",
                    label = "Pepper Spray",
                    minGrade = "novice"
                },
                {
                    name = "weapon_combatpistol",
                    label = "Glock 17",
                    minGrade = "exp"
                },
                {
                    name = "weapon_pumpshotgun",
                    label = "Pompe",
                    minGrade = "copatron"
                },
                {
                    name = "weapon_stungun",
                    label = "Tazer",
                    minGrade = "novice"
                },
                {
                    name = "weapon_tacticalrifle",
                    label = "Colt M4",
                    minGrade = "copatron"
                },
                {
                    name = "weapon_nightstick",
                    label = "Matraque",
                    minGrade = "novice"
                },
                {
                    name = "ammo_pistol",
                    label = "Munition Pistolet",
                    minGrade = "exp"
                },
                {
                    name = "ammo_rifle",
                    label = "Munition Rifle",
                    minGrade = "copatron"
                },
                {
                    name = "ammo_shotgun",
                    label = "Munition Pompe",
                    minGrade = "copatron"
                },   
            },
            ["Kevlar"] = {
                {
                    name = "lspdkevle1",
                    label = "Kevlar Class A 1"
                },
                {
                    name = "lspdkevle2",
                    label = "Kevlar Class A 2"
                },
                {
                    name = "lspdkevle3",
                    label = "Kevlar Class A 3"
                },
                {
                    name = "lspdriot",
                    label = "Protection Anti Emeute"
                },
                {
                    name = "lspdkevm1",
                    label = "Kevlar Class B"
                },
                {
                    name = "lspdkevlo1",
                    label = "Kevlar Class C 1"
                },
                {
                    name = "lspdkevlo2",
                    label = "Kevlar Class C 2"
                },
                {
                    name = "lspdkevlo3",
                    label = "Kevlar Class C 3"
                },
                {
                    name = "lspdswat",
                    label = "Kevlar SWAT"
                },
                {
                    name = "lspdswat2",
                    label = "Kevlar SWAT 2"
                },
                {
                    name = "lspdkevpc",
                    label = "Gilet Pare Couteau"
                },
                {
                    name = "lspdgnd",
                    label = "Gilet GND"
                },
                -- {
                --     name = "lspdgnd2",
                --     label = "Kevlar GND"
                -- },
                {
                    name = "lspdcnt1",
                    label = "Kevlar CNT"
                },
                {
                    name = "lspdgiletj",
                    label = "Gilet Jaune"
                },
            }
        },

        Point = {
            Ped = {
                {
                    pedModel = "s_m_y_cop_01",
                    coords = {
                        { x = 467.0445,   y = -980.4790, z = 26.0921-1, w = 359.5226 }
                    },
                    zone = {
                        name = "items_lspd",
                        interactLabel = "Armurerie",
                        interactKey = "E",
                        interactIcons = "Gun",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                VFW.Jobs.Catalogue.MenuItems()
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 110, color = 29, scale = 0.8, label = "LSPD - Armurerie" }
                },
            },
        }
    },

    ["lssd"] = {
        Nui = {
            defaultCategory = "Équipements",
            lastCategory = "Équipements",
            headCategory = {
                show = true,
                items = {
                    { label = "Équipements", id = "Équipements" },
                    { label = "Armes",       id = "Armes" },
                    { label = "Kevlar",      id = "Kevlar" },
                }
            }
        },

        Items = {
            ["Équipements"] = {
                {
                    name = "radio",
                    label = "Radio"
                },
                {
                    name = "tabletmdt",
                    label = "MDT"
                },
                {
                    name = "badge_lssd",
                    label = "LSSD - Insigne"
                }
            },
            ["Armes"] = {
                {
                    name = "shield",
                    label = "Bouclier anti-émeute",
                    minGrade = "novice"
                },
                {
                    name = "weapon_smokelspd",
                    label = "Fumigene",
                    minGrade = "novice"
                },
                {
                    name = "weapon_flare",
                    label = "Fusée de détresse",
                    minGrade = "novice"
                },
                {
                    name = "weapon_bzgas",
                    label = "GAZ BZ",
                    minGrade = "novice"
                },
                {
                    name = "weapon_pepperspray",
                    label = "Pepper Spray",
                    minGrade = "novice"
                },
                {
                    name = "weapon_combatpistol",
                    label = "Glock 17",
                    minGrade = "exp"
                },
                {
                    name = "weapon_pumpshotgun",
                    label = "Pompe",
                    minGrade = "copatron"
                },
                {
                    name = "weapon_stungun",
                    label = "Tazer",
                    minGrade = "novice"
                },
                {
                    name = "weapon_tacticalrifle",
                    label = "Colt M4",
                    minGrade = "copatron"
                },
                {
                    name = "weapon_nightstick",
                    label = "Matraque",
                    minGrade = "novice"
                },
                {
                    name = "ammo_pistol",
                    label = "Munition Pistolet",
                    minGrade = "exp"
                },
                {
                    name = "ammo_rifle",
                    label = "Munition Rifle",
                    minGrade = "copatron"
                },
                {
                    name = "ammo_shotgun",
                    label = "Munition Pompe",
                    minGrade = "copatron"
                },       
            },
            ["Kevlar"] = {
                {
                    name = "lssdgiletj",
                    label = "Gilet Jaune",
                },
                {
                    name = "lssdkevle1",
                    label = "Kevlar Class A",
                },
                {
                    name = "lssdkevlo1",
                    label = "Kevlar Class C 1",
                },
                {
                    name = "lssdkevlo2",
                    label = "Kevlar Class C 2",
                },
                {
                    name = "lssdkevlo3",
                    label = "Kevlar Class C 3",
                },
                {
                    name = "lssdkevlo4",
                    label = "Kevlar Class C 4",
                },
                {
                    name = "lssdinsigne",
                    label = "LSSD - Insigne",
                },
                {
                    name = "lssdriot",
                    label = "Protection Anti Emeute",
                },
                {
                    name = "lssdkevle2",
                    label = "Gilet Pare-Couteau",
                },
                {
                    name = "lssdkevlo5",
                    label = "Kevlar Class C 5",
                },
                {
                    name = "lssdkevlo6",
                    label = "Kevlar Class C 6",
                },
                {
                    name = "lssdkevlo7",
                    label = "Kevlar Class C 7",
                },
            }
        },

        Point = {
            Ped = {
                {
                    pedModel = "s_m_y_sheriff_01",
                    coords = {
                        { x = 1835.29, y = 3694.74, z = 33.71, w = 212.88 },
                        { x = -448.3,  y = 7104.12, z = 21.38, w = 109.7 }
                    },
                    zone = {
                        name = "items_lssd",
                        interactLabel = "Armurerie",
                        interactKey = "E",
                        interactIcons = "Gun",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                VFW.Jobs.Catalogue.MenuItems()
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 110, color = 17, scale = 0.8, label = "LSSD - Armurerie" }
                },
            },
        }
    },

    ["sams"] = {
        Nui = {
            defaultCategory = "Équipements",
            lastCategory = "Équipements",
            headCategory = {
                show = true,
                items = {
                    { label = "Équipements", id = "Équipements" },
                    { label = "Kevlar",      id = "Kevlar" },
                }
            }
        },

        Items = {
            ["Équipements"] = {
                {
                    name = "band",
                    label = "Bandages",
                },
                {
                    name = "jumelle",
                    label = "Jumelles",
                },
                {
                    name = "medic",
                    label = "Médicament",
                },
                {
                    name = "medikit",
                    label = "Medikit",
                },
                {
                    name = "pad",
                    label = "Pansement",
                },
                {
                    name = "bequille",
                    label = "Bequille",
                },
                {
                    name = "froulant",
                    label = "Chaise Roulante",
                },
                {
                    name = "poudre",
                    label = "Kit test de poudre",
                },
            },
            ["Kevlar"] = {
                -- {
                --     name = "samskev",
                --     label = "Kevlar Class C",
                -- },
                -- {
                --     name = "medickev2",
                --     label = "SAMS - kevlar",
                -- },
            }
        },

        Point = {
            Ped = {
                {
                    pedModel = "s_f_y_scrubs_01",
                    coords = {
                        { x = 315.2601,  y = -593.9022, z = 43.2655-1, w = 67.7996 }
                        --{ x = -533.65, y = 7375.95, z = 11.84, w = 54.65 }
                    },
                    zone = {
                        name = "items_sams",
                        interactLabel = "Armurerie",
                        interactKey = "E",
                        interactIcons = "Gun",
                        onPress = function()
                            if VFW.PlayerData.job.onDuty then
                                VFW.Jobs.Catalogue.MenuItems()
                            else
                                VFW.ShowNotification({
                                    type = 'ROUGE',
                                    content = "Vous devez être en service pour accéder à cette fonctionnalité."
                                })
                            end
                        end
                    },
                    blip = { sprite = 110, color = 2, scale = 0.8, label = "SAMS - Armurerie" }
                },
            },
        }
    },
}
