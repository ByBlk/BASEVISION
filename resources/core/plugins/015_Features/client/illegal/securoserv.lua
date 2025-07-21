local configPreMenu = {
    buttons = {
        { label = 'Vandalisme', model = 'vandalisme', image = "assets/Illégal/SVG_Gauche/Vendalisme.svg", image2 = "assets/Illégal/SVG_Droite/D.svg", level = 5 },
        { label = 'Vente de drogue', model = 'sell_drugs', image = "assets/Illégal/SVG_Gauche/Vente.svg", image2 = "assets/Illégal/SVG_Droite/D.svg", level = 5 },
        { label = 'Racket', model = 'racket', image = "assets/Illégal/SVG_Gauche/Racket.svg", image2 = "assets/Illégal/SVG_Droite/D.svg", level = 5 },
        { label = 'Vol de sac à main', model = 'racket_bags', image = "assets/Illégal/SVG_Gauche/Sac.svg", image2 = "assets/Illégal/SVG_Droite/C.svg", level = 4 },
        { label = 'Go Fast', model = 'gofast', image = "assets/Illégal/SVG_Gauche/Gofast.svg", image2 = "assets/Illégal/SVG_Droite/A.svg", level = 2 },
        { label = 'Braquage de superette', model = 'holdup_sup', image = "assets/Illégal/SVG_Gauche/Superette.svg", image2 = "assets/Illégal/SVG_Droite/B.svg", level = 3 },
        { label = 'Vol ATM', model = 'racket_atm', image = "assets/Illégal/SVG_Gauche/Atm.svg", image2 = "assets/Illégal/SVG_Droite/C.svg", level = 4 },
        { label = 'Braquage du Vangelico', model = 'holdup_van', image = "assets/Illégal/SVG_Gauche/Vangelico.svg", image2 = "assets/Illégal/SVG_Droite/A.svg", level = 2 },
        { label = 'Braquage de Binco', model = 'holdup_binco', image = "assets/Illégal/SVG_Gauche/Binco.svg", image2 = "assets/Illégal/SVG_Droite/B.svg", level = 3 },
        { label = 'Braquage de Barber', model = 'holdup_barber', image = "assets/Illégal/SVG_Gauche/Barber.svg", image2 = "assets/Illégal/SVG_Droite/C.svg", level = 4 },
        { label = 'Braquage de Tattoo', model = 'holdup_tattoo', image = "assets/Illégal/SVG_Gauche/Tatouage.svg", image2 = "assets/Illégal/SVG_Droite/B.svg", level = 3 },
        { label = 'Braquage d’Ammunation', model = 'holdup_ammu', image = "assets/Illégal/SVG_Gauche/Ammunation.svg", image2 = "assets/Illégal/SVG_Droite/A.svg", level = 2 },
        { label = 'Braquage de Fleeca', model = 'holdup_fleeca', image = "assets/Illégal/SVG_Gauche/Fleeca.svg", image2 = "assets/Illégal/SVG_Droite/S.svg", level =1},
    }
}

local camsPreMenu = {
    PlayerCam = {
        CamCoords = { x = 573.4325561523438, y = -421.4681701660156, z = -69.25531768798828 },
        CamRot = { x = -0.8802985548973, y = -0.0, z = 150.88803100585938 },
        Dof = true,
        COH = { x = 572.6492919921875, y = -422.7774963378906, z = -69.64708709716797, w = 325.5270080566406 },
        Animation = { dict = "anim@mp_corona_idles@male_d@idle_a", anim = "idle_a" },
        DofStrength = 0.9,
        Freeze = false,
        Fov = 45.0
    },
    PedsCam = {
        {
            CamCoords = { x = 573.307861328125, y = -421.9720764160156, z = -68.92048645019531 },
            CamRot = { x = -3.43931889533996, y = 1.0672168571090879e-7, z = 109.01847076416016 },
            Dof = false,
            COH = { x = 571.7780151367188, y = -422.9224853515625, z = -69.64702606201172, w = 305.5227966308594 },
            Animation = { dict = "anim@heists@heist_corona@team_idles@male_a", anim = "idle" },
            DofStrength = 0.0,
            Freeze = false,
            Fov = 45.0
        },
    },
    RandomPeds = {
        `g_m_importexport_01`,
        `g_m_y_armgoon_02`,
        `g_m_y_korean_02`,
        `g_m_y_salvaboss_01`,
        `g_f_y_vagos_01`,
    },
    Peds = {}
}

local function PreMissionData()
    table.sort(configPreMenu.buttons, function(a, b)
        return a.level > b.level
    end)
    local data = {
        style = {
            menuStyle = "custom",
            backgroundType = 1,
            bannerType = 2,
            gridType = 4,
            buyType = 0,
            bannerImg = "assets/catalogues/headers/securoserv.webp",
        },
        eventName = "PreMenuSecuroServ",
        showStats = false,
        mouseEvents = false,
        color = { show = false },
        nameContainer = {
            show = true,
            top = false,
            firstLabel = "Rang",
            secondLabel = "~y~" .. GetCrewRank()
        },
        headCategory = {
            show = true,
            items = {
                { label = "Sélectionnes une missions en fonction de ton Rang", id = nil }
            }
        },
        category = { show = false },
        cameras = { show = false },
        color = { show = false },
        items = configPreMenu.buttons
    }

    return data
end

local configMenu = {
    ["holdup_sup"] = {
        primaryTitle = "SUPERETTE",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/Superette.webp",
        missions = {
            { title = "Menace le caissier avec une arme." },
            { title = "Récupère l’argent et des produits." },
            { title = "Pars rapidement avant l’arrivée des forces de l’ordre." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["holdup_van"] = {
        primaryTitle = "VANGELICO",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/Vangelico.webp",
        missions = {
            { title = "Désactive les alarmes et caméras." },
            { title = "Brise les vitrines et vole les bijoux." },
            { title = "Quitte la bijouterie avant l’intervention policière." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["holdup_ammu"] = {
        primaryTitle = "AMMUNATION",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/ammunation.webp",
        missions = {
            { title = "Entre armé dans le magasin d’armes." },
            { title = "Menace le vendeur et vole armes et munitions." },
            { title = "Sors rapidement avant l’arrivée des autorités." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["holdup_binco"] = {
        primaryTitle = "BINCO",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/binco.webp",
        missions = {
            { title = "Menace le personnel avec une arme." },
            { title = "Prends l’argent dans la caisse." },
            { title = "Fuis rapidement avant l’arrivée des forces de l’ordre." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["gofast"] = {
        primaryTitle = "GO FAST",
        secondaryTitle = "LIVRAISON",
        backgroundImg = "assets/Illégal/Image/GoFast.webp",
        missions = {
            { title = "Charge la voiture avec des produits illégaux." },
            { title = "Conduis à grande vitesse vers la livraison." },
            { title = "Évite les barrages policiers." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["racket"] = {
        primaryTitle = "RACKET",
        secondaryTitle = "VOL",
        backgroundImg = "assets/Illégal/Image/racket.webp",
        missions = {
            { title = "Intimide une victime isolée avec un couteau." },
            { title = "Prends son argent ou ses objets de valeur." },
            { title = "Pars avant d’attirer l’attention." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["racket_atm"] = {
        primaryTitle = "ATM",
        secondaryTitle = "VOL",
        backgroundImg = "assets/Illégal/Image/ATM.webp",
        missions = {
            { title = "Frappe l’ATM jusqu’à l’endommager." },
            { title = "Récupère les billets." },
            { title = "Fuis avant l’arrivée de la police." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["racket_bags"] = {
        primaryTitle = "VOL DE SAC",
        secondaryTitle = "VOL",
        backgroundImg = "assets/Illégal/Image/volàlarraché.webp",
        missions = {
            { title = "Cible une victime inattentive." },
            { title = "Arrache son sac en la menaçant." },
            { title = "Disparais rapidement dans la foule." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["sell_drugs"] = {
        primaryTitle = "VENTE DE DROGUE",
        secondaryTitle = "VENTE",
        backgroundImg = "assets/Illégal/Image/Vente.webp",
        missions = {
            { title = "Trouve un client discret." },
            { title = "Échange la drogue contre l’argent." },
            { title = "Pars rapidement sans attirer l’attention." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["gofast_mari"] = {
        primaryTitle = "MARITIME",
        secondaryTitle = "LIVRAISON",
        backgroundImg = "assets/Illégal/Image/gofastmaritime.webp",
        missions = {
            { title = "Charge un bateau rapide avec des produits illégaux." },
            { title = "Navigue à grande vitesse vers le point de livraison." },
            { title = "Évite les patrouilles maritimes et accoste discrètement." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["holdup_fleeca"] = {
        primaryTitle = "FLEECA",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/Fleeca.webp",
        missions = {
            { title = "Pénètre dans la banque avec des armes." },
            { title = "Neutralise les caméras et contrôle les civils." },
            { title = "Vide le coffre ou les caisses, puis fuis avant l’intervention policière." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["carjacking"] = {
        primaryTitle = "CARJACKING",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/Carjacking.webp",
        missions = {
            { title = "Menace un conducteur à l’arrêt avec une arme." },
            { title = "Sors-le du véhicule et prends sa place." },
            { title = "Démarre vite et change de plaque si besoin." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["vandalisme"] = {
        primaryTitle = "VANDALISME",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/vandalisme.webp",
        missions = {
            { title = "Dégrade un mur, une vitrine ou un véhicule." },
            { title = "Assure-toi de ne pas être vu." },
            { title = "Quitte les lieux avant l’arrivée des autorités." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["carjack_contenair"] = {
        primaryTitle = "CONTENEUR",
        secondaryTitle = "VOL",
        backgroundImg = "assets/Illégal/Image/Contenaire.webp",
        missions = {
            { title = "Repère un conteneur isolé et peu surveillé." },
            { title = "Force l’ouverture à l’aide d’outils ou d’explosifs." },
            { title = "  Récupère le contenu de valeur et évacue rapidement." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["holdup_barber"] = {
        primaryTitle = "BARBER",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/barber.webp",
        missions = {
            { title = "Intimide le barbier avec une arme." },
            { title = "Vide la caisse et prends des produits chers." },
            { title = "Quitte les lieux avant l'arrivée de la police." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },

    ["holdup_tattoo"] = {
        primaryTitle = "TATTOO",
        secondaryTitle = "BRAQUAGE",
        backgroundImg = "assets/Illégal/Image/Tatouage.webp",
        missions = {
            { title = "Menace le tatoueur avec une arme." },
            { title = "Prends l'argent de la caisse et du matériel de valeur." },
            { title = "Fuis rapidement sans te faire repérer." }
        },
        butin = 1456,
        influ = "30 Points",
        crew = "600 Points",
    },
}

local camsMenu = {
    ["holdup_sup"] = {
        Freeze = false,
        COH = { x = 1154.9190673828126, y = -324.9925231933594, z = 69.2051010131836, w = 114.47367095947266 },
        DofStrength = 1.0,
        Animation = { dict = "male_gun@vanessssi", anim = "male_gun_clip" },
        CamCoords = { x = 1153.8529052734376, y = -325.5132141113281, z = 69.86520385742188 },
        CamRot = { x = -8.52125644683837, y = -0.0, z = -58.82867431640625 },
        Fov = 40.1,
        Dof = true,
        Weapon = "weapon_heavypistol"
    },

    ["holdup_van"] = {
        DofStrength = 0.9,
        Fov = 55.1,
        CamRot = { x = -3.5943694114685, y = -0.0, z = -30.44449043273925 },
        Dof = true,
        Animation = { anim = "aim_weapon_6_walk_clip", dict = "anim@male@aim_weapon_6_walk" },
        CamCoords = { x = -626.8641967773438, y = -237.3528289794922, z = 38.45623016357422 },
        Freeze = true,
        COH = { x = -626.1397705078125, y = -236.25079345703126, z = 38.05703353881836, w = 127.11808013916016 },
        Weapon = "weapon_carbinerifle"
    },

    ["holdup_ammu"] = {
        DofStrength = 1.0,
        Fov = 53.1,
        CamRot = { x = -3.01577734947204, y = -0.0, z = 30.55535125732422 },
        Dof = true,
        Animation = { anim = "aim_weapon_6_walk_clip", dict = "anim@male@aim_weapon_6_walk" },
        CamCoords = { x = 18.01784515380859, y = -1113.6258544921876, z = 30.16120719909668 },
        Freeze = true,
        COH = { x = 17.35263061523437, y = -1112.41357421875, z = 29.79721069335937, w = 194.18817138671876 },
        Weapon = "weapon_sawnoffshotgun"
    },

    ["holdup_binco"] = {
        Dof = true,
        DofStrength = 1.0,
        CamCoords = { x = -817.4323120117188, y = -1076.87060546875, z = 11.71768188476562 },
        Freeze = true,
        Animation = { anim = "aim_weapon_6_walk_clip", dict = "anim@male@aim_weapon_6_walk" },
        Fov = 50.1,
        COH = { x = -818.4624633789063, y = -1076.110595703125, z = 11.32791900634765, w = 217.31954956054688 },
        CamRot = { x = -1.00913047790527, y = -0.0, z = 56.61582565307617 },
        Weapon = "weapon_combatpistol"
    },

    ["gofast"] = {
        Dof = true,
        DofStrength = 0.9,
        CamCoords = { x = 1105.5330810546876, y = -3156.990234375, z = -37.2913932800293 },
        Freeze = false,
        Animation = {
            anim = "idle",
            dict = "anim@heists@box_carry@",
            prop = "bkr_prop_weed_bigbag_01a",
            propPlacement = { 0.158, -0.05, 0.23, -50.0, 290.0, 0.0 },
            propBone = 60309
        },
        Fov = 50.1,
        COH = { x = 1107.1142578125, y = -3157.935302734375, z = -37.51860046386719, w = 62.53302001953125 },
        CamRot = { x = -1.39093077182769, y = -0.0, z = -129.05035400390626 },
    },

    ["racket"] = {
        DofStrength = 1.0,
        Fov = 50.1,
        CamRot = { x = -2.47506070137023, y = 5.336084996088175e-8, z = 165.1239471435547 },
        Dof = true,
        Animation = { anim = "thrtn_clip", dict = "sureno@thrtn" },
        CamCoords = { x = -62.51018905639648, y = -1222.7989501953126, z = 29.25981330871582 },
        Freeze = false,
        COH = { x = -62.98168182373047, y = -1223.903564453125, z = 28.76021003723144, w = 336.36517333984377 },
        Weapon = "weapon_knife"
    },

    ["racket_atm"] = {
        Freeze = false,
        COH = { x = 108.6541748046875, y = -779.2398681640625, z = 31.44403076171875, w = 166.10252380371095 },
        DofStrength = 1.0,
        Animation = { dict = "bat@sel", anim = "bat_clip" },
        CamCoords = { x = 108.52667999267578, y = -780.220947265625, z = 31.93612098693847 },
        CamRot = { x = -3.67085886001586, y = 2.6680428533154555e-8, z = -5.55916261672973 },
        Fov = 50.1,
        Dof = true,
        Weapon = "weapon_bat"
    },

    ["racket_bags"] = {
        DofStrength = 1.0,
        Fov = 50.1,
        CamRot = { x = -2.04373264312744, y = 5.336085706630911e-8, z = 71.31584930419922 },
        Dof = true,
        Animation = { dict = "underground_crips@sharror", anim = "underground_crips_clip_ierrorr" },
        CamCoords = { x = 351.5697021484375, y = 161.46041870117188, z = 103.51579284667969 },
        Freeze = false,
        COH = { x = 350.42047119140627, y = 161.95626831054688, z = 103.10456848144531, w = 248.9000244140625 },
        Weapon = "weapon_knife"
    },

    ["sell_drugs"] = {
        DofStrength = 1.0,
        Fov = 55.1,
        CamRot = { x = -2.29539442062377, y = -0.0, z = 39.61225891113281 },
        Dof = true,
        Animation = {
            anim = "mp_m_waremech_01_dual-0",
            dict = "impexp_int-0",
            prop = "prop_weed_block_01",
            propPlacement = { 0.1, 0.1, 0.05, 0.0, -90.0, 90.0 },
            propBone = 60309
        },
        CamCoords = { x = 989.1387329101563, y = -145.82229614257813, z = -48.62121200561523 },
        Freeze = false,
        COH = { x = 988.421875, y = -144.79684448242188, z = -48.9996337890625, w = 209.9323272705078 }
    },

    ["gofast_mari"] = {
        Dof = true,
        DofStrength = 0.9,
        CamCoords = { x = -752.2833862304688, y = -1343.0782470703126, z = 1.8244959115982 },
        Freeze = false,
        Animation = {
            anim = "idle",
            dict = "anim@heists@box_carry@",
            prop = "hei_prop_heist_box",
            propPlacement = { 0.025, 0.08, 0.255, -145.0, 290.0, 0.0 },
            propBone = 60309
        },
        Fov = 50.1,
        COH = { x = -750.5657958984375, y = -1342.8173828125, z = 1.59554874897003, w = 100.86954498291016 },
        CamRot = { x = -0.32566767930984, y = 1.6675267833221597e-9, z = -87.7209243774414 }
    },

    ["holdup_fleeca"] = {
        DofStrength = 1.0,
        Fov = 50.1,
        CamRot = { x = -1.29335129261016, y = -0.0, z = 160.483154296875 },
        Dof = true,
        Animation = { anim = "highready_relaxed_clip", dict = "anim@male_tactical_highready_relaxed" },
        CamCoords = { x = 313.43115234375, y = -287.2868957519531, z = 54.66276168823242 },
        Freeze = false,
        COH = { x = 312.8985290527344, y = -288.24462890625, z = 54.14305114746094, w = 337.9511413574219 },
        Weapon = "weapon_compactrifle"
    },

    ["carjacking"] = {
        Fov = 50.1,
        Freeze = false,
        CamCoords = { x = 1000.010498046875, y = -3159.043701171875, z = -38.50889587402344 },
        Dof = true,
        COH = { x = 1000.6317749023438, y = -3160.08837890625, z = -38.9074821472168, w = 29.26829528808593 },
        Vehicle = 662793086,
        Invisible = false,
        DofStrength = 1.0,
        CamRot = { x = -1.36072969436645, y = -5.336084996088175e-8, z = -143.99951171875 },
        Animation = { dict = "fuckm@nxsty", anim = "fuckm_clip" },
        Weapon = "weapon_crowbar"
    },

    ["vandalisme"] = {
        Freeze = false,
        COH = { x = 1399.0650634765626, y = 3603.6953125, z = 38.94193649291992, w = 216.5245361328125 },
        DofStrength = 1.0,
        Animation = { dict = "victory@sharror", anim = "victory_clip_ierrorr" },
        CamCoords = { x = 1399.7015380859376, y = 3602.916015625, z = 39.48204803466797 },
        CamRot = { x = -4.79298830032348, y = -2.1344337142181758e-7, z = 44.6666259765625 },
        Fov = 50.1,
        Dof = true,
        Weapon = "weapon_battleaxe"
    },

    ["carjack_contenair"] = {
        Fov = 50.1,
        Freeze = false,
        CamCoords = { x = -379.8533630371094, y = -4101.6943359375, z = 9.77544498443603 },
        Dof = true,
        COH = { x = -378.8624572753906, y = -4100.95556640625, z = 9.31920146942138, w = 119.83924102783203 },
        Invisible = false,
        Animation = { dict = "stand_cute_6@dark", anim = "stand_cute_6_clip" },
        CamRot = { x = -4.38948249816894, y = -2.1344337142181758e-7, z = -50.89339447021484 },
        DofStrength = 1.0,
        Weapon = "weapon_wrench"
    },

    ["holdup_barber"] = {
        DofStrength = 0.9,
        Fov = 45.1,
        CamRot = { x = -2.71317982673645, y = -5.336085706630911e-8, z = -72.21082305908203 },
        Dof = true,
        Animation = { dict = "anim@male@handgun_pose", anim = "handgun_pose_clip" },
        CamCoords = { x = -821.2754516601563, y = -187.0718994140625, z = 38.09665298461914 },
        Freeze = false,
        COH = { x = -819.81103515625, y = -186.71237182617188, z = 37.56891632080078, w = 102.0472412109375 },
        Weapon = "weapon_combatpistol"
    },

    ["holdup_tattoo"] = {
        COH = { x = -1153.6380615234376, y = -1425.6427001953126, z = 4.95595121383667, w = 4.90643215179443 },
        DofStrength = 0.9,
        CamCoords = { x = -1153.74951171875, y = -1424.4927978515626, z = 5.58002996444702 },
        Fov = 45.1,
        Dof = true,
        Freeze = false,
        CamRot = { x = -8.47863864898681, y = 1.0672171413261822e-7, z = -170.5725555419922 },
        CamEffectsAmplitude = 0.9,
        Animation = { anim = "male_gun_clip", dict = "male_gun@vanessssi" },
        Weapon = "weapon_combatpistol"
    }
}

local vehMenu = {
    ["gofast"] = {
        {
            vehicle = "tailgater2",
            coords = vector3(1108.4825439453126, -3162.616943359375, -38.1534194946289),
            heading = 200.6276397705078,
            coffreOpen = true
        }
    },
    ["gofast_mari"] = {
        {
            vehicle = "dinghy",
            coords = vector3(-744.8348999023438, -1346.146240234375, 0.11953425407409),
            heading = 233.89450073242188,
            coffreOpen = false
        }
    },
    ["carjacking"] = {
        {
            vehicle = "gbargento7f",
            coords = vector3(1002.0, -3167.38, -40.2),
            heading = 25.34,
            coffreOpen = false
        },
        {
            vehicle = "iwagen",
            coords = vector3(1006.06, -3163.93, -40.45),
            heading = 102.23,
            coffreOpen = false
        }
    }
}

local clonePed = nil
local model = nil

local function SecuroServMenu(category)
    local data = {
        style = {
            menuStyle = "securoserv",
            backgroundType = 1,
            bannerType = 1,
            gridType = 1,
            buyType = 0,
            bannerImg = "assets/catalogues/headers/securoserv.webp",
        },
        eventName = "securoservcata",
        showStats = { show = false },
        category = { show = false },
        cameras = { show = false },
        nameContainer = { show = false },
        headCategory = {
            show = true,
            items = {
                { label = "Missions illégales", id = nil },
            }
        },
        color = { show = false },
        items = {},
        securoserv = configMenu[category],
    }

    return data
end

local function setupWorld()
    NetworkOverrideClockTime(0, 0, 0)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
end

local function createPed(hash, x, y, z, h)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
    end
    local ped = CreatePed(4, hash, x, y, z, h)
    SetModelAsNoLongerNeeded(hash)
    return ped
end

local function deleteCams(name)
    VFW.Nui.HudVisible(false)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    VFW.Cam:Destroy(name)
    DeleteEntity(camsPreMenu.Ped)
    if camsPreMenu.Peds and next(camsPreMenu.Peds) then
        for i = 1, #camsPreMenu.Peds do
            DeleteEntity(camsPreMenu.Peds[i])
        end
    end
    ClearFocus()
    DoScreenFadeIn(1000)
    VFW.Nui.HudVisible(true)
end

local function createCam(securoservTable, multipleTable, data)
    local ped
    local clonePlayer, tattooPlayer = TriggerServerCallback("core:faction:getClonePed", VFW.PlayerData.faction.name)
    if (not data) then
        camsPreMenu.Ped = ClonePed(VFW.PlayerData.ped, false, false)
        VFW.Cam:Create("missionPreMenu", securoservTable, camsPreMenu.Ped)
        ped = camsPreMenu.Ped
    elseif data and data.ped == "random" then
        math.randomseed(GetGameTimer())
        local randomizedPed = camsPreMenu.RandomPeds[math.random(1, #camsPreMenu.RandomPeds)]
        camsPreMenu.Peds[#camsPreMenu.Peds + 1] = createPed(randomizedPed, securoservTable.COH.x, securoservTable.COH.y, securoservTable.COH.z, securoservTable.COH.w)
        SetModelAsNoLongerNeeded(randomizedPed)
        VFW.Cam:UpdateAnim(nil, securoservTable.Animation, camsPreMenu.Peds[#camsPreMenu.Peds])
        ped = camsPreMenu.Peds[#camsPreMenu.Peds]
    elseif data and data.ped == "player" then
        math.randomseed(GetGameTimer())
        camsPreMenu.Peds[#camsPreMenu.Peds + 1] = VFW.CreatePlayerClone(clonePlayer, tattooPlayer, vector3(securoservTable.COH.x, securoservTable.COH.y, securoservTable.COH.z), securoservTable.COH.w)
        VFW.Cam:UpdateAnim(nil, securoservTable.Animation, camsPreMenu.Peds[#camsPreMenu.Peds])
        ped = camsPreMenu.Peds[#camsPreMenu.Peds]
    end
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityVisible(ped, false, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetFocusPosAndVel(securoservTable.COH.x, securoservTable.COH.y, securoservTable.COH.z - 1.0)
    SetEntityCoords(ped, securoservTable.COH.x, securoservTable.COH.y, securoservTable.COH.z)
    Wait(100)
    SetEntityVisible(ped, true, false)
    SetEntityHeading(ped, securoservTable.COH.w)
    SetEntityCoords(ped, securoservTable.COH.x, securoservTable.COH.y, securoservTable.COH.z - 1.0)
    if not clonePlayer then
        if multipleTable then
            for i = 1, #multipleTable do
                createCam(multipleTable[i], nil, { ped = "random" })
            end
        end
    else
        if multipleTable then
            for i = 1, #multipleTable do
                createCam(multipleTable[i], nil, { ped = "player" })
            end
        end
    end
    DoScreenFadeIn(1000)
end

function OpenSecuroServCenter()
    if not IsPedInAnyVehicle(VFW.PlayerData.ped, false) and not IsPedRunning(VFW.PlayerData.ped) then
        VFW.Nui.HudVisible(false)
        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        setupWorld()
        createCam(camsPreMenu.PlayerCam, camsPreMenu.PedsCam)
        VFW.Nui.NewGrandMenu(true, PreMissionData())
        TriggerServerEvent("core:server:instanceJobCenter", true)
    else
        console.debug("You cannot relog while in a vehicle or running.")
    end
end

RegisterNuiCallback("nui:newgrandcatalogue:PreMenuSecuroServ:selectGridType4", function(data)
    if not data then
        return
    end
    VFW.Nui.NewGrandMenu(false)
    VFW.Nui.HudVisible(false)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    deleteCams("missionPreMenu")
    VFW.Nui.HudVisible(false)
    clonePed = ClonePed(VFW.PlayerData.ped, false, false)
    local cam = camsMenu[data]
    SetEntityAsMissionEntity(clonePed, true, true)
    SetEntityVisible(clonePed, false, false)
    SetBlockingOfNonTemporaryEvents(clonePed, true)
    SetFocusPosAndVel(cam.COH.x, cam.COH.y, cam.COH.z - 1.0)
    SetEntityCoords(clonePed, cam.COH.x, cam.COH.y, cam.COH.z)
    Wait(100)
    SetEntityVisible(clonePed, true, false)
    SetEntityHeading(clonePed, cam.COH.w)
    SetEntityCoords(clonePed, cam.COH.x, cam.COH.y, cam.COH.z - 1.0)
    GiveWeaponToPed(clonePed, GetHashKey(cam.Weapon), 250, false, true)
    SetCurrentPedWeapon(clonePed, GetHashKey(cam.Weapon), true)
    if vehMenu[data] then
        for i = 1, #vehMenu[data] do
            VFW.Streaming.RequestModel(GetHashKey(vehMenu[data][i].vehicle))
            model = CreateVehicle(
                    GetHashKey(vehMenu[data][i].vehicle),
                    vehMenu[data][i].coords.x, vehMenu[data][i].coords.y, vehMenu[data][i].coords.z - 1.0,
                    vehMenu[data][i].heading,
                    false, false
            )
            SetVehicleDoorsLocked(model, 2)
            if vehMenu[data][i].coffreOpen then
                SetVehicleDoorOpen(model, 5, false, false)
            end
            cEntity.Visual.AddEntityToException(model)
        end
    end
    VFW.Cam:Create("missionMenu", cam, clonePed)
    DoScreenFadeIn(1000)
    VFW.Nui.NewGrandMenu(true, SecuroServMenu(data))
end)

RegisterNuiCallback("nui:newgrandcatalogue:securoservcata:backspace", function()
    VFW.Nui.NewGrandMenu(false)
    VFW.Nui.HudVisible(false)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    if clonePed and DoesEntityExist(clonePed) then
        VFW.Cam:Destroy("missionMenu")
        DeleteEntity(clonePed)
        clonePed = nil
    end
    if model and DoesEntityExist(model) then
        VFW.Game.DeleteVehicle(model)
        model = nil
    end
    createCam(camsPreMenu.PlayerCam, camsPreMenu.PedsCam)
    VFW.Nui.NewGrandMenu(true, PreMissionData())
end)

RegisterNuiCallback("nui:newgrandcatalogue:PreMenuSecuroServ:close", function()
    VFW.Nui.NewGrandMenu(false)
    deleteCams("missionPreMenu")
    TriggerServerEvent("core:server:instanceJobCenter", false)
end)

RegisterNuiCallback("nui:newgrandcatalogue:securoservcata:close", function()
    VFW.Nui.NewGrandMenu(false)
    VFW.Nui.HudVisible(false)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    if clonePed and DoesEntityExist(clonePed) then
        VFW.Cam:Destroy("missionMenu")
        DeleteEntity(clonePed)
        clonePed = nil
    end
    if model and DoesEntityExist(model) then
        VFW.Game.DeleteVehicle(model)
        model = nil
    end
    ClearFocus()
    DoScreenFadeIn(1000)
    TriggerServerEvent("core:server:instanceJobCenter", false)
end)

local configAcess = {
    ["vandalisme"] = "D",
    ["sell_drugs"] = "D",
    ["racket"] = "D",
    ["racket_bags"] = "D",
    ["carjack_contenair"] = "D",
    ["gofast"] = "D",
    ["gofast_mari"] = "D",
    ["holdup_sup"] = "D",
    ["racket_atm"] = "D",
    ["holdup_van"] = "D",
    ["holdup_binco"] = "D",
    ["holdup_ammu"] = "D",
    ["holdup_fleeca"] = "D",
    ["holdup_barber"] = "D",
    ["holdup_tattoo"] = "D",
    ["carjacking"] = "D",
    ["holdup_yatch"] = "D"
}

local function GetRankBraquage(name)
    if configAcess[name] then
        return configAcess[name]
    end

    return "D"
end

local function GetRankIndex(rank)
    local ranks = { "D", "C", "B", "A", "S" }

    for i, r in ipairs(ranks) do
        if r == rank then
            return i
        end
    end

    return nil
end

local noSpam = {}

function VFW.CanAccessAction(name)
    if noSpam[name] then
        return noSpam[name].value
    end
    local crewRank = GetCrewRank()
    local actionRank = GetRankBraquage(name)

    local playerRankIndex = GetRankIndex(crewRank)
    local actionRankIndex = GetRankIndex(actionRank)

    if playerRankIndex and actionRankIndex and playerRankIndex >= actionRankIndex then
        noSpam[name] = { value = true }
        return true
    else
        noSpam[name] = { value = false }
        return false
    end
end
