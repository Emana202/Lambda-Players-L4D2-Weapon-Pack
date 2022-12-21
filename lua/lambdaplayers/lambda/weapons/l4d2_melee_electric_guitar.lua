table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_electric_guitar = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_electric_guitar.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Electric Guitar",
        holdtype = "melee2",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_electric_guitar",
        ismelee = true,
        keepdistance = 10,
        attackrange = 70,
        bonemerge = true,
        islethal = true,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
            wepent.L4D2Data.RateOfFire = { 0.9, 1.1 }
            wepent.L4D2Data.Sound = {
                "lambdaplayers/weapons/l4d2/melee/guitar/guitar_swing_miss1.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/guitar_swing_miss2.mp3"
            }
            wepent.L4D2Data.HitDelay = 0.275
            wepent.L4D2Data.Range = 65
            wepent.L4D2Data.Damage = { 50, 55 }
            wepent.L4D2Data.DamageType = DMG_CLUB
            wepent.L4D2Data.HitSound = {
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_1.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_2.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_3.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_4.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_5.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_6.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_7.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_8.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_9.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_10.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_11.mp3",
                "lambdaplayers/weapons/l4d2/melee/guitar/melee_guitar_12.mp3"
            }

            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})