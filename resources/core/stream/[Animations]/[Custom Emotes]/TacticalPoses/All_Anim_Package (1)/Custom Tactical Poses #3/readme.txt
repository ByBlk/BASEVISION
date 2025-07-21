Thank you for your purchase.

Singleplayer

How to install:

1. Use Jennie's custom anims mod add-on folder.
https://www.gta5-mods.com/misc/custom-animations-add-on-customanims

2. Drag the .ycd files to clip_amb@.rpf file.

3. Put this line to menyoostuff/favoriteanims.xml

	<Anim dict="anim@handgun_hold_flsh" name="hold_flsh" />
	<Anim dict="anim@cod_pose" name="fast_swap_pistol" />
    	<Anim dict="anim@rifle_pose_hand" name="one_hand" />
    	<Anim dict="anim@aim_rifle_target" name="aim_left" />
    	<Anim dict="anim@point_target" name="pointing_target" />
    	<Anim dict="anim@rifle_grenade_launcher" name="rifle_gl_walk" />
    	<Anim dict="anim@rifle_gl_shoot" name="gl_shoot" />
   	<Anim dict="anim@rifle_posing_hand" name="metal_hand" />
   	<Anim dict="anim@rifle_gl_crouch" name="gl_crouch" />

PEMOTES USERS ON FIVEM: 

NOTE: For prop placement, please use this guide
https://forum.cfx.re/t/how-to-menyoo-to-dpemotes-conversion-streaming-custom-add-on-props/4775018

Place the ycd files into this folder:

resources/dpemotes-master/streams 

Then copy this line into your AnimationList.lua  

["handgunholdflsh"] = {
        "anim@handgun_hold_flsh",
        "hold_flsh",
        "Handgun Hold Flsh",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },

["codpose"] = {
        "anim@cod_pose",
        "fast_swap_pistol",
        "Fast Swap Pistol",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["rifleposehand"] = {
        "anim@rifle_pose_hand",
        "one_hand",
        "One Hand Down",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["aimrifletarget"] = {
        "anim@aim_rifle_target",
        "aim_left",
        "Aiming Left",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["pointtarget"] = {
        "anim@point_target",
        "pointing_target",
        "Pointing Target",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["riflegrenadelauncher"] = {
        "anim@rifle_grenade_launcher",
        "rifle_gl_walk",
        "Rifle GL Walk",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["rifleglshoot"] = {
        "anim@rifle_gl_shoot",
        "gl_shoot",
        "Rifle GL Shoot",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["rifleposinghand"] = {
        "anim@rifle_posing_hand",
        "metal_hand",
        "Metal Hand",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["rifleglcrouch"] = {
        "anim@rifle_gl_crouch",
        "gl_crouch",
        "Rifle GL Crouch",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },