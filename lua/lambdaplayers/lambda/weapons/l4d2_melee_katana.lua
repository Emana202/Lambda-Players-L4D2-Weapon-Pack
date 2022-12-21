table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_katana = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_katana.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Katana",
        holdtype = "melee2",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_katana",
        ismelee = true,
        keepdistance = 10,
        attackrange = 70,
        bonemerge = true,
        islethal = true,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
            wepent.L4D2Data.RateOfFire = { 0.7, 0.8 }
            wepent.L4D2Data.Sound = {
                "lambdaplayers/weapons/l4d2/melee/katana/katana_swing_miss1.mp3",
                "lambdaplayers/weapons/l4d2/melee/katana/katana_swing_miss2.mp3"
            }
            wepent.L4D2Data.HitDelay = 0.225
            wepent.L4D2Data.Range = 65
            wepent.L4D2Data.Damage = { 55, 65 }
            wepent.L4D2Data.HitSound = {
                "lambdaplayers/weapons/l4d2/melee/katana/melee_katana_01.mp3",
                "lambdaplayers/weapons/l4d2/melee/katana/melee_katana_02.mp3",
                "lambdaplayers/weapons/l4d2/melee/katana/melee_katana_03.mp3"
            }
            
            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})