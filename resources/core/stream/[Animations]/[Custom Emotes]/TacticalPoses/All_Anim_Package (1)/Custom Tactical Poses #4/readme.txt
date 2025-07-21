Thank you for your purchase.

Singleplayer

How to install:

1. Use Jennie's custom anims mod add-on folder.
https://www.gta5-mods.com/misc/custom-animations-add-on-customanims

2. Drag the .ycd files to clip_amb@.rpf file.

3. Put this line to menyoostuff/favoriteanims.xml

	<Anim dict="anim@rifle_tablet" name="holding_tablet" />
    	<Anim dict="anim@hand_signal" name="howdy_yeah" />
    	<Anim dict="anim@rifle_lean_wall" name="lean_anim" />
    	<Anim dict="anim@posing_hat" name="tilt_hat" />
    	<Anim dict="anim@rifle_walk_one" name="one_hand" />
    	<Anim dict="anim@rifle_posing_sit" name="sit_pose" />
    	<Anim dict="anim@rifle_pose_fist_bump" name="fist_bump" />
    	<Anim dict="anim_rifle_buddy_fist_bump" name="buddy_fist_bump" />
    	<Anim dict="anim@rifle_hold_belt" name="holding_belt" />

PEMOTES USERS ON FIVEM: 

NOTE: For prop placement, please use this guide
https://forum.cfx.re/t/how-to-menyoo-to-dpemotes-conversion-streaming-custom-add-on-props/4775018

Place the ycd files into this folder:

resources/dpemotes-master/streams 

Then copy this line into your AnimationList.lua  

["rifletablet"] = {
        "anim@rifle_tablet",
        "holding_tablet",
        "Holding Tablet",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },

["handsignal"] = {
        "anim@hand_signal",
        "howdy_yeah",
        "Howdy Yeah",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["rifleleanwall"] = {
        "anim@rifle_lean_wall",
        "lean_anim",
        "Leaning Wall",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["posinghat"] = {
        "anim@posing_hat",
        "tilt_hat",
        "Tilt Hat",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
[riflewalkone"] = {
        "anim@rifle_walk_one",
        "one_hand",
        "Walk One Hand",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["rifleposingsit"] = {
        "anim@rifle_posing_sit",
        "sit_pose",
        "Sit Pose",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["riflefistbump"] = {
        "anim@rifle_pose_fist_bump",
        "fist_bump",
        "Rifle Fist Bump",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["riflebuddyfistbump"] = {
        "anim_rifle_buddy_fist_bump",
        "buddy_fist_bump",
        "Buddy Fist Bump",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },
["rifleholdbelt"] = {
        "anim@rifle_hold_belt",
        "holding_belt",
        "Rifle Holding Belt",
        AnimationOptions = {
            EmoteLoop = true,
            EmoteMoving = false,
        }
    },